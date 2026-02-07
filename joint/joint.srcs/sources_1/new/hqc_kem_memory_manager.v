`timescale 1ns / 1ps
/*
 * HQC KEM Memory Manager
 * 
 * Ch?c nãng: Qu?n l? lýu tr? t?t c? d? li?u HQC KEM vào BRAM
 * - h: Public key polynomial (N bits)
 * - s: Public key polynomial (N bits)
 * - u: Ciphertext polynomial (N bits)
 * - v: Ciphertext polynomial (N bits)
 * - d: Shared secret (512 bits)
 * - x: Secret key (N bits)
 * - y: Secret key error location (WEIGHT bits)
 * - ss: Shared secret (256 bits)
 * 
 * Author: Generated
 * Date: 2026-01-30
 */
`include "clog2.v"

module hqc_kem_memory_manager
#(
    parameter parameter_set = "hqc128",
    parameter MEM_WIDTH = 128,
    
    // HQC Parameters
    parameter N = (parameter_set == "hqc128")? 17_669:
                  (parameter_set == "hqc192")? 35_851:
                  (parameter_set == "hqc256")? 57_637: 17_669,
    
    parameter WEIGHT = (parameter_set == "hqc128")? 66:
                       (parameter_set == "hqc192")? 100:
                       (parameter_set == "hqc256")? 131: 66,
    
    parameter LOG_WEIGHT = `CLOG2(WEIGHT),
    
    // Memory Depth Calculation
    parameter N_MEM = N + (MEM_WIDTH - N%MEM_WIDTH)%MEM_WIDTH,
    parameter RAMDEPTH = N_MEM / MEM_WIDTH,
    parameter LOG_RAMDEPTH = `CLOG2(RAMDEPTH),
    
    // Shared Secret Size
    parameter SS_SIZE = 256,
    parameter SS_MEM = SS_SIZE + (MEM_WIDTH - SS_SIZE%MEM_WIDTH)%MEM_WIDTH,
    parameter SS_DEPTH = SS_MEM / MEM_WIDTH,
    parameter LOG_SS_DEPTH = `CLOG2(SS_DEPTH),
    
    // D Size (512 bits)
    parameter D_SIZE = 512,
    parameter D_MEM = D_SIZE + (MEM_WIDTH - D_SIZE%MEM_WIDTH)%MEM_WIDTH,
    parameter D_DEPTH = D_MEM / MEM_WIDTH,
    parameter LOG_D_DEPTH = `CLOG2(D_DEPTH),
    
    // Y Size (Error Locations)
    parameter Y_SIZE = WEIGHT * LOG_WEIGHT,
    parameter Y_MEM = Y_SIZE + (MEM_WIDTH - Y_SIZE%MEM_WIDTH)%MEM_WIDTH,
    parameter Y_DEPTH = Y_MEM / MEM_WIDTH,
    parameter LOG_Y_DEPTH = `CLOG2(Y_DEPTH)
)
(
    // ==================== Clock & Reset ====================
    input clk,
    input rst,
    
    // ==================== Control Signals ====================
    input [3:0] mem_type,       // 0000: h, 0001: s, 0010: u, 0011: v
                                // 0100: d, 0101: x, 0110: y, 0111: ss
    input write_en,
    input read_en,
    input [LOG_RAMDEPTH-1:0] addr,
    
    // ==================== Data Interface ====================
    input [MEM_WIDTH-1:0] data_in,
    output [MEM_WIDTH-1:0] data_out,
    
    // ==================== Status ====================
    output reg ready,
    output reg [3:0] current_mem_type
);

// ==================== Memory Type Definitions ====================
localparam MEM_H = 4'b0000;   // Public key h
localparam MEM_S = 4'b0001;   // Public key s
localparam MEM_U = 4'b0010;   // Ciphertext u
localparam MEM_V = 4'b0011;   // Ciphertext v
localparam MEM_D = 4'b0100;   // Shared secret d (512 bits)
localparam MEM_X = 4'b0101;   // Secret key x
localparam MEM_Y = 4'b0110;   // Secret key y (error locations)
localparam MEM_SS = 4'b0111;  // Shared secret ss (256 bits)

// ==================== BRAM Outputs ====================
wire [MEM_WIDTH-1:0] h_q, s_q, u_q, v_q, d_q, x_q, y_q, ss_q;

// ==================== Address Mapping ====================
wire [LOG_RAMDEPTH-1:0] addr_h, addr_s, addr_u, addr_v;
wire [LOG_D_DEPTH-1:0] addr_d;
wire [LOG_Y_DEPTH-1:0] addr_y;
wire [LOG_SS_DEPTH-1:0] addr_ss;
wire [LOG_RAMDEPTH-1:0] addr_x;

// Address assignment based on memory type
assign addr_h = (mem_type == MEM_H) ? addr : {LOG_RAMDEPTH{1'b0}};
assign addr_s = (mem_type == MEM_S) ? addr : {LOG_RAMDEPTH{1'b0}};
assign addr_u = (mem_type == MEM_U) ? addr : {LOG_RAMDEPTH{1'b0}};
assign addr_v = (mem_type == MEM_V) ? addr : {LOG_RAMDEPTH{1'b0}};
assign addr_d = (mem_type == MEM_D) ? addr[LOG_D_DEPTH-1:0] : {LOG_D_DEPTH{1'b0}};
assign addr_x = (mem_type == MEM_X) ? addr : {LOG_RAMDEPTH{1'b0}};
assign addr_y = (mem_type == MEM_Y) ? addr[LOG_Y_DEPTH-1:0] : {LOG_Y_DEPTH{1'b0}};
assign addr_ss = (mem_type == MEM_SS) ? addr[LOG_SS_DEPTH-1:0] : {LOG_SS_DEPTH{1'b0}};

// ==================== Write Enable Signals ====================
wire wr_h = write_en && (mem_type == MEM_H);
wire wr_s = write_en && (mem_type == MEM_S);
wire wr_u = write_en && (mem_type == MEM_U);
wire wr_v = write_en && (mem_type == MEM_V);
wire wr_d = write_en && (mem_type == MEM_D);
wire wr_x = write_en && (mem_type == MEM_X);
wire wr_y = write_en && (mem_type == MEM_Y);
wire wr_ss = write_en && (mem_type == MEM_SS);

// ==================== BRAM Instances ====================

// H Polynomial (Public Key) - Dual Port
mem_dual #(
    .WIDTH(MEM_WIDTH),
    .DEPTH(RAMDEPTH),
    .INIT(1)
)
BRAM_H (
    .clock(clk),
    .data_0(data_in),
    .data_1({MEM_WIDTH{1'b0}}),
    .address_0(addr_h),
    .address_1({LOG_RAMDEPTH{1'b0}}),
    .wren_0(wr_h),
    .wren_1(1'b0),
    .q_0(h_q),
    .q_1()
);

// S Polynomial (Public Key) - Dual Port
mem_dual #(
    .WIDTH(MEM_WIDTH),
    .DEPTH(RAMDEPTH),
    .INIT(1)
)
BRAM_S (
    .clock(clk),
    .data_0(data_in),
    .data_1({MEM_WIDTH{1'b0}}),
    .address_0(addr_s),
    .address_1({LOG_RAMDEPTH{1'b0}}),
    .wren_0(wr_s),
    .wren_1(1'b0),
    .q_0(s_q),
    .q_1()
);

// U Polynomial (Ciphertext) - Dual Port
mem_dual #(
    .WIDTH(MEM_WIDTH),
    .DEPTH(RAMDEPTH),
    .INIT(1)
)
BRAM_U (
    .clock(clk),
    .data_0(data_in),
    .data_1({MEM_WIDTH{1'b0}}),
    .address_0(addr_u),
    .address_1({LOG_RAMDEPTH{1'b0}}),
    .wren_0(wr_u),
    .wren_1(1'b0),
    .q_0(u_q),
    .q_1()
);

// V Polynomial (Ciphertext) - Dual Port
mem_dual #(
    .WIDTH(MEM_WIDTH),
    .DEPTH(RAMDEPTH),
    .INIT(1)
)
BRAM_V (
    .clock(clk),
    .data_0(data_in),
    .data_1({MEM_WIDTH{1'b0}}),
    .address_0(addr_v),
    .address_1({LOG_RAMDEPTH{1'b0}}),
    .wren_0(wr_v),
    .wren_1(1'b0),
    .q_0(v_q),
    .q_1()
);

// D (Shared Secret 512-bit) - Single Port
mem_single #(
    .WIDTH(MEM_WIDTH),
    .DEPTH(D_DEPTH),
    .INIT(1)
)
BRAM_D (
    .clock(clk),
    .data(data_in),
    .address(addr_d),
    .wr_en(wr_d),
    .q(d_q)
);

// X Polynomial (Secret Key) - Single Port
mem_single #(
    .WIDTH(MEM_WIDTH),
    .DEPTH(RAMDEPTH),
    .INIT(1)
)
BRAM_X (
    .clock(clk),
    .data(data_in),
    .address(addr_x),
    .wr_en(wr_x),
    .q(x_q)
);

// Y (Error Locations) - Single Port
mem_single #(
    .WIDTH(MEM_WIDTH),
    .DEPTH(Y_DEPTH),
    .INIT(1)
)
BRAM_Y (
    .clock(clk),
    .data(data_in),
    .address(addr_y),
    .wr_en(wr_y),
    .q(y_q)
);

// SS (Shared Secret 256-bit) - Single Port
mem_single #(
    .WIDTH(MEM_WIDTH),
    .DEPTH(SS_DEPTH),
    .INIT(1)
)
BRAM_SS (
    .clock(clk),
    .data(data_in),
    .address(addr_ss),
    .wr_en(wr_ss),
    .q(ss_q)
);

// ==================== Output Multiplexer ====================
assign data_out = (mem_type == MEM_H) ? h_q :
                  (mem_type == MEM_S) ? s_q :
                  (mem_type == MEM_U) ? u_q :
                  (mem_type == MEM_V) ? v_q :
                  (mem_type == MEM_D) ? d_q :
                  (mem_type == MEM_X) ? x_q :
                  (mem_type == MEM_Y) ? y_q :
                  (mem_type == MEM_SS) ? ss_q :
                  {MEM_WIDTH{1'b0}};

// ==================== Status Management ====================
always @(posedge clk) begin
    if (rst) begin
        ready <= 1'b1;
        current_mem_type <= 4'b0000;
    end
    else begin
        current_mem_type <= mem_type;
        ready <= 1'b1;  // Always ready (BRAM is fast)
    end
end

endmodule
