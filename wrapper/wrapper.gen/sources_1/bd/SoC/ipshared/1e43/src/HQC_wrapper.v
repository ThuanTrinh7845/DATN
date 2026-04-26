`timescale 1ns / 1ps
// `include "clog2.v" 

module HQC_wrapper (
    input clk,
    
    input [31:0] gpio_ctrl,  
    input [31:0] gpio_addr,  
    input [31:0] gpio_wdata, 
    output [31:0] gpio_rdata 
);

    localparam CORE_ADDR_W = 9; 
    
    localparam Y_WIDTH = 15;
    localparam Y_DEPTH = 66; 
    
    localparam D_WIDTH = 32;
    localparam D_DEPTH = 16; 


    wire rst            = gpio_ctrl[0];
    wire start          = gpio_ctrl[1]; 
    wire [1:0] op       = gpio_ctrl[3:2]; 
    
    wire sk_wen         = gpio_ctrl[4];
    wire pk_wen         = gpio_ctrl[5];
    wire ram_wen        = gpio_ctrl[6];   
    wire [2:0] ram_sel  = gpio_ctrl[9:7]; 
    wire [1:0] word_sel = gpio_ctrl[11:10]; 
    wire out_en         = gpio_ctrl[12];    
    wire [1:0] out_type = gpio_ctrl[14:13]; 
    wire read_src_sel   = gpio_ctrl[15];    
    
    wire [1:0] decap_in_type = gpio_ctrl[17:16];
    wire decap_in_wen        = gpio_ctrl[18];

    wire pynq_access    = ram_wen || (read_src_sel == 1'b1);
    wire m_wen_ctrl     = ram_wen && (ram_sel == 3'd6); // Ð?i ID c?a Message thành 6 ð? nhý?ng 4,5 cho Y, D

    
    reg [127:0] buffer_128;
    always @(posedge clk) begin
        if (rst) buffer_128 <= 0;
        else case (word_sel)
            2'b00: buffer_128[31:0]   <= gpio_wdata;
            2'b01: buffer_128[63:32]  <= gpio_wdata;
            2'b10: buffer_128[95:64]  <= gpio_wdata;
            2'b11: buffer_128[127:96] <= gpio_wdata;
        endcase
    end

    // =========================================================================
    // NÂNG C?P: Y_MEM T? SINGLE LÊN DUAL
    // =========================================================================
    wire [6:0] core_y_addr;
    wire [Y_WIDTH-1:0] core_y_data, y_q1;
    
    mem_dual #(
        .WIDTH(Y_WIDTH), 
        .DEPTH(Y_DEPTH), 
//        .FILE("y_128.in"),
        .INIT(0)
    ) MEM_Y_INST (
        .clock(clk),
        // Port 0: Dành cho Core
        .address_0(core_y_addr),  
        .data_0({Y_WIDTH{1'b0}}), 
        .wren_0(1'b0),         
        .q_0(core_y_data),
        
        // Port 1: Dành cho AXI (pynq_access) - ram_sel = 4
        .address_1(pynq_access ? gpio_addr[6:0] : 7'd0), 
        .data_1(buffer_128[Y_WIDTH-1:0]), 
        .wren_1(ram_wen && (ram_sel == 3'd4)), 
        .q_1(y_q1)
    );

    // =========================================================================
    // NÂNG C?P: D_MEM T? SINGLE LÊN DUAL
    // =========================================================================
    wire [D_WIDTH-1:0] d_rom_out, d_q1;
    
    mem_dual #(
        .WIDTH(D_WIDTH), 
        .DEPTH(D_DEPTH), 
//        .FILE("d_128.in"), 
        .INIT(0)
    ) MEM_D_INST (
        .clock(clk),
        // Port 0: Dành cho Core (Decap dùng)
        .address_0(gpio_addr[3:0]), // (Gi? nguyên logic c? c?a ngý?i)
        .data_0(32'd0),          
        .wren_0(1'b0),
        .q_0(d_rom_out),
        
        // Port 1: Dành cho AXI (pynq_access) - ram_sel = 5
        .address_1(pynq_access ? gpio_addr[3:0] : 4'd0), 
        .data_1(buffer_128[D_WIDTH-1:0]), 
        .wren_1(ram_wen && (ram_sel == 3'd5)), 
        .q_1(d_q1)         
    );
    
    wire [127:0] core_decap_in;
    assign core_decap_in = (decap_in_type == 2'd1) ? {96'd0, d_rom_out} : 128'd0;



    wire [CORE_ADDR_W-1:0] c_e_h_addr_0, c_e_h_addr_1; 
    wire [CORE_ADDR_W-1:0] c_d_h_addr_0, c_d_h_addr_1; 
    wire [CORE_ADDR_W-1:0] c_e_s_addr_0, c_e_s_addr_1;
    wire [CORE_ADDR_W-1:0] c_d_s_addr_0, c_d_s_addr_1;
    wire [CORE_ADDR_W-1:0] c_d_u_addr_0, c_d_u_addr_1; 
    wire [CORE_ADDR_W-1:0] c_d_v_addr_0, c_d_v_addr_1; 

    wire [12:0] e_h_addr_0, e_h_addr_1, d_h_addr_0, d_h_addr_1; 
    wire [12:0] e_s_addr_0, e_s_addr_1, d_s_addr_0, d_s_addr_1;
    wire [12:0] d_u_addr_0, d_u_addr_1, d_v_addr_0, d_v_addr_1;

    assign e_h_addr_0 = {4'd0, c_e_h_addr_0};
    assign e_h_addr_1 = {4'd0, c_e_h_addr_1};
    assign d_h_addr_0 = {4'd0, c_d_h_addr_0}; 
    assign d_h_addr_1 = {4'd0, c_d_h_addr_1};
    assign e_s_addr_0 = {4'd0, c_e_s_addr_0}; 
    assign e_s_addr_1 = {4'd0, c_e_s_addr_1};
    assign d_s_addr_0 = {4'd0, c_d_s_addr_0}; 
    assign d_s_addr_1 = {4'd0, c_d_s_addr_1};
    assign d_u_addr_0 = {4'd0, c_d_u_addr_0}; 
    assign d_u_addr_1 = {4'd0, c_d_u_addr_1};
    assign d_v_addr_0 = {4'd0, c_d_v_addr_0}; 
    assign d_v_addr_1 = {4'd0, c_d_v_addr_1};

    wire [12:0] core_h_addr_0, core_s_addr_0, core_h_addr_1, core_s_addr_1;
    assign core_h_addr_0 = (op == 2'b01) ? e_h_addr_0 : d_h_addr_0;
    assign core_h_addr_1 = (op == 2'b01) ? e_h_addr_1 : d_h_addr_1;
    assign core_s_addr_0 = (op == 2'b01) ? e_s_addr_0 : d_s_addr_0;
    assign core_s_addr_1 = (op == 2'b01) ? e_s_addr_1 : d_s_addr_1;


    wire [127:0] h_q0, s_q0, u_q0, v_q0, h_q1, s_q1, u_q1, v_q1; 

    mem_dual #(.WIDTH(128), .DEPTH(139)) RAM_H (
        .clock(clk), 
        .address_0(core_h_addr_0), 
        .wren_0(1'b0), 
        .q_0(h_q0), 
        .address_1(pynq_access ? gpio_addr[12:0] : core_h_addr_1), 
        .data_1(buffer_128), 
        .wren_1(ram_wen && (ram_sel==3'd0)), 
        .q_1(h_q1) 
    );
    mem_dual #(.WIDTH(128), .DEPTH(139)) RAM_S (
        .clock(clk), 
        .address_0(core_s_addr_0), 
        .wren_0(1'b0), 
        .q_0(s_q0), 
        .address_1(pynq_access ? gpio_addr[12:0] : core_s_addr_1), 
        .data_1(buffer_128), .wren_1(ram_wen && (ram_sel==3'd1)), 
        .q_1(s_q1)
    );
    mem_dual #(.WIDTH(128), .DEPTH(139)) RAM_U (
        .clock(clk), 
        .address_0(d_u_addr_0), 
        .wren_0(1'b0), 
        .q_0(u_q0),
        .address_1(pynq_access ? gpio_addr[12:0] : d_u_addr_1), 
        .data_1(buffer_128), .wren_1(ram_wen && (ram_sel==3'd2)), 
        .q_1(u_q1)
    );
    mem_dual #(.WIDTH(128), .DEPTH(139)) RAM_V (
        .clock(clk), 
        .address_0(d_v_addr_0), 
        .wren_0(1'b0), 
        .q_0(v_q0),
        .address_1(pynq_access ? gpio_addr[12:0] : d_v_addr_1), 
        .data_1(buffer_128), .wren_1(ram_wen && (ram_sel==3'd3)), 
        .q_1(v_q1)
    );


    wire done_core_pulse; 
    wire [127:0] keygen_out_128, encap_out_128, decap_out_128;

    hqc_kem_joint_design DUT (
        .clk(clk), .rst(rst), .operation(op), .start(start), .done(done_core_pulse), 

        // Keygen
        .sk_seed(gpio_wdata), 
        .sk_seed_addr(gpio_addr[3:0]), 
        .sk_seed_wen(sk_wen),
        .pk_seed(gpio_wdata), 
        .pk_seed_addr(gpio_addr[3:0]), 
        .pk_seed_wen(pk_wen),
        .keygen_out(keygen_out_128), 
        .keygen_out_en(out_en), 
        .keygen_out_addr(gpio_addr[12:0]), 
        .keygen_out_type(out_type),

        // Encap Inputs
        .m_in(gpio_wdata), 
        .m_addr(gpio_addr[3:0]), 
        .m_wen(m_wen_ctrl),

        // Shared RAM Interface
        .h_0(h_q0), 
        .h_1(h_q1), 
        .s_0(s_q0), 
        .s_1(s_q1), 
        .e_h_addr_0(c_e_h_addr_0), 
        .e_h_addr_1(c_e_h_addr_1), 
        .e_s_addr_0(c_e_s_addr_0), 
        .e_s_addr_1(c_e_s_addr_1),
        .d_h_addr_0(c_d_h_addr_0), 
        .d_h_addr_1(c_d_h_addr_1), 
        .d_s_addr_0(c_d_s_addr_0), 
        .d_s_addr_1(c_d_s_addr_1),
        
        // Encap Outputs
        .encap_out(encap_out_128), 
        .encap_out_en(out_en), 
        .encap_out_addr(gpio_addr[12:0]), 
        .encap_out_type(out_type),

        // Decap Outputs
        .decap_out(decap_out_128), 
        .decap_out_en(out_en), 
        .decap_out_addr(gpio_addr[12:0]),
        
        // DECAP INPUTS
        .decap_in(core_decap_in),        
        .decap_in_addr(gpio_addr[3:0]), 
        .decap_in_type(decap_in_type),   
        .decap_in_wen(decap_in_wen),    
        
        .y(core_y_data),                
        .y_addr(core_y_addr),            
        
        // U & V Interface
        .u_0(u_q0), 
        .u_1(u_q1), 
        .v_0(v_q0), 
        .v_1(v_q1),
        .u_addr_0(c_d_u_addr_0), 
        .u_addr_1(c_d_u_addr_1), 
        .v_addr_0(c_d_v_addr_0), 
        .v_addr_1(c_d_v_addr_1)
    );
    

    reg done_sticky;
    always @(posedge clk) begin
        if (rst || start) done_sticky <= 0;
        else if (done_core_pulse) done_sticky <= 1;
    end

    reg [127:0] read_data_source_128;
    always @(*) begin
        if (read_src_sel == 1'b1) begin
            case (ram_sel)
                3'd0: read_data_source_128 = h_q1;
                3'd1: read_data_source_128 = s_q1;
                3'd2: read_data_source_128 = u_q1; 
                3'd3: read_data_source_128 = v_q1; 
                3'd4: read_data_source_128 = {113'd0, y_q1}; // RAM Y
                3'd5: read_data_source_128 = {96'd0, d_q1};  // RAM D
                default: read_data_source_128 = 0;
            endcase
        end else begin
            case (op)
                2'b00: read_data_source_128 = keygen_out_128; 
                2'b01: read_data_source_128 = encap_out_128; 
                2'b10: read_data_source_128 = decap_out_128; 
                default: read_data_source_128 = 0;
            endcase
        end
    end

    reg [31:0] final_rdata_32;
    always @(*) begin
        case (word_sel)
            2'b00: final_rdata_32 = read_data_source_128[31:0];
            2'b01: final_rdata_32 = read_data_source_128[63:32];
            2'b10: final_rdata_32 = read_data_source_128[95:64];
            2'b11: final_rdata_32 = read_data_source_128[127:96];
        endcase
    end

    assign gpio_rdata = (gpio_addr == 32'hFFFFFFFF) ? {31'd0, done_sticky} : final_rdata_32;
endmodule