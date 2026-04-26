`timescale 1ns / 1ps

module encap_tb_fd;

    reg clk = 0;
    always #5 clk = ~clk; // Clock 100MHz

    // AXI GPIO Signals
    reg [31:0] gpio_ctrl = 0;
    reg [31:0] gpio_addr = 0;
    reg [31:0] gpio_wdata = 0;
    wire [31:0] gpio_rdata;

    parameter parameter_set = "hqc128";
    parameter N_MEM_WIDTH = 139; 
    parameter MSG_DEPTH   = 4;    

    reg [127:0] h_mem_in [0:N_MEM_WIDTH-1];
    reg [127:0] s_mem_in [0:N_MEM_WIDTH-1];
    reg [31:0]  msg_mem_in [0:MSG_DEPTH-1];

    integer i, w;
    integer timeout_cnt;
    integer fd_ss;
    
    reg [255:0] ss_filename;

    HQC_wrapper DUT (
        .clk(clk),
        .gpio_ctrl(gpio_ctrl),
        .gpio_addr(gpio_addr),
        .gpio_wdata(gpio_wdata),
        .gpio_rdata(gpio_rdata)
    );

    function [31:0] swap_endian_32(input [31:0] in);
        begin
            swap_endian_32 = {in[7:0], in[15:8], in[23:16], in[31:24]};
        end
    endfunction

    // Gi? nguyên hàm n?p RAM_128
    task load_ram_128(input [2:0] target_ram_sel);
        reg [127:0] current_val;
        begin
            $display("--- [TB] Loading RAM ID %0d (0=H, 1=S) ---", target_ram_sel);
            for (i = 0; i < N_MEM_WIDTH; i = i + 1) begin
                if (target_ram_sel == 3'd0) current_val = h_mem_in[i];
                else current_val = s_mem_in[i];
                
                gpio_addr = i;
                for (w = 0; w < 4; w = w + 1) begin
                    gpio_wdata = current_val[31:0];
                    current_val = current_val >> 32;
                    gpio_ctrl = (w << 10); // set word_sel
                    #10;
                end
                
                gpio_ctrl = (3 << 10) | (target_ram_sel << 7) | (1 << 6); 
                #10;
                gpio_ctrl = 0; 
                #10;
            end
        end
    endtask

    task load_message;
        begin
            $display("--- [TB] Loading Message m (RAM_SEL=6)... ---");
            for (i = 0; i < MSG_DEPTH; i = i + 1) begin
                gpio_wdata = msg_mem_in[i];
                gpio_addr  = i;
                // [FIX 1]: Ð?i ID Message t? 4 thành 6
                gpio_ctrl = (6 << 7) | (1 << 6); 
                #10;
                gpio_ctrl = 0;
                #10;
            end
        end
    endtask

    initial begin
        $display("=== STARTING ENCAP TB (FRONTDOOR + INTERNAL DUMP) ===");
        
        $readmemb("h_128.in", h_mem_in);
        $readmemb("s_128.in", s_mem_in);
        $readmemb("msg_128.in", msg_mem_in);
        
        gpio_ctrl = 1; #50; 
        gpio_ctrl = 0; #50;

        load_ram_128(0); 
        load_ram_128(1); 
        load_message();  

        // Kích ho?t Encap (Op=01)
        $display("--- [TB] Triggering Encap Start ---");
        gpio_ctrl = (1 << 2) | (1 << 1); 
        #20;
        gpio_ctrl = (1 << 2);            
        
        // Ch? Done
        $display("--- [TB] Polling for Done... ---");
        gpio_addr = 32'hFFFFFFFF;
        timeout_cnt = 0;
        while (gpio_rdata[0] !== 1'b1) begin
            #100;
            timeout_cnt = timeout_cnt + 1;
            if (timeout_cnt > 200000) begin
                $display("--- [ERROR] TIMEOUT ---");
                $finish;
            end
        end
        $display("--- [TB] DONE DETECTED! (After %0d cycles) ---", timeout_cnt);
        #100;

        // Lýu Shared Secret
        case (parameter_set)
            "hqc128": ss_filename = "ss_output_128.out";
            "hqc192": ss_filename = "ss_output_192.out";
            "hqc256": ss_filename = "ss_output_256.out";
            default:  ss_filename = "ss_output.out";
        endcase

        $display("--- [TB] Writing Shared Secret to %0s ---", ss_filename);
        
        fd_ss = $fopen(ss_filename, "w"); 
        begin : read_ss_blk
            reg [31:0] raw_slice, swapped_slice;
            for (i=0; i<16; i=i+1) begin
                gpio_addr = i;
                
                // C?u h?nh Ctrl ð? ð?c Output Encap
                gpio_ctrl = (1 << 12) | (1 << 2); 
                #50;
                raw_slice = gpio_rdata;
                swapped_slice = swap_endian_32(raw_slice);
                
                // [FIX 3]: Dùng %08x ð? tránh r?t s? 0
                $fwrite(fd_ss, "%08x", swapped_slice);
            end
        end
        $fclose(fd_ss);
        
        // =========================================================
        // [FIX 2]: Ð?c D b?ng PS Interface (Hex format)
        // =========================================================
        $display("--- [TB] Dumping D via PS Interface... ---");
        begin : read_d_interface
            integer fd_d;
            fd_d = $fopen("d_128.in", "w");
            for (i = 0; i < 16; i = i + 1) begin
                gpio_addr = i;
                // Ð?c t? RAM_D (ram_sel = 5), word_sel=0 (v? D ch? r?ng 32-bit)
                // Bit 15=1 (Read Src), Bit 9:7=5 (RAM D)
                gpio_ctrl = (1 << 15) | (5 << 7) | (0 << 10);
                #50;
                // Ghi ra file theo format Hex (Decap c?n cái này)
                $fwrite(fd_d, "%08x\n", gpio_rdata); 
            end
            $fclose(fd_d);
        end

        // V?n dùng writememb cho U và V (Binary Format)
        $display("--- [TB] Dumping u, v, d to internal .in files ---");
        case (parameter_set)
            "hqc128": begin
                $writememb("u_128.in", DUT.DUT.ENCAP_MODULE.genblk1.ENCRYPT.u_mem.mem);
                $writememb("v_128.in", DUT.DUT.ENCAP_MODULE.genblk1.ENCRYPT.POLY_MULT.INTERLEAVED_RED_MEM.mem);
                $writememb("d_128.in", DUT.DUT.ENCAP_MODULE.D_MEM.mem); // <--- Móc tr?c ti?p (Hex format)
                $fflush();
            end
            
            "hqc192": begin
                $writememb("u_192.in", DUT.DUT.ENCAP_MODULE.genblk1.ENCRYPT.u_mem.mem);
                $writememb("v_192.in", DUT.DUT.ENCAP_MODULE.genblk1.ENCRYPT.POLY_MULT.INTERLEAVED_RED_MEM.mem);
                $writememb("d_192.in", DUT.DUT.ENCAP_MODULE.D_MEM.mem);
                $fflush();
            end

            "hqc256": begin
                $writememb("u_256.in", DUT.DUT.ENCAP_MODULE.genblk1.ENCRYPT.u_mem.mem);
                $writememb("v_256.in", DUT.DUT.ENCAP_MODULE.genblk1.ENCRYPT.POLY_MULT.INTERLEAVED_RED_MEM.mem);
                $writememb("d_256.in", DUT.DUT.ENCAP_MODULE.D_MEM.mem);
                $fflush();
            end
        endcase

        $display("=== SUCCESS: ALL FILES WRITTEN ===");
        $finish;
    end

endmodule