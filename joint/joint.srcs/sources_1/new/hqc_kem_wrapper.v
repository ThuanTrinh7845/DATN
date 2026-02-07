`timescale 1ns / 1ps
/*
 * HQC KEM Wrapper Controller
 * 
 * Ch?c nãng: Ði?u khi?n module hqc_kem_joint_design
 * H? tr? 3 ch? ð?: KEYGEN, ENCAPSULATION, DECAPSULATION
 * 
 * Author: Generated
 * Date: 2026-01-30
 */
`include "clog2.v"

module hqc_kem_wrapper
#(
    parameter parameter_set = "hqc128",
    parameter CT_DESIGN = 2'b01,
    parameter PARALLEL_ENCRYPT = 0
)
(
    // ==================== Clock & Reset ====================
    input clk,
    input rst,
    
    // ==================== Control Signals ====================
    input start,
    input [1:0] operation,  // 00: KEYGEN, 01: ENCAP, 10: DECAP
    output done,
    output reg [1:0] status,  // 00: Idle, 01: Busy, 10: Done, 11: Error
    
    // ==================== KEYGEN Interface ====================
    // Secret Seed Input
    input [3:0] sk_seed_addr,
    input [31:0] sk_seed,
    input sk_seed_wen,
    
    // Public Seed Input
    input [3:0] pk_seed_addr,
    input [31:0] pk_seed,
    input pk_seed_wen,
    
    // Key Output
    input [1:0] keygen_out_type,    // 00: X, 01: Y, 10: Random, 11: S
    input keygen_out_en,
    input [16:0] keygen_out_addr,   // Adjusted for hqc128
    output [127:0] keygen_out,
    
    // ==================== ENCAP Interface ====================
    // Message Input
    input [31:0] m_in,
    input [7:0] m_addr,
    input m_wen,
    
    // Ciphertext Output
    input [1:0] encap_out_type,     // 00: theta, 01: d, 10: u, 11: v
    input encap_out_en,
    input [10:0] encap_out_addr,
    output [127:0] encap_out,
    
    // ==================== DECAP Interface ====================
    // Ciphertext Input
    input [1:0] decap_in_type,      // 00: u, 01: v, 10: d
    input [127:0] decap_in,
    input [10:0] decap_in_addr,
    input decap_in_wen,
    
    // Shared Secret Output
    input decap_out_en,
    input [10:0] decap_out_addr,
    output [127:0] decap_out,
    
    // ==================== Public Key Memory ====================
    input [127:0] h_0,
    input [127:0] h_1,
    output [10:0] e_h_addr_0,
    output [10:0] e_h_addr_1,
    output [10:0] d_h_addr_0,
    output [10:0] d_h_addr_1,
    
    input [127:0] s_0,
    input [127:0] s_1,
    output [10:0] e_s_addr_0,
    output [10:0] e_s_addr_1,
    output [10:0] d_s_addr_0,
    output [10:0] d_s_addr_1,
    
    // ==================== Secret Key Memory ====================
    output [14:0] y_addr,
    input [14:0] y,
    
    // ==================== Ciphertext Memory ====================
    input [127:0] u_0,
    input [127:0] u_1,
    output [10:0] u_addr_0,
    output [10:0] u_addr_1,
    
    input [127:0] v_0,
    input [127:0] v_1,
    output [10:0] v_addr_0,
    output [10:0] v_addr_1,
    
    // ==================== Debug/Status ====================
    output reg [7:0] debug_state,
    output reg error_flag
);

// ==================== Parameters ====================
localparam KEYGEN = 2'b00;
localparam ENCAPSULATION = 2'b01;
localparam DECAPSULATION = 2'b10;

localparam STATUS_IDLE = 2'b00;
localparam STATUS_BUSY = 2'b01;
localparam STATUS_DONE = 2'b10;
localparam STATUS_ERROR = 2'b11;

// ==================== State Machine ====================
localparam S_IDLE = 8'h00;
localparam S_KEYGEN_INIT = 8'h01;
localparam S_KEYGEN_WAIT = 8'h02;
localparam S_KEYGEN_DONE = 8'h03;
localparam S_ENCAP_INIT = 8'h04;
localparam S_ENCAP_WAIT = 8'h05;
localparam S_ENCAP_DONE = 8'h06;
localparam S_DECAP_INIT = 8'h07;
localparam S_DECAP_WAIT = 8'h08;
localparam S_DECAP_DONE = 8'h09;
localparam S_ERROR = 8'hFF;

// ==================== Internal Signals ====================
reg [7:0] current_state, next_state;
reg [1:0] current_operation;
wire done_hqc;
wire [127:0] keygen_out_hqc;
wire [127:0] encap_out_hqc;
wire [127:0] decap_out_hqc;

// ==================== Timeout Counter ====================
reg [31:0] timeout_counter;
localparam TIMEOUT_VALUE = 32'd1_000_000;  // 1M cycles
reg timeout_flag;

// ==================== HQC KEM Joint Design Instance ====================
hqc_kem_joint_design #(
    .parameter_set(parameter_set),
    .CT_DESIGN(CT_DESIGN),
    .PARALLEL_ENCRYPT(PARALLEL_ENCRYPT)
)
HQC_KEM_CORE (
    .clk(clk),
    .rst(rst),
    
    .operation(operation),
    .start(start && (current_state == S_IDLE)),
    .done(done_hqc),
    
    // KEYGEN
    .sk_seed_addr(sk_seed_addr),
    .sk_seed(sk_seed),
    .sk_seed_wen(sk_seed_wen),
    .pk_seed_addr(pk_seed_addr),
    .pk_seed(pk_seed),
    .pk_seed_wen(pk_seed_wen),
    .keygen_out_type(keygen_out_type),
    .keygen_out_en(keygen_out_en),
    .keygen_out_addr(keygen_out_addr),
    .keygen_out(keygen_out_hqc),
    
    // ENCAP
    .m_in(m_in),
    .m_addr(m_addr),
    .m_wen(m_wen),
    .encap_out_type(encap_out_type),
    .encap_out_en(encap_out_en),
    .encap_out_addr(encap_out_addr),
    .encap_out(encap_out_hqc),
    
    // DECAP
    .decap_in_type(decap_in_type),
    .decap_in(decap_in),
    .decap_in_addr(decap_in_addr),
    .decap_in_wen(decap_in_wen),
    .decap_out_en(decap_out_en),
    .decap_out_addr(decap_out_addr),
    .decap_out(decap_out_hqc),
    
    // Public Key Memory
    .h_0(h_0),
    .h_1(h_1),
    .e_h_addr_0(e_h_addr_0),
    .e_h_addr_1(e_h_addr_1),
    .d_h_addr_0(d_h_addr_0),
    .d_h_addr_1(d_h_addr_1),
    .s_0(s_0),
    .s_1(s_1),
    .e_s_addr_0(e_s_addr_0),
    .e_s_addr_1(e_s_addr_1),
    .d_s_addr_0(d_s_addr_0),
    .d_s_addr_1(d_s_addr_1),
    
    // Secret Key Memory
    .y_addr(y_addr),
    .y(y),
    
    // Ciphertext Memory
    .u_0(u_0),
    .u_1(u_1),
    .u_addr_0(u_addr_0),
    .u_addr_1(u_addr_1),
    .v_0(v_0),
    .v_1(v_1),
    .v_addr_0(v_addr_0),
    .v_addr_1(v_addr_1)
);

// ==================== Output Assignment ====================
assign done = (current_state == S_KEYGEN_DONE) || 
              (current_state == S_ENCAP_DONE) || 
              (current_state == S_DECAP_DONE);

assign keygen_out = keygen_out_hqc;
assign encap_out = encap_out_hqc;
assign decap_out = decap_out_hqc;

// ==================== Timeout Logic ====================
always @(posedge clk) begin
    if (rst || current_state == S_IDLE) begin
        timeout_counter <= 32'h0;
        timeout_flag <= 1'b0;
    end
    else begin
        if (timeout_counter >= TIMEOUT_VALUE) begin
            timeout_flag <= 1'b1;
        end
        else begin
            timeout_counter <= timeout_counter + 1'b1;
        end
    end
end

// ==================== State Machine (Sequential) ====================
always @(posedge clk) begin
    if (rst) begin
        current_state <= S_IDLE;
        current_operation <= 2'b00;
        error_flag <= 1'b0;
        status <= STATUS_IDLE;
        debug_state <= S_IDLE;
    end
    else begin
        current_state <= next_state;
        debug_state <= next_state;
        
        // Error Detection
        if (timeout_flag && current_state != S_IDLE) begin
            error_flag <= 1'b1;
        end
        
        // Status Update
        case (next_state)
            S_IDLE: status <= STATUS_IDLE;
            S_KEYGEN_INIT, S_KEYGEN_WAIT,
            S_ENCAP_INIT, S_ENCAP_WAIT,
            S_DECAP_INIT, S_DECAP_WAIT: status <= STATUS_BUSY;
            S_KEYGEN_DONE, S_ENCAP_DONE, S_DECAP_DONE: status <= STATUS_DONE;
            S_ERROR: status <= STATUS_ERROR;
            default: status <= STATUS_IDLE;
        endcase
    end
end

// ==================== State Machine (Combinational) ====================
always @(*) begin
    next_state = current_state;
    
    case (current_state)
        // ========== IDLE STATE ==========
        S_IDLE: begin
            if (start) begin
                case (operation)
                    KEYGEN: next_state = S_KEYGEN_INIT;
                    ENCAPSULATION: next_state = S_ENCAP_INIT;
                    DECAPSULATION: next_state = S_DECAP_INIT;
                    default: next_state = S_ERROR;
                endcase
            end
            else begin
                next_state = S_IDLE;
            end
        end
        
        // ========== KEYGEN STATES ==========
        S_KEYGEN_INIT: begin
            next_state = S_KEYGEN_WAIT;
        end
        
        S_KEYGEN_WAIT: begin
            if (done_hqc) begin
                next_state = S_KEYGEN_DONE;
            end
            else if (timeout_flag) begin
                next_state = S_ERROR;
            end
            else begin
                next_state = S_KEYGEN_WAIT;
            end
        end
        
        S_KEYGEN_DONE: begin
            if (!start) begin
                next_state = S_IDLE;
            end
            else begin
                next_state = S_KEYGEN_DONE;
            end
        end
        
        // ========== ENCAP STATES ==========
        S_ENCAP_INIT: begin
            next_state = S_ENCAP_WAIT;
        end
        
        S_ENCAP_WAIT: begin
            if (done_hqc) begin
                next_state = S_ENCAP_DONE;
            end
            else if (timeout_flag) begin
                next_state = S_ERROR;
            end
            else begin
                next_state = S_ENCAP_WAIT;
            end
        end
        
        S_ENCAP_DONE: begin
            if (!start) begin
                next_state = S_IDLE;
            end
            else begin
                next_state = S_ENCAP_DONE;
            end
        end
        
        // ========== DECAP STATES ==========
        S_DECAP_INIT: begin
            next_state = S_DECAP_WAIT;
        end
        
        S_DECAP_WAIT: begin
            if (done_hqc) begin
                next_state = S_DECAP_DONE;
            end
            else if (timeout_flag) begin
                next_state = S_ERROR;
            end
            else begin
                next_state = S_DECAP_WAIT;
            end
        end
        
        S_DECAP_DONE: begin
            if (!start) begin
                next_state = S_IDLE;
            end
            else begin
                next_state = S_DECAP_DONE;
            end
        end
        
        // ========== ERROR STATE ==========
        S_ERROR: begin
            if (rst) begin
                next_state = S_IDLE;
            end
            else begin
                next_state = S_ERROR;
            end
        end
        
        default: next_state = S_IDLE;
    endcase
end

endmodule
