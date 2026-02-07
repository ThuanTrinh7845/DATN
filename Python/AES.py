from Crypto.Cipher import AES
from Crypto.Util.Padding import pad, unpad
import os

# ==============================================================================
# CẤU HÌNH HỆ THỐNG
# ==============================================================================
# File chứa Shared Secret (SS) do module Verilog HQC xuất ra
VERILOG_KEY_FILE = "ss_output_128.out" 

# Tên file ảnh
INPUT_IMAGE     = "input.jpg"        # Ảnh gốc (Hoàng thượng nhớ đổi tên cho đúng)
ENCRYPTED_FILE  = "image_data.bin"   # File đã mã hóa (Gửi cái này sang Board 2)
OUTPUT_IMAGE    = "restored.jpg"     # Ảnh sau khi giải mã (Trên Board 2)

# ==============================================================================
# HÀM HỖ TRỢ (UTILS)
# ==============================================================================
def load_key_from_verilog(filepath):
    """
    Đọc Shared Secret 128-bit từ file text output của Verilog.
    """
    print(f"[*] Đang đọc Key từ file: {filepath}...")
    try:
        with open(filepath, 'r') as f:
            # Đọc toàn bộ, xóa khoảng trắng/xuống dòng thừa
            hex_data = f.read().strip()
            
            # HQC-128 key dài 16 bytes = 32 ký tự Hex.
            # Nếu file chứa nhiều dòng, ta chỉ lấy 32 ký tự đầu tiên.
            if len(hex_data) >= 32:
                hex_data = hex_data[:32]
            else:
                print(f"[!] CẢNH BÁO: Key trong file quá ngắn ({len(hex_data)} chars).")
            
            key_bytes = bytes.fromhex(hex_data)
            print(f" -> Key (Hex): {hex_data}")
            return key_bytes
            
    except FileNotFoundError:
        print(f"[!] Lỗi: Không tìm thấy file key '{filepath}'.")
        print("    -> Đang dùng Key giả (Dummy) để test code...")
        return b'\x00' * 16 # Key toàn số 0 (Chỉ dùng để test code Python)

# ==============================================================================
# PHẦN 1: MÃ HÓA (CHẠY TRÊN BOARD 1 - SENDER)
# ==============================================================================
def encrypt_process(image_path, key_bytes, out_path):
    print("\n=== BẮT ĐẦU QUÁ TRÌNH MÃ HÓA (BOARD 1) ===")
    
    # 1. Đọc file ảnh gốc
    if not os.path.exists(image_path):
        print(f"[!] Lỗi: Không tìm thấy ảnh '{image_path}'")
        return False
        
    with open(image_path, 'rb') as f:
        image_data = f.read()
    print(f" -> Đã đọc ảnh: {len(image_data)} bytes")

    # 2. Tạo Vector khởi tạo (IV) ngẫu nhiên (16 bytes)
    # IV giúp 2 ảnh giống nhau mã hóa ra 2 file khác nhau (an toàn hơn)
    iv = os.urandom(16)

    # 3. Khởi tạo AES Mode CBC
    cipher = AES.new(key_bytes, AES.MODE_CBC, iv)

    # 4. Padding (Đệm dữ liệu)
    # AES bắt buộc dữ liệu phải là bội số của 16 bytes.
    padded_data = pad(image_data, AES.block_size)

    # 5. Mã hóa
    ciphertext = cipher.encrypt(padded_data)

    # 6. Đóng gói gửi đi (Format: [16 bytes IV] + [Ciphertext])
    with open(out_path, 'wb') as f:
        f.write(iv)
        f.write(ciphertext)
        
    print(f" -> Mã hóa THÀNH CÔNG! File xuất ra: {out_path}")
    print(f" -> Hãy gửi file '{out_path}' sang Board 2.")
    return True

# ==============================================================================
# PHẦN 2: GIẢI MÃ (CHẠY TRÊN BOARD 2 - RECEIVER)
# ==============================================================================
def decrypt_process(enc_path, key_bytes, out_img_path):
    print("\n=== BẮT ĐẦU QUÁ TRÌNH GIẢI MÃ (BOARD 2) ===")
    
    if not os.path.exists(enc_path):
        print(f"[!] Lỗi: Không tìm thấy file mã hóa '{enc_path}'")
        return False

    with open(enc_path, 'rb') as f:
        # 1. Tách lấy IV (16 bytes đầu tiên)
        iv = f.read(16)
        # 2. Lấy phần còn lại là dữ liệu mã hóa
        ciphertext = f.read()

    # 3. Khởi tạo bộ giải mã với Key và IV vừa nhận
    cipher = AES.new(key_bytes, AES.MODE_CBC, iv)

    try:
        # 4. Giải mã và gỡ bỏ Padding
        decrypted_padded = cipher.decrypt(ciphertext)
        original_data = unpad(decrypted_padded, AES.block_size)

        # 5. Lưu thành file ảnh
        with open(out_img_path, 'wb') as f:
            f.write(original_data)
            
        print(f" -> Giải mã THÀNH CÔNG! Ảnh phục hồi: {out_img_path}")
        return True

    except ValueError:
        print("[!] Lỗi Giải Mã: Sai Key hoặc dữ liệu bị hỏng (Padding Error).")
        return False

# ==============================================================================
# MAIN (CHẠY TEST)
# ==============================================================================
if __name__ == "__main__":
    # --- BƯỚC 0: TẠO ẢNH GIẢ ĐỂ TEST (NẾU CHƯA CÓ) ---
    # Hoàng thượng có thể xóa đoạn này nếu đã có file ảnh thật
    if not os.path.exists(INPUT_IMAGE):
        print("[Info] Đang tạo ảnh giả để test...")
        with open(INPUT_IMAGE, "wb") as f:
            f.write(os.urandom(1024 * 50)) # Ảnh rác 50KB

    # --- BƯỚC 1: LẤY KEY TỪ VERILOG OUTPUT ---
    # (Lưu ý: Board 1 lấy từ Encap output, Board 2 lấy từ Decap output)
    shared_secret = load_key_from_verilog(VERILOG_KEY_FILE)

    # --- BƯỚC 2: MÔ PHỎNG LUỒNG CHẠY ---
    
    # [BOARD 1] Mã hóa ảnh
    encrypt_process(INPUT_IMAGE, shared_secret, ENCRYPTED_FILE)

    print("\n... (Giả lập truyền file qua mạng) ...\n")

    # [BOARD 2] Giải mã ảnh
    # (Thực tế Board 2 sẽ lấy key từ module Decap)
    decrypt_process(ENCRYPTED_FILE, shared_secret, OUTPUT_IMAGE)