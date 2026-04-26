//`include "clog2.v"// Used in cshake project only
//`include "../../cshake/clog2.v"// used with Gaussian Sampler
//`include "keccak_pkg.v"
//`include "../../cshake/keccak_pkg.v"

module keccak_top
(
(* clock_buffer_type="BUFG" *)  input  wire            clk,
(* io_buffer_type="IBUF" *)  input  wire            rst,
(* io_buffer_type="IBUF" *)  input  wire            din_valid,
(* io_buffer_type="OBUF" *)  output wire            din_ready,
(* io_buffer_type="IBUF" *)  input  wire [`WIN-1:0]  din,
(* io_buffer_type="OBUF" *)  output wire            dout_valid,
(* io_buffer_type="IBUF" *)  input  wire            dout_ready,
(* io_buffer_type="OBUF" *)  output wire [`WOUT-1:0] dout,

(* io_buffer_type="IBUF" *)  input wire  force_done
//(* io_buffer_type="IBUF" *)  output reg  force_done_ack
);

wire                         computation_en;
// FIXME not used? // wire [`ROUND_COUNT_WIDTH-1:0] round;
wire [`COUNTER_WIDTH-1:0]     counter;
// FIXME not used? // wire [`ROUND_COUNT_WIDTH-1:0] ram_offset;
wire                         absorb_cust;
wire                         absorb_data;
wire                         squeeze_output;
wire                         bof;
wire                         reset_ram;
wire                         mux256;
wire [`PARALLEL_SLICES-1:0]   din_padded;

control_path control_path_instance (
  .clk(clk),
  .rst(rst),
  .din_valid(din_valid),
  .din_ready(din_ready),
  .din(din),
  .dout_valid(dout_valid),
  .dout_ready(dout_ready),
  .computation_en(computation_en),
  .counter_fwd(counter),
  .din_padded(din_padded),
//  .absorb_cust_fwd(absorb_cust), // sanjay SHAKE deletion
  .absorb_data_fwd(absorb_data),
  .squeeze_output(squeeze_output),
  .bof(bof),
  .reset_ram(reset_ram),
  .mux256(mux256),
  
  .force_done(force_done)
);

data_path data_path_instance (
  .clk(clk),
  .rst(rst),
  .computation_en(computation_en),
  .round(counter[`ROUND_COUNT_WIDTH-1:0]),
  .reads(counter),
  .bof(bof),
  .absorb_data(absorb_data),
//  .absorb_cust(absorb_cust),// sanjay SHAKE deletion
  .din(din_padded),
  .squeeze_output(squeeze_output),
  .dout(dout),
  .reset_ram(reset_ram),
  .mux256(mux256)
);


//always@(posedge clk)
//begin
//    force_done_ack <= force_done;
//end

endmodule