`timescale 1ns/1ps
`include "clog2.v"

/*
 * HQC KEM System Complete Testbench - Vivado Optimized
 * 
 * Tích h?p test cho KEYGEN, ENCAP, DECAP
 * Lýu Shared Secret (SS) t? ENCAP và DECAP ra file
 * 
 * Copyright (C) 2024
 */

module hqc_kem_system_tb
#(
    parameter parameter_set = "hqc128",
    parameter CT_DESIGN = 2'b01,
    parameter PARALLEL_ENCRYPT = 0,
    parameter MEM_WIDTH = 128
)
();

// ==================== Parameter Calculations ====================
localparam N = (parameter_set == "hqc128")? 17_669:
               (parameter_set == "hqc192")? 35_851:
               (parameter_set == "hqc256")? 57_637: 17_669;

localparam WEIGHT = (parameter_set == "hqc128")? 66:
                    (parameter_set == "hqc192")? 100:
                    (parameter_set == "hqc256")? 131: 66;

localparam M = (parameter_set == "hqc128")? 15:
               (parameter_set == "hqc192")? 16:
               (parameter_set == "hqc256")? 16: 15;

localparam K_BYTES = (parameter_set == "hqc128")? 16:
                     (parameter_set == "hqc192")? 24:
                     (parameter_set == "hqc256")? 32: 16;

localparam K = 8 * K_BYTES;

localparam N1_BYTES = (parameter_set == "hqc128")? 46:
                      (parameter_set == "hqc192")? 56:
                      (parameter_set == "hqc256")? 90: 46;

localparam N1 = 8 * N1_BYTES;

localparam WEIGHT_ENC = (parameter_set == "hqc128")? 75:
                        (parameter_set == "hqc192")? 114:
                        (parameter_set == "hqc256")? 149: 75;

localparam LOG_WEIGHT = `CLOG2(WEIGHT);
localparam LOG_WEIGHT_ENC = `CLOG2(WEIGHT_ENC);

localparam N_MEM = N + (MEM_WIDTH - N%MEM_WIDTH)%MEM_WIDTH;
localparam N_B = N + (8-N%8)%8;
localparam N_Bd = N_B - N;
localparam N_MEMd = N_MEM - N_B;
localparam RAMDEPTH = (N+(MEM_WIDTH-N%MEM_WIDTH)%MEM_WIDTH)/MEM_WIDTH;
localparam LOG_RAMDEPTH = `CLOG2(RAMDEPTH);

// ==================== Output Filenames ====================
localparam KEYGEN_X_FILE = (parameter_set == "hqc128") ? "keygen_x_128.txt":
                           (parameter_set == "hqc192") ? "keygen_x_192.txt":
                           (parameter_set == "hqc256") ? "keygen_x_256.txt":
                                                         "keygen_x.txt";

localparam KEYGEN_Y_FILE = (parameter_set == "hqc128") ? "keygen_y_128.txt":
                           (parameter_set == "hqc192") ? "keygen_y_192.txt":
                           (parameter_set == "hqc256") ? "keygen_y_256.txt":
                                                         "keygen_y.txt";

localparam KEYGEN_H_FILE = (parameter_set == "hqc128") ? "keygen_h_128.txt":
                           (parameter_set == "hqc192") ? "keygen_h_192.txt":
                           (parameter_set == "hqc256") ? "keygen_h_256.txt":
                                                         "keygen_h.txt";

localparam KEYGEN_S_FILE = (parameter_set == "hqc128") ? "keygen_s_128.txt":
                           (parameter_set == "hqc192") ? "keygen_s_192.txt":
                           (parameter_set == "hqc256") ? "keygen_s_256.txt":
                                                         "keygen_s.txt";

localparam ENCAP_U_FILE = (parameter_set == "hqc128") ? "encap_u_128.txt":
                          (parameter_set == "hqc192") ? "encap_u_192.txt":
                          (parameter_set == "hqc256") ? "encap_u_256.txt":
                                                        "encap_u.txt";

localparam ENCAP_V_FILE = (parameter_set == "hqc128") ? "encap_v_128.txt":
                          (parameter_set == "hqc192") ? "encap_v_192.txt":
                          (parameter_set == "hqc256") ? "encap_v_256.txt":
                                                        "encap_v.txt";

localparam ENCAP_D_FILE = (parameter_set == "hqc128") ? "encap_d_128.txt":
                          (parameter_set == "hqc192") ? "encap_d_192.txt":
                          (parameter_set == "hqc256") ? "encap_d_256.txt":
                                                        "encap_d.txt";

localparam ENCAP_SS_FILE = (parameter_set == "hqc128") ? "encap_ss_128.txt":
                           (parameter_set == "hqc192") ? "encap_ss_192.txt":
                           (parameter_set == "hqc256") ? "encap_ss_256.txt":
                                                         "encap_ss.txt";

localparam DECAP_SS_FILE = (parameter_set == "hqc128") ? "decap_ss_128.txt":
                           (parameter_set == "hqc192") ? "decap_ss_192.txt":
                           (parameter_set == "hqc256") ? "decap_ss_256.txt":
                                                         "decap_ss.txt";

localparam SUMMARY_FILE = (parameter_set == "hqc128") ? "summary_128.txt":
                          (parameter_set == "hqc192") ? "summary_192.txt":
                          (parameter_set == "hqc256") ? "summary_256.txt":
                                                        "summary.txt";

// ==================== Signals ====================
reg clk = 1'b0;
reg rst = 1'b0;

// Control signals
reg start = 1'b0;
reg [1:0] operation = 2'b00;
wire done;
wire [1:0] status;
wire [7:0] debug_state;
wire error_flag;

// Memory interface
reg [3:0] mem_type = 4'b0000;
reg mem_write_en = 1'b0;
reg mem_read_en = 1'b0;
reg [16:0] mem_addr = 17'b0;
reg [MEM_WIDTH-1:0] mem_data_in = {MEM_WIDTH{1'b0}};
wire [MEM_WIDTH-1:0] mem_data_out;
wire mem_ready;

// KEYGEN signals
reg [3:0] sk_seed_addr = 4'b0;
reg [31:0] sk_seed = 32'b0;
reg sk_seed_wen = 1'b0;
reg [3:0] pk_seed_addr = 4'b0;
reg [31:0] pk_seed = 32'b0;
reg pk_seed_wen = 1'b0;

// ENCAP signals
reg [31:0] m_in = 32'b0;
reg [7:0] m_addr = 8'b0;
reg m_wen = 1'b0;

// DECAP signals
reg [1:0] decap_in_type = 2'b0;
reg [MEM_WIDTH-1:0] decap_in = {MEM_WIDTH{1'b0}};
reg [16:0] decap_in_addr = 17'b0;
reg decap_in_wen = 1'b0;

// Timing variables
integer keygen_cycles = 0;
integer encap_cycles = 0;
integer decap_cycles = 0;

// ==================== DUT Instance ====================
hqc_kem_system #(
    .parameter_set(parameter_set),
    .CT_DESIGN(CT_DESIGN),
    .PARALLEL_ENCRYPT(PARALLEL_ENCRYPT),
    .MEM_WIDTH(MEM_WIDTH)
)
DUT (
    .clk(clk),
    .rst(rst),
    .start(start),
    .operation(operation),
    .done(done),
    .status(status),
    
    .mem_type(mem_type),
    .mem_write_en(mem_write_en),
    .mem_read_en(mem_read_en),
    .mem_addr(mem_addr),
    .mem_data_in(mem_data_in),
    .mem_data_out(mem_data_out),
    .mem_ready(mem_ready),
    
    .sk_seed_addr(sk_seed_addr),
    .sk_seed(sk_seed),
    .sk_seed_wen(sk_seed_wen),
    .pk_seed_addr(pk_seed_addr),
    .pk_seed(pk_seed),
    .pk_seed_wen(pk_seed_wen),
    
    .m_in(m_in),
    .m_addr(m_addr),
    .m_wen(m_wen),
    
    .decap_in_type(decap_in_type),
    .decap_in(decap_in),
    .decap_in_addr(decap_in_addr),
    .decap_in_wen(decap_in_wen),
    
    .debug_state(debug_state),
    .error_flag(error_flag)
);

// ==================== Clock Generation ====================
always #5 clk = ~clk;

// ==================== Helper Tasks ====================

task load_seeds;
    input [31:0] pk_seed_val;
    input [31:0] sk_seed_val;
    integer i;
    begin
        // Load PK seed (10 x 32-bit)
        for (i = 0; i < 10; i = i + 1) begin
            pk_seed_addr = i;
            pk_seed = pk_seed_val + i;
            pk_seed_wen = 1'b1;
            #10;
        end
        pk_seed_wen = 1'b0;
        
        // Load SK seed (10 x 32-bit)
        for (i = 0; i < 10; i = i + 1) begin
            sk_seed_addr = i;
            sk_seed = sk_seed_val + i;
            sk_seed_wen = 1'b1;
            #10;
        end
        sk_seed_wen = 1'b0;
    end
endtask

task load_message;
    input [31:0] msg_seed;
    integer i;
    begin
        // Load message (K/32 words)
        for (i = 0; i < K/32; i = i + 1) begin
            m_addr = i;
            m_in = msg_seed + i;
            m_wen = 1'b1;
            #10;
        end
        m_wen = 1'b0;
    end
endtask

task load_ciphertext_decap;
    input [31:0] u_seed, v_seed, d_seed;
    integer i;
    begin
        // Load U (RAMDEPTH words)
        decap_in_type = 2'b10;  // U
        for (i = 0; i < RAMDEPTH; i = i + 1) begin
            decap_in_addr = i;
            decap_in = {
                {MEM_WIDTH/32{1'b0}} | (u_seed + i)
            };
            decap_in_wen = 1'b1;
            #10;
        end
        decap_in_wen = 1'b0;
        #20;
        
        // Load V (RAMDEPTH-1 words)
        decap_in_type = 2'b11;  // V
        for (i = 0; i < RAMDEPTH-1; i = i + 1) begin
            decap_in_addr = i;
            decap_in = {
                {MEM_WIDTH/32{1'b0}} | (v_seed + i)
            };
            decap_in_wen = 1'b1;
            #10;
        end
        decap_in_wen = 1'b0;
        #20;
        
        // Load D (16 words)
        decap_in_type = 2'b01;  // D
        for (i = 0; i < 16; i = i + 1) begin
            decap_in_addr = i;
            decap_in = {
                {MEM_WIDTH/32{1'b0}} | (d_seed + i)
            };
            decap_in_wen = 1'b1;
            #10;
        end
        decap_in_wen = 1'b0;
    end
endtask

task read_memory_keygen_xy;
    input [3:0] mem_type_val;
    input integer num_words;
    input integer file_id;
    integer i;
    begin
        mem_type = mem_type_val;
        mem_read_en = 1'b1;
        
        for (i = 0; i < num_words; i = i + 1) begin
            mem_addr = i;
            #10;
            $fwrite(file_id, "%h\n", mem_data_out[M-1:0]);
        end
        
        mem_read_en = 1'b0;
    end
endtask

task read_memory_keygen_hs;
    input [3:0] mem_type_val;
    input integer num_words;
    input integer file_id;
    integer i;
    begin
        mem_type = mem_type_val;
        mem_read_en = 1'b1;
        
        for (i = 0; i < num_words; i = i + 1) begin
            mem_addr = i;
            #10;
            
            if (i == num_words - 1) begin
                $fwrite(file_id, "%h", mem_data_out[MEM_WIDTH-1:N_MEMd]);
            end
            else begin
                $fwrite(file_id, "%h\n", mem_data_out);
            end
        end
        
        mem_read_en = 1'b0;
    end
endtask

task read_memory_encap_uv;
    input [3:0] mem_type_val;
    input integer num_words;
    input integer file_id;
    integer i;
    begin
        mem_type = mem_type_val;
        mem_read_en = 1'b1;
        
        for (i = 0; i < num_words; i = i + 1) begin
            mem_addr = i;
            #10;
            
            if (i == num_words - 1) begin
                $fwrite(file_id, "%h", mem_data_out[MEM_WIDTH-1:N_MEMd]);
            end
            else begin
                $fwrite(file_id, "%h\n", mem_data_out);
            end
        end
        
        mem_read_en = 1'b0;
    end
endtask

task read_memory_ss_d;
    input [3:0] mem_type_val;
    input integer num_words;
    input integer file_id;
    integer i;
    begin
        mem_type = mem_type_val;
        mem_read_en = 1'b1;
        
        for (i = 0; i < num_words; i = i + 1) begin
            mem_addr = i;
            #10;
            $fwrite(file_id, "%h\n", mem_data_out[31:0]);
        end
        
        mem_read_en = 1'b0;
    end
endtask

task run_keygen;
    integer start_time, end_time;
    integer file_x, file_y, file_h, file_s;
    begin
        $display("[*] ========== KEYGEN ==========");
        
        load_seeds(32'hDEADBEEF, 32'hCAFEBABE);
        #20;
        
        operation = 2'b00;  // KEYGEN
        start = 1'b1;
        start_time = $time;
        
        #10;
        start = 1'b0;
        
        @(posedge done);
        end_time = $time;
        
        keygen_cycles = (end_time - start_time) / 10;
        $display("[+] KEYGEN completed in %d cycles", keygen_cycles);
        
        #100;
        
        // Read outputs
        file_x = $fopen(KEYGEN_X_FILE);
        read_memory_keygen_xy(4'b0101, WEIGHT, file_x);
        $fclose(file_x);
        
        file_y = $fopen(KEYGEN_Y_FILE);
        read_memory_keygen_xy(4'b0110, WEIGHT, file_y);
        $fclose(file_y);
        
        file_h = $fopen(KEYGEN_H_FILE);
        read_memory_keygen_hs(4'b0000, RAMDEPTH, file_h);
        $fclose(file_h);
        
        file_s = $fopen(KEYGEN_S_FILE);
        read_memory_keygen_hs(4'b0001, RAMDEPTH, file_s);
        $fclose(file_s);
    end
endtask

task run_encap;
    integer start_time, end_time;
    integer file_u, file_v, file_d, file_ss;
    begin
        $display("[*] ========== ENCAPSULATION ==========");
        
        load_message(32'hFEEDFEED);
        #20;
        
        operation = 2'b01;  // ENCAP
        start = 1'b1;
        start_time = $time;
        
        #10;
        start = 1'b0;
        
        @(posedge done);
        end_time = $time;
        
        encap_cycles = (end_time - start_time) / 10;
        $display("[+] ENCAPSULATION completed in %d cycles", encap_cycles);
        
        #100;
        
        // Read outputs
        file_u = $fopen(ENCAP_U_FILE);
        read_memory_encap_uv(4'b0010, RAMDEPTH, file_u);
        $fclose(file_u);
        
        file_v = $fopen(ENCAP_V_FILE);
        read_memory_encap_uv(4'b0011, RAMDEPTH-1, file_v);
        $fclose(file_v);
        
        file_d = $fopen(ENCAP_D_FILE);
        read_memory_ss_d(4'b0100, 16, file_d);
        $fclose(file_d);
        
        file_ss = $fopen(ENCAP_SS_FILE);
        read_memory_ss_d(4'b0111, 16, file_ss);
        $fclose(file_ss);
        
        $display("[+] ENCAP outputs saved to files");
    end
endtask

task run_decap;
    integer start_time, end_time;
    integer file_ss;
    begin
        $display("[*] ========== DECAPSULATION ==========");
        
        load_ciphertext_decap(32'hAAAAAAAA, 32'hBBBBBBBB, 32'hCCCCCCCC);
        #20;
        
        operation = 2'b10;  // DECAP
        start = 1'b1;
        start_time = $time;
        
        #10;
        start = 1'b0;
        
        @(posedge done);
        end_time = $time;
        
        decap_cycles = (end_time - start_time) / 10;
        $display("[+] DECAPSULATION completed in %d cycles", decap_cycles);
        
        #100;
        
        // Read output
        file_ss = $fopen(DECAP_SS_FILE);
        read_memory_ss_d(4'b0111, 16, file_ss);
        $fclose(file_ss);
        
        $display("[+] DECAP outputs saved to files");
    end
endtask

task write_summary;
    integer summary_file;
    begin
        summary_file = $fopen(SUMMARY_FILE);
        
        $fwrite(summary_file, "HQC KEM System Test Summary\n");
        $fwrite(summary_file, "==========================\n\n");
        
        $fwrite(summary_file, "Parameter Set: %s\n", parameter_set);
        $fwrite(summary_file, "N: %d\n", N);
        $fwrite(summary_file, "WEIGHT: %d\n", WEIGHT);
        $fwrite(summary_file, "K: %d bits\n\n", K);
        
        $fwrite(summary_file, "Performance Metrics:\n");
        $fwrite(summary_file, "-------------------\n");
        $fwrite(summary_file, "KEYGEN cycles:        %d\n", keygen_cycles);
        $fwrite(summary_file, "ENCAPSULATION cycles: %d\n", encap_cycles);
        $fwrite(summary_file, "DECAPSULATION cycles: %d\n", decap_cycles);
        $fwrite(summary_file, "Total cycles:         %d\n\n", keygen_cycles + encap_cycles + decap_cycles);
        
        $fwrite(summary_file, "Output Files:\n");
        $fwrite(summary_file, "-------------\n");
        $fwrite(summary_file, "KEYGEN:\n");
        $fwrite(summary_file, "  X: %s\n", KEYGEN_X_FILE);
        $fwrite(summary_file, "  Y: %s\n", KEYGEN_Y_FILE);
        $fwrite(summary_file, "  H: %s\n", KEYGEN_H_FILE);
        $fwrite(summary_file, "  S: %s\n\n", KEYGEN_S_FILE);
        
        $fwrite(summary_file, "ENCAPSULATION:\n");
        $fwrite(summary_file, "  U: %s\n", ENCAP_U_FILE);
        $fwrite(summary_file, "  V: %s\n", ENCAP_V_FILE);
        $fwrite(summary_file, "  D: %s\n", ENCAP_D_FILE);
        $fwrite(summary_file, "  SS: %s (IMPORTANT)\n\n", ENCAP_SS_FILE);
        
        $fwrite(summary_file, "DECAPSULATION:\n");
        $fwrite(summary_file, "  SS: %s (IMPORTANT)\n\n", DECAP_SS_FILE);
        
        $fwrite(summary_file, "Verification:\n");
        $fwrite(summary_file, "  Compare %s and %s\n", ENCAP_SS_FILE, DECAP_SS_FILE);
        $fwrite(summary_file, "  They should be identical!\n");
        
        $fclose(summary_file);
        
        $display("[+] Summary written to %s", SUMMARY_FILE);
    end
endtask

// ==================== Main Test ====================
initial begin
    $display("\n");
    $display("??????????????????????????????????????????????????????????????????????");
    $display("?         HQC KEM System Testbench - %s                    ?", parameter_set);
    $display("??????????????????????????????????????????????????????????????????????\n");
    
    // Reset
    rst = 1'b1;
    #100;
    rst = 1'b0;
    #100;
    
    // Run KEYGEN
    run_keygen;
    #1000;
    
    // Run ENCAPSULATION
    run_encap;
    #1000;
    
    // Run DECAPSULATION
    run_decap;
    #1000;
    
    // Write summary
    write_summary;
    
    $display("\n");
    $display("??????????????????????????????????????????????????????????????????????");
    $display("?                    Simulation Complete                             ?");
    $display("?                                                                    ?");
    $display("?  Check output files:                                               ?");
    $display("?  - encap_ss_128.txt  (ENCAP Shared Secret)                         ?");
    $display("?  - decap_ss_128.txt  (DECAP Shared Secret)                         ?");
    $display("?  - summary_128.txt   (Performance Summary)                         ?");
    $display("??????????????????????????????????????????????????????????????????????\n");
    
    #1000;
    $finish;
end

endmodule
