import random

def generate_bin_file(filename, num_words=10):
    """
    Sinh ra file chứa các chuỗi NHỊ PHÂN (Binary) 32-bit.
    Verilog $readmemb chỉ chấp nhận 0 và 1.
    """
    print(f"Dang tao file BINARY: {filename}...")
    try:
        with open(filename, 'w') as f:
            for _ in range(num_words):
                # Sinh số ngẫu nhiên 32-bit
                rand_val = random.getrandbits(32)
                
                # SỬA ĐỔI QUAN TRỌNG:
                # :032b -> Format thành chuỗi nhị phân dài 32 ký tự, điền đầy số 0
                bin_str = f"{rand_val:032b}" 
                
                f.write(bin_str + '\n')
        print(f" -> Da xong! ({num_words} dong binary)")
    except Exception as e:
        print(f" -> Loi khi tao file: {e}")

if __name__ == "__main__":
    # HQC Seed thường là 40 bytes = 320 bits.
    # Với hệ thống 32-bit, ta cần 320 / 32 = 10 dòng.
    NUM_LINES = 10 

    # Tạo file Public Key Seed (Dạng Binary)
    generate_bin_file("pk_seed.in", NUM_LINES)

    # Tạo file Secret Key Seed (Dạng Binary)
    generate_bin_file("sk_seed.in", NUM_LINES)
    
    print("\n------------------------------------------------")
    print("Than da chuyen tu HEX sang BINARY (0/1).")
    print("Hoang thuong hay copy lai 2 file nay vao Vivado nhe a!")
    print("------------------------------------------------")