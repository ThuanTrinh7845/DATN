vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xilinx_vip
vlib questa_lib/msim/axi_infrastructure_v1_1_0
vlib questa_lib/msim/axi_vip_v1_1_13
vlib questa_lib/msim/zynq_ultra_ps_e_vip_v1_0_13
vlib questa_lib/msim/xil_defaultlib
vlib questa_lib/msim/generic_baseblocks_v2_1_0
vlib questa_lib/msim/axi_register_slice_v2_1_27
vlib questa_lib/msim/fifo_generator_v13_2_7
vlib questa_lib/msim/axi_data_fifo_v2_1_26
vlib questa_lib/msim/axi_crossbar_v2_1_28
vlib questa_lib/msim/lib_cdc_v1_0_2
vlib questa_lib/msim/proc_sys_reset_v5_0_13
vlib questa_lib/msim/axi_protocol_converter_v2_1_27
vlib questa_lib/msim/axi_clock_converter_v2_1_26
vlib questa_lib/msim/blk_mem_gen_v8_4_5
vlib questa_lib/msim/axi_dwidth_converter_v2_1_27

vmap xilinx_vip questa_lib/msim/xilinx_vip
vmap axi_infrastructure_v1_1_0 questa_lib/msim/axi_infrastructure_v1_1_0
vmap axi_vip_v1_1_13 questa_lib/msim/axi_vip_v1_1_13
vmap zynq_ultra_ps_e_vip_v1_0_13 questa_lib/msim/zynq_ultra_ps_e_vip_v1_0_13
vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vmap generic_baseblocks_v2_1_0 questa_lib/msim/generic_baseblocks_v2_1_0
vmap axi_register_slice_v2_1_27 questa_lib/msim/axi_register_slice_v2_1_27
vmap fifo_generator_v13_2_7 questa_lib/msim/fifo_generator_v13_2_7
vmap axi_data_fifo_v2_1_26 questa_lib/msim/axi_data_fifo_v2_1_26
vmap axi_crossbar_v2_1_28 questa_lib/msim/axi_crossbar_v2_1_28
vmap lib_cdc_v1_0_2 questa_lib/msim/lib_cdc_v1_0_2
vmap proc_sys_reset_v5_0_13 questa_lib/msim/proc_sys_reset_v5_0_13
vmap axi_protocol_converter_v2_1_27 questa_lib/msim/axi_protocol_converter_v2_1_27
vmap axi_clock_converter_v2_1_26 questa_lib/msim/axi_clock_converter_v2_1_26
vmap blk_mem_gen_v8_4_5 questa_lib/msim/blk_mem_gen_v8_4_5
vmap axi_dwidth_converter_v2_1_27 questa_lib/msim/axi_dwidth_converter_v2_1_27

vlog -work xilinx_vip  -incr -mfcu  -sv -L axi_vip_v1_1_13 -L zynq_ultra_ps_e_vip_v1_0_13 -L xilinx_vip "+incdir+D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
"D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
"D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work axi_infrastructure_v1_1_0  -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/abef/hdl" "+incdir+../../../bd/hqc_accelerator/ipshared/362a/src" "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/362a/src" "+incdir+D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_vip_v1_1_13  -incr -mfcu  -sv -L axi_vip_v1_1_13 -L zynq_ultra_ps_e_vip_v1_0_13 -L xilinx_vip "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/abef/hdl" "+incdir+../../../bd/hqc_accelerator/ipshared/362a/src" "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/362a/src" "+incdir+D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/ffc2/hdl/axi_vip_v1_1_vl_rfs.sv" \

vlog -work zynq_ultra_ps_e_vip_v1_0_13  -incr -mfcu  -sv -L axi_vip_v1_1_13 -L zynq_ultra_ps_e_vip_v1_0_13 -L xilinx_vip "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/abef/hdl" "+incdir+../../../bd/hqc_accelerator/ipshared/362a/src" "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/362a/src" "+incdir+D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/abef/hdl/zynq_ultra_ps_e_vip_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/abef/hdl" "+incdir+../../../bd/hqc_accelerator/ipshared/362a/src" "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/362a/src" "+incdir+D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../bd/hqc_accelerator/ip/hqc_accelerator_zynq_ultra_ps_e_0_0/sim/hqc_accelerator_zynq_ultra_ps_e_0_0_vip_wrapper.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/HQC_wrapper.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/add_fft.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/axi_wrapper_slave_lite_v1_0_S00_AXI.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/barrett_red_gen.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/cdw_xor_tmp.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/concat_code.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/control_path.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/data_path.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/decap.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/decrypt.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/encap.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/encrypt.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/encrypt_parallel.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/fft_leaves_butterfly.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/fft_part1.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/fft_part2.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/fft_retrieve_error_poly.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/fixed_weight.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/fixed_weight_ct.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/fixed_weight_cww.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/gf_mul.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/gfmul_00.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/gfmul_01.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/hqc_barrett_red.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/hqc_decod_top.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/hqc_kem_joint_design.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/hqc_rmdecod_ctrl.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/hqc_rmdecod_expnsum.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/hqc_rmdecod_findpeaks.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/hqc_rmdecod_hadamard.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/hqc_rmdecod_top.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/hqc_rsdecod_elp.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/hqc_rsdecod_err_val.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/hqc_rsdecod_roots.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/hqc_rsdecod_syndromes.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/hqc_rsdecod_top.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/hqc_rsdecod_zploly.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/karatsuba_small.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/keccak_top.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/keygen.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/loc_based_adder.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/mem_dual.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/mem_single.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/mod34.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/onegen.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/onegen_ct.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/poly_mult.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/rc.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/reed_muller_encode.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/reed_solomon_encode.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/rm_encoder.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/state_ram.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/stateram_inference.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/syncfifo.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/transform.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/v_minus_uy.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/vect_set_random.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/xor_based_adder.v" \
"../../../bd/hqc_accelerator/ipshared/362a/src/axi_wrapper.v" \
"../../../bd/hqc_accelerator/ip/hqc_accelerator_axi_wrapper_0_0/sim/hqc_accelerator_axi_wrapper_0_0.v" \

vlog -work generic_baseblocks_v2_1_0  -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/abef/hdl" "+incdir+../../../bd/hqc_accelerator/ipshared/362a/src" "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/362a/src" "+incdir+D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \

vlog -work axi_register_slice_v2_1_27  -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/abef/hdl" "+incdir+../../../bd/hqc_accelerator/ipshared/362a/src" "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/362a/src" "+incdir+D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/f0b4/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work fifo_generator_v13_2_7  -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/abef/hdl" "+incdir+../../../bd/hqc_accelerator/ipshared/362a/src" "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/362a/src" "+incdir+D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/83df/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_7  -93  \
"../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/83df/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_7  -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/abef/hdl" "+incdir+../../../bd/hqc_accelerator/ipshared/362a/src" "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/362a/src" "+incdir+D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/83df/hdl/fifo_generator_v13_2_rfs.v" \

vlog -work axi_data_fifo_v2_1_26  -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/abef/hdl" "+incdir+../../../bd/hqc_accelerator/ipshared/362a/src" "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/362a/src" "+incdir+D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/3111/hdl/axi_data_fifo_v2_1_vl_rfs.v" \

vlog -work axi_crossbar_v2_1_28  -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/abef/hdl" "+incdir+../../../bd/hqc_accelerator/ipshared/362a/src" "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/362a/src" "+incdir+D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/c40e/hdl/axi_crossbar_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/abef/hdl" "+incdir+../../../bd/hqc_accelerator/ipshared/362a/src" "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/362a/src" "+incdir+D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../bd/hqc_accelerator/ip/hqc_accelerator_xbar_0/sim/hqc_accelerator_xbar_0.v" \

vcom -work lib_cdc_v1_0_2  -93  \
"../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work proc_sys_reset_v5_0_13  -93  \
"../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/8842/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib  -93  \
"../../../bd/hqc_accelerator/ip/hqc_accelerator_rst_ps8_0_99M_0/sim/hqc_accelerator_rst_ps8_0_99M_0.vhd" \

vlog -work axi_protocol_converter_v2_1_27  -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/abef/hdl" "+incdir+../../../bd/hqc_accelerator/ipshared/362a/src" "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/362a/src" "+incdir+D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/aeb3/hdl/axi_protocol_converter_v2_1_vl_rfs.v" \

vlog -work axi_clock_converter_v2_1_26  -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/abef/hdl" "+incdir+../../../bd/hqc_accelerator/ipshared/362a/src" "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/362a/src" "+incdir+D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/b8be/hdl/axi_clock_converter_v2_1_vl_rfs.v" \

vlog -work blk_mem_gen_v8_4_5  -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/abef/hdl" "+incdir+../../../bd/hqc_accelerator/ipshared/362a/src" "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/362a/src" "+incdir+D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/25a8/simulation/blk_mem_gen_v8_4.v" \

vlog -work axi_dwidth_converter_v2_1_27  -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/abef/hdl" "+incdir+../../../bd/hqc_accelerator/ipshared/362a/src" "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/362a/src" "+incdir+D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/4675/hdl/axi_dwidth_converter_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/abef/hdl" "+incdir+../../../bd/hqc_accelerator/ipshared/362a/src" "+incdir+../../../../project_1.gen/sources_1/bd/hqc_accelerator/ipshared/362a/src" "+incdir+D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../bd/hqc_accelerator/ip/hqc_accelerator_auto_ds_0/sim/hqc_accelerator_auto_ds_0.v" \
"../../../bd/hqc_accelerator/ip/hqc_accelerator_auto_pc_0/sim/hqc_accelerator_auto_pc_0.v" \
"../../../bd/hqc_accelerator/ip/hqc_accelerator_auto_ds_1/sim/hqc_accelerator_auto_ds_1.v" \
"../../../bd/hqc_accelerator/ip/hqc_accelerator_auto_pc_1/sim/hqc_accelerator_auto_pc_1.v" \
"../../../bd/hqc_accelerator/sim/hqc_accelerator.v" \

vlog -work xil_defaultlib \
"glbl.v"

