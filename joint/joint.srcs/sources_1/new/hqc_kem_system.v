`timescale 1ns / 1ps
/*
 * HQC KEM Complete System with Memory Management
 * 
 * Tích h?p: Wrapper + Memory Manager + HQC KEM Joint Design
 */
`include "clog2.v"
module hqc_kem_system
#(
    parameter parameter_set = "hqc128",
    parameter CT_DESIGN = 2'b01,
    parameter PARALLEL_ENCRYPT = 0,
    parameter MEM_WIDTH = 128
)
(
    // ==================== Clock & Reset ====================
    input clk,
    input rst,
    
    // ==================== Control Signals ====================
    input start,
    input [1:0] operation,  // 00: KEYGEN, 01: ENCAP, 10: DECAP
    output done,
    output [1:0] status,
    
    // ==================== Memory Interface ====================
    input [3:0] mem_type,   // 0000-0111: h,s,u,v,d,x,y,ss
    input mem_write_en,
    input mem_read_en,
    input [16:0] mem_addr,
    input [MEM_WIDTH-1:0] mem_data_in,
    output [MEM_WIDTH-1:0] mem_data_out,
    output mem_ready,
    
    // ==================== Seeds Input (KEYGEN) ====================
    input [3:0] sk_seed_addr,
    input [31:0] sk_seed,
    input sk_seed_wen,
    input [3:0] pk_seed_addr,
    input [31:0] pk_seed,
    input pk_seed_wen,
    
    // ==================== Message Input (ENCAP) ====================
    input [31:0] m_in,
    input [7:0] m_addr,
    input m_wen,
    
    // ==================== Ciphertext Input (DECAP) ====================
    input [1:0] decap_in_type,
    input [MEM_WIDTH-1:0] decap_in,
    input [16:0] decap_in_addr,
    input decap_in_wen,
    
    // ==================== Debug ====================
    output [7:0] debug_state,
    output error_flag
);

// ==================== Internal Signals ====================
wire [MEM_WIDTH-1:0] h_data, s_data, u_data, v_data;
wire [MEM_WIDTH-1:0] d_data, x_data, y_data, ss_data;
wire [16:0] h_addr, s_addr, u_addr, v_addr;
wire [16:0] d_addr, x_addr, y_addr, ss_addr;
wire h_wen, s_wen, u_wen, v_wen;
wire d_wen, x_wen, y_wen, ss_wen;

// ==================== Memory Manager Instance ====================
hqc_kem_memory_manager #(
    .parameter_set(parameter_set),
    .MEM_WIDTH(MEM_WIDTH)
)
MEM_MANAGER (
    .clk(clk),
    .rst(rst),
    .mem_type(mem_type),
    .write_en(mem_write_en),
    .read_en(mem_read_en),
    .addr(mem_addr),
    .data_in(mem_data_in),
    .data_out(mem_data_out),
    .ready(mem_ready),
    .current_mem_type()
);

// ==================== HQC KEM Wrapper Instance ====================
hqc_kem_wrapper #(
    .parameter_set(parameter_set),
    .CT_DESIGN(CT_DESIGN),
    .PARALLEL_ENCRYPT(PARALLEL_ENCRYPT)
)
HQC_WRAPPER (
    .clk(clk),
    .rst(rst),
    .start(start),
    .operation(operation),
    .done(done),
    .status(status),
    .debug_state(debug_state),
    .error_flag(error_flag),
    
    // KEYGEN
    .sk_seed_addr(sk_seed_addr),
    .sk_seed(sk_seed),
    .sk_seed_wen(sk_seed_wen),
    .pk_seed_addr(pk_seed_addr),
    .pk_seed(pk_seed),
    .pk_seed_wen(pk_seed_wen),
    .keygen_out_type(2'b00),
    .keygen_out_en(1'b0),
    .keygen_out_addr({17{1'b0}}),
    .keygen_out(),
    
    // ENCAP
    .m_in(m_in),
    .m_addr(m_addr),
    .m_wen(m_wen),
    .encap_out_type(2'b00),
    .encap_out_en(1'b0),
    .encap_out_addr({11{1'b0}}),
    .encap_out(),
    
    // DECAP
    .decap_in_type(decap_in_type),
    .decap_in(decap_in),
    .decap_in_addr(decap_in_addr),
    .decap_in_wen(decap_in_wen),
    .decap_out_en(1'b0),
    .decap_out_addr({11{1'b0}}),
    .decap_out(),
    
    // Public Key Memory
    .h_0(h_data),
    .h_1({MEM_WIDTH{1'b0}}),
    .e_h_addr_0(h_addr),
    .e_h_addr_1(),
    .d_h_addr_0(h_addr),
    .d_h_addr_1(),
    .s_0(s_data),
    .s_1({MEM_WIDTH{1'b0}}),
    .e_s_addr_0(s_addr),
    .e_s_addr_1(),
    .d_s_addr_0(s_addr),
    .d_s_addr_1(),
    
    // Secret Key Memory
    .y_addr(y_addr),
    .y(y_data),
    
    // Ciphertext Memory
    .u_0(u_data),
    .u_1({MEM_WIDTH{1'b0}}),
    .u_addr_0(u_addr),
    .u_addr_1(),
    .v_0(v_data),
    .v_1({MEM_WIDTH{1'b0}}),
    .v_addr_0(v_addr),
    .v_addr_1()
);

endmodule
