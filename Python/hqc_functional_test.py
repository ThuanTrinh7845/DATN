"""
HQC FUNCTIONAL CORRECTNESS VERIFICATION
=========================================
Script độc lập chạy trên PYNQ (Kria KV260).
Tự động: sinh seed → keygen → encap → decap → so sánh ss.
Lặp N_TESTS lần, ghi log CSV + summary.
"""

from pynq import Overlay
import os
import time
import struct
import csv
from datetime import datetime

# ============================================================
# CẤU HÌNH
# ============================================================
BITFILE  = "hqc_accelerator.bit"
N_TESTS  = 10
LOG_FILE = "functional_test_results.csv"
SUMMARY  = "functional_test_summary.txt"

# ============================================================
# REGISTER & BIT DEFINITIONS
# ============================================================
CTRL_OFFSET  = 0x00
ADDR_OFFSET  = 0x04
WDATA_OFFSET = 0x08
RDATA_OFFSET = 0x0C

BIT_RESET      = (1 << 0)
BIT_START      = (1 << 1)
BIT_OP_ENCAP   = (1 << 2)
OP_DECAP       = (0b10 << 2)
BIT_WR_SK_SEED = (1 << 4)
BIT_WR_PK_SEED = (1 << 5)
BIT_WR_EN      = (1 << 6)
BIT_RD_EN      = (1 << 12)

ADDR_STATUS = 0xFFFFFFFF

# RAM select (bits [9:7])
RAM_H   = 0
RAM_S   = 1
RAM_U   = 2
RAM_V   = 3
RAM_Y   = 4
RAM_D   = 5
RAM_MSG = 6

# Encap output type (bits [14:13])
OUT_TYPE_SS = 0
OUT_TYPE_D  = 1
OUT_TYPE_U  = 2
OUT_TYPE_V  = 3

# Keygen output select
KG_OUT_X = 0
KG_OUT_Y = 1
KG_OUT_H = 2
KG_OUT_S = 3

# HQC-128 parameters
SEED_WORDS  = 10
N_MEM_WIDTH = 139
X_Y_ENTRIES = 66
MSG_DEPTH   = 4
SS_WORDS    = 16
D_WORDS     = 16
Y_DEPTH     = 66
D_DEPTH     = 16


def RAM_SEL(sel):    return (sel & 0x7) << 7
def WORD_SEL(w):     return (w & 0x3) << 10
def OUT_TYPE(t):     return (t & 0x3) << 13


def swap32(val):
    return (((val & 0xFF) << 24) |
            ((val & 0xFF00) << 8) |
            ((val & 0xFF0000) >> 8) |
            ((val & 0xFF000000) >> 24))


def rand_seed():
    raw = os.urandom(SEED_WORDS * 4)
    return [struct.unpack('<I', raw[i*4:(i+1)*4])[0] for i in range(SEED_WORDS)]


def rand_msg():
    return [struct.unpack('<I', os.urandom(4))[0] for _ in range(MSG_DEPTH)]


# ============================================================
# UNIFIED DRIVER — dùng chung 1 IP cho cả 3 phase
# ============================================================
class HQCDriver:
    def __init__(self, bitfile):
        print("[HQC] Loading overlay...")
        self.ol = Overlay(bitfile)
        self.ip = self.ol.axi_wrapper_0
        print(f"[HQC] Ready @ 0x{self.ip.mmio.base_addr:08X}")

    # ---------- register access ----------
    def wr_ctrl(self, v):  self.ip.write(CTRL_OFFSET,  v & 0xFFFFFFFF)
    def wr_addr(self, v):  self.ip.write(ADDR_OFFSET,  v & 0xFFFFFFFF)
    def wr_wdata(self, v): self.ip.write(WDATA_OFFSET, v & 0xFFFFFFFF)
    def rd_rdata(self):    return self.ip.read(RDATA_OFFSET)

    # ---------- reset ----------
    def reset(self):
        self.wr_ctrl(BIT_RESET)
        self.wr_ctrl(0)

    # ---------- poll done ----------
    def wait_done(self, timeout=60.0):
        self.wr_addr(ADDR_STATUS)
        t0 = time.time()
        while True:
            if self.rd_rdata() & 0x1:
                return True
            if time.time() - t0 > timeout:
                return False
            time.sleep(0.001)

    # ---------- load helpers ----------
    def _load_seed(self, words, wr_bit):
        ctrl = 0
        for i, w in enumerate(words):
            self.wr_wdata(w)
            self.wr_addr(i)
            self.wr_ctrl(ctrl | wr_bit)
            self.wr_ctrl(ctrl & ~wr_bit)

    def _load_ram_128(self, data, ram_sel):
        for i, val in enumerate(data):
            self.wr_addr(i)
            tmp = val
            for w in range(4):
                self.wr_ctrl(WORD_SEL(w))
                self.wr_wdata(tmp & 0xFFFFFFFF)
                tmp >>= 32
            self.wr_ctrl(WORD_SEL(3) | RAM_SEL(ram_sel) | BIT_WR_EN)
            self.wr_ctrl(0)

    def _load_ram_32(self, data, ram_sel):
        for i, word in enumerate(data):
            self.wr_wdata(word)
            self.wr_addr(i)
            self.wr_ctrl(RAM_SEL(ram_sel) | BIT_WR_EN)
            self.wr_ctrl(0)

    # ---------- read helpers ----------
    def _read_128bit(self, out_sel, n):
        results = []
        for i in range(n):
            self.wr_addr(i)
            val = 0
            for w in range(4):
                self.wr_ctrl((out_sel << 13) | BIT_RD_EN | (w << 10))
                val |= (self.rd_rdata() << (32 * w))
            results.append(val & ((1 << 128) - 1))
        return results

    def _read_15bit(self, out_sel, n):
        results = []
        for i in range(n):
            self.wr_addr(i)
            self.wr_ctrl((out_sel << 13) | BIT_RD_EN)
            results.append(self.rd_rdata() & 0x7FFF)
        return results

    # ==========================================================
    # KEYGEN
    # ==========================================================
    def run_keygen(self, sk_seed, pk_seed):
        self.reset()

        # ★ DEBUG: check done_sticky sau reset
        self.wr_addr(ADDR_STATUS)
        print(f"  [DBG] done after reset (keygen): {self.rd_rdata() & 1}")

        self._load_seed(sk_seed, BIT_WR_SK_SEED)
        self._load_seed(pk_seed, BIT_WR_PK_SEED)
        self.wr_ctrl(BIT_START)
        self.wr_ctrl(0)

        # ★ DEBUG: check done_sticky sau start
        self.wr_addr(ADDR_STATUS)
        print(f"  [DBG] done after start (keygen): {self.rd_rdata() & 1}")

        t0 = time.time()
        if not self.wait_done(10.0):
            raise RuntimeError("Keygen TIMEOUT")
        print(f"  [DBG] keygen compute: {time.time()-t0:.4f}s")

        return {
            'h': self._read_128bit(KG_OUT_H, N_MEM_WIDTH),
            's': self._read_128bit(KG_OUT_S, N_MEM_WIDTH),
            'x': self._read_15bit(KG_OUT_X, X_Y_ENTRIES),
            'y': self._read_15bit(KG_OUT_Y, X_Y_ENTRIES),
        }

    # ==========================================================
    # ENCAP
    # ==========================================================
    def run_encap(self, h_data, s_data, msg_words):
        # ★ DEBUG: check done_sticky TRƯỚC reset
        self.wr_addr(ADDR_STATUS)
        print(f"  [DBG] done before reset (encap): {self.rd_rdata() & 1}")

        self.reset()
        self.wr_addr(ADDR_STATUS)
        print(f"  [DBG] done after reset (encap): {self.rd_rdata() & 1}")

        self._load_ram_128(h_data, RAM_H)
        self._load_ram_128(s_data, RAM_S)
        self._load_ram_32(msg_words, RAM_MSG)

        # ★ DEBUG: check done_sticky TRƯỚC start
        self.wr_addr(ADDR_STATUS)
        print(f"  [DBG] done before start (encap): {self.rd_rdata() & 1}")

        self.wr_ctrl(BIT_OP_ENCAP | BIT_START)
        self.wr_ctrl(BIT_OP_ENCAP)

        self.wr_addr(ADDR_STATUS)
        print(f"  [DBG] done after start (encap): {self.rd_rdata() & 1}")
        
        t0 = time.time()
        if not self.wait_done(30.0):
            raise RuntimeError("Encap TIMEOUT")
        print(f"  [DBG] encap compute: {time.time()-t0:.4f}s")

        # Read SS
        ss = b""
        for i in range(SS_WORDS):
            self.wr_addr(i)
            self.wr_ctrl(BIT_RD_EN | BIT_OP_ENCAP | OUT_TYPE(OUT_TYPE_SS))
            ss += struct.pack('>I', swap32(self.rd_rdata()))

        # Read D
        d = []
        for i in range(D_WORDS):
            self.wr_addr(i)
            self.wr_ctrl(BIT_RD_EN | BIT_OP_ENCAP | OUT_TYPE(OUT_TYPE_D))
            d.append(self.rd_rdata())

        # Read U (128-bit)
        u = []
        for i in range(N_MEM_WIDTH):
            self.wr_addr(i)
            val = 0
            for w in range(4):
                self.wr_ctrl(BIT_RD_EN | BIT_OP_ENCAP | OUT_TYPE(OUT_TYPE_U) | WORD_SEL(w))
                val |= (self.rd_rdata() << (32 * w))
            u.append(val & ((1 << 128) - 1))

        # Read V (128-bit)
        v = []
        for i in range(N_MEM_WIDTH):
            self.wr_addr(i)
            val = 0
            for w in range(4):
                self.wr_ctrl(BIT_RD_EN | BIT_OP_ENCAP | OUT_TYPE(OUT_TYPE_V) | WORD_SEL(w))
                val |= (self.rd_rdata() << (32 * w))
            v.append(val & ((1 << 128) - 1))

        return {'ss': ss, 'd': d, 'u': u, 'v': v}

    # ==========================================================
    # DECAP
    # ==========================================================
    def run_decap(self, h_data, s_data, u_data, v_data, y_words, d_words):

        # ★ DEBUG: check done_sticky TRƯỚC reset
        self.wr_addr(ADDR_STATUS)
        print(f"  [DBG] done before reset (decap): {self.rd_rdata() & 1}")
        
        self.reset()
        self.wr_addr(ADDR_STATUS)
        print(f"  [DBG] done after reset (decap): {self.rd_rdata() & 1}")

        self._load_ram_128(h_data, RAM_H)
        self._load_ram_128(s_data, RAM_S)
        self._load_ram_128(u_data, RAM_U)
        self._load_ram_128(v_data, RAM_V)
        self._load_ram_32(y_words, RAM_Y)
        self._load_ram_32(d_words, RAM_D)

        # ★ DEBUG: check done_sticky TRƯỚC start
        self.wr_addr(ADDR_STATUS)
        print(f"  [DBG] done before start (decap): {self.rd_rdata() & 1}")

        self.wr_ctrl(OP_DECAP | BIT_START)
        self.wr_ctrl(OP_DECAP)

        self.wr_addr(ADDR_STATUS)
        print(f"  [DBG] done after start (decap): {self.rd_rdata() & 1}")
        
        t0 = time.time()
        if not self.wait_done(30.0):
            raise RuntimeError("Decap TIMEOUT")
        print(f"  [DBG] decap compute: {time.time()-t0:.4f}s")

        ss = b""
        for i in range(SS_WORDS):
            self.wr_addr(i)
            self.wr_ctrl(BIT_RD_EN | OP_DECAP)
            ss += struct.pack('>I', swap32(self.rd_rdata()))
        return ss


# ============================================================
# MAIN
# ============================================================
def main():
    print("=" * 60)
    print("  HQC FUNCTIONAL CORRECTNESS VERIFICATION")
    print(f"  Tests    : {N_TESTS}")
    print(f"  Started  : {datetime.now()}")
    print("=" * 60)

    drv = HQCDriver(BITFILE)

    pass_count = 0
    fail_count = 0
    logs = []
    t_total = time.time()

    for i in range(N_TESTS):
        t0 = time.time()
        seed_hex = ""

        try:
            # 1) Sinh seed ngẫu nhiên
            sk_seed = rand_seed()
            pk_seed = rand_seed()
            seed_hex = ''.join(f'{w:08x}' for w in sk_seed[:4])

            # 2) Keygen
            kg = drv.run_keygen(sk_seed, pk_seed)

            # 3) Encap
            msg = rand_msg()
            enc = drv.run_encap(kg['h'], kg['s'], msg)
            ss_enc = enc['ss']

            # 4) Decap
            y_32 = [loc & 0xFFFFFFFF for loc in kg['y']]
            d_32 = [w & 0xFFFFFFFF for w in enc['d']]
            ss_dec = drv.run_decap(
                kg['h'], kg['s'],
                enc['u'], enc['v'],
                y_32, d_32
            )

            # 5) So sánh
            match = (ss_enc == ss_dec)
            dt = time.time() - t0

            if match:
                pass_count += 1
                print(f"[{i+1:4d}/{N_TESTS}] PASS  {dt:.2f}s  ss={ss_enc.hex()[:16]}...")
            else:
                fail_count += 1
                print(f"[{i+1:4d}/{N_TESTS}] FAIL  {dt:.2f}s")
                print(f"  enc: {ss_enc.hex()}")
                print(f"  dec: {ss_dec.hex()}")

            logs.append({
                'id': i+1, 'status': 'PASS' if match else 'FAIL',
                'seed': seed_hex,
                'ss_encap': ss_enc.hex(), 'ss_decap': ss_dec.hex(),
                'time': f"{dt:.3f}",
            })

        except Exception as e:
            fail_count += 1
            dt = time.time() - t0
            print(f"[{i+1:4d}/{N_TESTS}] ERROR {dt:.2f}s — {e}")
            logs.append({
                'id': i+1, 'status': f'ERROR:{e}',
                'seed': seed_hex, 'ss_encap': 'N/A', 'ss_decap': 'N/A',
                'time': f"{dt:.3f}",
            })

    # ============================================================
    # KẾT QUẢ TỔNG HỢP
    # ============================================================
    elapsed = time.time() - t_total
    rate = pass_count / N_TESTS * 100

    print("\n" + "=" * 60)
    print("  KẾT QUẢ TỔNG HỢP")
    print("=" * 60)
    print(f"  PASS      : {pass_count}/{N_TESTS} ({rate:.1f}%)")
    print(f"  FAIL      : {fail_count}")
    print(f"  Tổng      : {elapsed:.1f}s")
    print(f"  Trung bình: {elapsed/N_TESTS:.3f}s/test")
    print("=" * 60)

    # Ghi CSV
    with open(LOG_FILE, 'w', newline='') as f:
        w = csv.DictWriter(f, fieldnames=['id','status','seed','ss_encap','ss_decap','time'])
        w.writeheader()
        w.writerows(logs)
    print(f"[LOG] {LOG_FILE}")

    # Ghi summary
    with open(SUMMARY, 'w') as f:
        f.write("HQC FUNCTIONAL CORRECTNESS VERIFICATION\n")
        f.write("=" * 45 + "\n")
        f.write(f"Date     : {datetime.now()}\n")
        f.write(f"Platform : Kria KV260 (Zynq UltraScale+)\n")
        f.write(f"Design   : HQC-128 Lightweight\n")
        f.write(f"Tests    : {N_TESTS}\n")
        f.write(f"PASS     : {pass_count}\n")
        f.write(f"FAIL     : {fail_count}\n")
        f.write(f"Rate     : {rate:.1f}%\n")
        f.write(f"Total    : {elapsed:.1f}s\n")
        f.write(f"Average  : {elapsed/N_TESTS:.3f}s/test\n")
    print(f"[LOG] {SUMMARY}")


if __name__ == "__main__":
    main()
