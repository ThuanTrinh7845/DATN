import os

# --- CẤU HÌNH ---
N = 17669
WEIGHT = 66
RAMWIDTH = 64
NUM_CHUNKS = (N + (RAMWIDTH - N % RAMWIDTH) % RAMWIDTH) // RAMWIDTH

def write_files(dense_val, sparse_indices, case_id, description):
    filename_dense = f"dense_{case_id}.mem"
    filename_sparse = f"sparse_{case_id}.mem"
    
    print(f"--- Creating Case {case_id}: {description} ---")
    
    # 1. Ghi file Vector Dày (Binary 64-bit)
    with open(filename_dense, "w") as f:
        temp_val = dense_val
        for _ in range(NUM_CHUNKS):
            # Lấy 64 bit thấp nhất để ghi vào dòng hiện tại (Chunk 0 lên trước)
            chunk = temp_val & ((1 << RAMWIDTH) - 1)
            f.write(f"{chunk:064b}\n")
            temp_val >>= RAMWIDTH
    
    # 2. Ghi file Vector Thưa (Binary 15-bit)
    with open(filename_sparse, "w") as f:
        for i in range(WEIGHT):
            if i < len(sparse_indices):
                f.write(f"{sparse_indices[i]:015b}\n") 
            else:
                f.write(f"{0:015b}\n") # Padding
    
    print(f"   -> Created {filename_dense} & {filename_sparse}\n")

# --- ĐỊNH NGHĨA 3 TESTCASE ---

def generate_all():
    # CASE 1: Boundary Check (N-1)
    dense_1 = 1
    sparse_1 = [N - 1]
    write_files(dense_1, sparse_1, 1, "Boundary Check")

    # CASE 2: Cross Chunk (A=3, B=63)
    dense_2 = 3
    sparse_2 = [63]
    write_files(dense_2, sparse_2, 2, "Cross Chunk")

    # --- SỬA ĐỔI TẠI ĐÂY ---
    # CASE 3: ZigZag Pattern (1010...)
    # Logic: Ghép các chunk 0xAAAA... lại với nhau
    dense_3 = 0
    pattern_chunk = 0xAAAAAAAAAAAAAAAA # Mẫu 101010... trong 64 bit
    
    for _ in range(NUM_CHUNKS):
        dense_3 = (dense_3 << 64) | pattern_chunk
        
    # Cắt gọn lại cho vừa khít N bit (để loại bỏ phần thừa ở MSB)
    dense_3 = dense_3 & ((1 << N) - 1)
    
    # Sparse: Dịch 1 bit. 
    # Mẹo: 1010... XOR 0101... (do dịch 1) = 1111... (Kết quả toàn 1 rất đẹp)
    sparse_3 = [1] 
    
    write_files(dense_3, sparse_3, 3, "ZigZag Pattern (1010...)")

if __name__ == "__main__":
    generate_all()