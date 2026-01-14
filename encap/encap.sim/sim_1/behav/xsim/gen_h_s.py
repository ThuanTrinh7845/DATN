import random

# ===== HQC-128 parameters =====
N = 17669
MEM_WIDTH = 128
N_MEM = N + (MEM_WIDTH - N % MEM_WIDTH) % MEM_WIDTH
DEPTH = N_MEM // MEM_WIDTH   # 139

random.seed(1234)  # deterministic, dễ debug

def gen_poly(weight, name):
    """
    Sinh polynomial nhị phân độ dài N,
    có 'weight' bit = 1
    """
    poly = [0] * N
    ones = random.sample(range(N), weight)
    for i in ones:
        poly[i] = 1

    # padding lên N_MEM
    poly += [0] * (N_MEM - N)

    # ghi ra file
    with open(name, "w") as f:
        for i in range(DEPTH):
            chunk = poly[i*MEM_WIDTH:(i+1)*MEM_WIDTH]
            line = "".join(str(b) for b in chunk)
            f.write(line + "\n")

    print(f"[OK] Generated {name}")

# ===== sinh h và s =====
gen_poly(weight=20, name="h_128.in")   # public key (nhẹ cho poly mult)
gen_poly(weight=20, name="s_128.in")   # secret key
