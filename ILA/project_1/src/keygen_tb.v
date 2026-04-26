`timescale 1ns / 1ps



module keygen_tb;



    reg clk = 0;

    always #5 clk = ~clk; // Clock 100MHz



    reg [31:0] gpio_ctrl = 0;

    reg [31:0] gpio_addr = 0;

    reg [31:0] gpio_wdata = 0;

    wire [31:0] gpio_rdata;



    reg [31:0] sk_seed_mem [0:9]; 

    reg [31:0] pk_seed_mem [0:9];



    HQC_wrapper DUT (

        .clk(clk),

        .gpio_ctrl(gpio_ctrl),

        .gpio_addr(gpio_addr),

        .gpio_wdata(gpio_wdata),

        .gpio_rdata(gpio_rdata)

    );



    task load_seeds;

        integer i;

        begin

            $display("--- [TB] Loading SK & PK Seeds ---");

            

            for (i = 0; i < 10; i = i + 1) begin 

                gpio_wdata = sk_seed_mem[i];   

                gpio_addr  = i;                 

                #10; 

                

                gpio_ctrl = gpio_ctrl | (1 << 4); 

                #20; 

                

                gpio_ctrl = gpio_ctrl & ~(1 << 4);

                #10;

            end



            $display("--- [TB] SK Seed Loaded. Loading PK Seed... ---");



            for (i = 0; i < 10; i = i + 1) begin 

                gpio_wdata = pk_seed_mem[i];

                gpio_addr  = i;

                #10; 

                

                gpio_ctrl = gpio_ctrl | (1 << 5); 

                #20; 

                

                gpio_ctrl = gpio_ctrl & ~(1 << 5);

                #10;

            end

        end

    endtask



    integer timeout_counter; 



    initial begin

        $display("=== STARTING TESTBENCH (INTERNAL DUMP MODE) ===");

        gpio_ctrl = 0;

        gpio_addr = 0;

        gpio_wdata = 0;



        $readmemb("sk_seed.in", sk_seed_mem);

        $readmemb("pk_seed.in", pk_seed_mem);

        

        #100;



        $display("--- [TB] Step 1: Resetting Core ---");

        gpio_ctrl[0] = 1; 

        #50; 

        gpio_ctrl[0] = 0; 

        #50;



        $display("--- [TB] Step 2: Loading Seeds via AXI ---");

        load_seeds();



        $display("--- [TB] Step 3: Triggering Start ---");

        gpio_ctrl[3:2] = 2'b00; 

        #10;

        gpio_ctrl[1] = 1;       

        #20;

        gpio_ctrl[1] = 0;      

        

        $display("--- [TB] Step 4: Polling for Done Status ---");

        gpio_addr = 32'hFFFFFFFF; 

        timeout_counter = 0;

        

        while (gpio_rdata[0] !== 1'b1) begin

            #100; 

            timeout_counter = timeout_counter + 1;

            if (timeout_counter > 200000) begin 

                $display("--- [TB] ERROR: TIMEOUT! Core did not finish. ---");

                $finish;

            end

        end

        

        $display("--- [TB] CORE DONE DETECTED! (After %0d cycles) ---", timeout_counter);

        

        $display("--- [TB] Step 5: Dumping Internal Memory to .in Files ---");

        #100;



        $writememb("h_128.in", DUT.DUT.KEYGEN_MODULE.VECTSETRAND.rand_mem.mem);

        

        $writememb("x_128.in", DUT.DUT.KEYGEN_MODULE.x_mem.mem);

        

        $writememb("y_128.in", DUT.DUT.KEYGEN_MODULE.genblk1.FIXEDWEIGHT.loca_mem.mem);

        

        $writememb("s_128.in", DUT.DUT.POLY_MULT.INTERLEAVED_RED_MEM.mem);



        

        $display("--- [TB] Step 6: Reading Data via Interface (Frontdoor) ---");

        

        begin : read_h_interface

            integer i, w;

            integer fd_h;

            reg [127:0] val_128;

            reg [31:0] slice;

            

            fd_h = $fopen("h_128_interface.out", "w");

            

            for (i = 0; i < 139; i = i + 1) begin

                gpio_addr = i;

                val_128 = 0;

                

                for (w = 0; w < 4; w = w + 1) begin

                    gpio_ctrl = (2 << 13) | (1 << 12) | (w << 10); 

                    

                    #50; 

                    slice = gpio_rdata;

                    

                    val_128 = val_128 | ({96'd0, slice} << (32 * w));

                end

                

                $fwrite(fd_h, "%b\n", val_128); 

            end

            

            $fclose(fd_h);

        end

        

        $display("--- [TB] Reading S via AXI Interface ---");

        begin : read_s_interface

            integer i, w;

            integer fd_s;

            reg [127:0] val_128;

            reg [31:0] slice;

            fd_s = $fopen("s_128_interface.out", "w");

            for (i = 0; i < 139; i = i + 1) begin

                gpio_addr = i;

                val_128 = 0;

                for (w = 0; w < 4; w = w + 1) begin

                    gpio_ctrl = (3 << 13) | (1 << 12) | (w << 10); 

                    #50; 

                    val_128 = val_128 | ({96'd0, gpio_rdata} << (32 * w));

                end

                $fwrite(fd_s, "%b\n", val_128); 

            end

            $fclose(fd_s);

        end



        $display("--- [TB] Reading X via AXI Interface ---");

        begin : read_x_interface

            integer i, w;

            reg [127:0] val_128;

            reg [31:0] slice;

            integer fd_x;

            fd_x = $fopen("x_128_interface.out", "w");

            

            for (i = 0; i < 66; i = i + 1) begin // WEIGHT = 66

                gpio_addr = i;

                



                gpio_ctrl = (0 << 13) | (1 << 12) | (0 << 10); 

                #50; 

                

                $fwrite(fd_x, "%015b\n", gpio_rdata[14:0]); 

            end

            $fclose(fd_x);

        end





        $display("--- [TB] Reading Y via AXI Interface ---");

        begin : read_y_interface

            integer i, w;

            reg [127:0] val_128;

            reg [31:0] slice;

            integer fd_y;

            fd_y = $fopen("y_128_interface.out", "w");

            

            for (i = 0; i < 66; i = i + 1) begin // WEIGHT = 66

                gpio_addr = i;

                



                gpio_ctrl = (1 << 13) | (1 << 12) | (0 << 10); 

                #50; 

                

                $fwrite(fd_y, "%015b\n", gpio_rdata[14:0]); 

            end

            $fclose(fd_y);

        end



        $finish;

    end



endmodule