vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xilinx_vip
vlib modelsim_lib/msim/axi_infrastructure_v1_1_0
vlib modelsim_lib/msim/axi_vip_v1_1_13
vlib modelsim_lib/msim/zynq_ultra_ps_e_vip_v1_0_13
vlib modelsim_lib/msim/xil_defaultlib
vlib modelsim_lib/msim/generic_baseblocks_v2_1_0
vlib modelsim_lib/msim/axi_register_slice_v2_1_27
vlib modelsim_lib/msim/fifo_generator_v13_2_7
vlib modelsim_lib/msim/axi_data_fifo_v2_1_26
vlib modelsim_lib/msim/axi_crossbar_v2_1_28
vlib modelsim_lib/msim/axi_protocol_converter_v2_1_27
vlib modelsim_lib/msim/axi_clock_converter_v2_1_26
vlib modelsim_lib/msim/blk_mem_gen_v8_4_5
vlib modelsim_lib/msim/axi_dwidth_converter_v2_1_27
vlib modelsim_lib/msim/lib_cdc_v1_0_2
vlib modelsim_lib/msim/proc_sys_reset_v5_0_13

vmap xilinx_vip modelsim_lib/msim/xilinx_vip
vmap axi_infrastructure_v1_1_0 modelsim_lib/msim/axi_infrastructure_v1_1_0
vmap axi_vip_v1_1_13 modelsim_lib/msim/axi_vip_v1_1_13
vmap zynq_ultra_ps_e_vip_v1_0_13 modelsim_lib/msim/zynq_ultra_ps_e_vip_v1_0_13
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib
vmap generic_baseblocks_v2_1_0 modelsim_lib/msim/generic_baseblocks_v2_1_0
vmap axi_register_slice_v2_1_27 modelsim_lib/msim/axi_register_slice_v2_1_27
vmap fifo_generator_v13_2_7 modelsim_lib/msim/fifo_generator_v13_2_7
vmap axi_data_fifo_v2_1_26 modelsim_lib/msim/axi_data_fifo_v2_1_26
vmap axi_crossbar_v2_1_28 modelsim_lib/msim/axi_crossbar_v2_1_28
vmap axi_protocol_converter_v2_1_27 modelsim_lib/msim/axi_protocol_converter_v2_1_27
vmap axi_clock_converter_v2_1_26 modelsim_lib/msim/axi_clock_converter_v2_1_26
vmap blk_mem_gen_v8_4_5 modelsim_lib/msim/blk_mem_gen_v8_4_5
vmap axi_dwidth_converter_v2_1_27 modelsim_lib/msim/axi_dwidth_converter_v2_1_27
vmap lib_cdc_v1_0_2 modelsim_lib/msim/lib_cdc_v1_0_2
vmap proc_sys_reset_v5_0_13 modelsim_lib/msim/proc_sys_reset_v5_0_13

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

vlog -work axi_infrastructure_v1_1_0  -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/abef/hdl" "+incdir+../../../bd/SoC/ipshared/6cf9/src" "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/6cf9/src" "+incdir+D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/SoC/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_vip_v1_1_13  -incr -mfcu  -sv -L axi_vip_v1_1_13 -L zynq_ultra_ps_e_vip_v1_0_13 -L xilinx_vip "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/abef/hdl" "+incdir+../../../bd/SoC/ipshared/6cf9/src" "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/6cf9/src" "+incdir+D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/SoC/ipshared/ffc2/hdl/axi_vip_v1_1_vl_rfs.sv" \

vlog -work zynq_ultra_ps_e_vip_v1_0_13  -incr -mfcu  -sv -L axi_vip_v1_1_13 -L zynq_ultra_ps_e_vip_v1_0_13 -L xilinx_vip "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/abef/hdl" "+incdir+../../../bd/SoC/ipshared/6cf9/src" "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/6cf9/src" "+incdir+D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/SoC/ipshared/abef/hdl/zynq_ultra_ps_e_vip_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/abef/hdl" "+incdir+../../../bd/SoC/ipshared/6cf9/src" "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/6cf9/src" "+incdir+D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../bd/SoC/ip/SoC_zynq_ultra_ps_e_0_0/sim/SoC_zynq_ultra_ps_e_0_0_vip_wrapper.v" \
"../../../bd/SoC/ipshared/6cf9/src/HQC_wrapper.v" \
"../../../bd/SoC/ipshared/6cf9/src/add_fft.v" \
"../../../bd/SoC/ipshared/6cf9/src/axi_wrapper_slave_lite_v1_0_S00_AXI.v" \
"../../../bd/SoC/ipshared/6cf9/src/barrett_red_gen.v" \
"../../../bd/SoC/ipshared/6cf9/src/cdw_xor_tmp.v" \
"../../../bd/SoC/ipshared/6cf9/src/concat_code.v" \
"../../../bd/SoC/ipshared/6cf9/src/control_path.v" \
"../../../bd/SoC/ipshared/6cf9/src/data_path.v" \
"../../../bd/SoC/ipshared/6cf9/src/decap.v" \
"../../../bd/SoC/ipshared/6cf9/src/decrypt.v" \
"../../../bd/SoC/ipshared/6cf9/src/encap.v" \
"../../../bd/SoC/ipshared/6cf9/src/encrypt.v" \
"../../../bd/SoC/ipshared/6cf9/src/encrypt_parallel.v" \
"../../../bd/SoC/ipshared/6cf9/src/fft_leaves_butterfly.v" \
"../../../bd/SoC/ipshared/6cf9/src/fft_part1.v" \
"../../../bd/SoC/ipshared/6cf9/src/fft_part2.v" \
"../../../bd/SoC/ipshared/6cf9/src/fft_retrieve_error_poly.v" \
"../../../bd/SoC/ipshared/6cf9/src/fixed_weight.v" \
"../../../bd/SoC/ipshared/6cf9/src/fixed_weight_ct.v" \
"../../../bd/SoC/ipshared/6cf9/src/fixed_weight_cww.v" \
"../../../bd/SoC/ipshared/6cf9/src/gf_mul.v" \
"../../../bd/SoC/ipshared/6cf9/src/gfmul_00.v" \
"../../../bd/SoC/ipshared/6cf9/src/gfmul_01.v" \
"../../../bd/SoC/ipshared/6cf9/src/hqc_barrett_red.v" \
"../../../bd/SoC/ipshared/6cf9/src/hqc_decod_top.v" \
"../../../bd/SoC/ipshared/6cf9/src/hqc_kem_joint_design.v" \
"../../../bd/SoC/ipshared/6cf9/src/hqc_rmdecod_ctrl.v" \
"../../../bd/SoC/ipshared/6cf9/src/hqc_rmdecod_expnsum.v" \
"../../../bd/SoC/ipshared/6cf9/src/hqc_rmdecod_findpeaks.v" \
"../../../bd/SoC/ipshared/6cf9/src/hqc_rmdecod_hadamard.v" \
"../../../bd/SoC/ipshared/6cf9/src/hqc_rmdecod_top.v" \
"../../../bd/SoC/ipshared/6cf9/src/hqc_rsdecod_elp.v" \
"../../../bd/SoC/ipshared/6cf9/src/hqc_rsdecod_err_val.v" \
"../../../bd/SoC/ipshared/6cf9/src/hqc_rsdecod_roots.v" \
"../../../bd/SoC/ipshared/6cf9/src/hqc_rsdecod_syndromes.v" \
"../../../bd/SoC/ipshared/6cf9/src/hqc_rsdecod_top.v" \
"../../../bd/SoC/ipshared/6cf9/src/hqc_rsdecod_zploly.v" \
"../../../bd/SoC/ipshared/6cf9/src/karatsuba_small.v" \
"../../../bd/SoC/ipshared/6cf9/src/keccak_top.v" \
"../../../bd/SoC/ipshared/6cf9/src/keygen.v" \
"../../../bd/SoC/ipshared/6cf9/src/loc_based_adder.v" \
"../../../bd/SoC/ipshared/6cf9/src/mem_dual.v" \
"../../../bd/SoC/ipshared/6cf9/src/mem_single.v" \
"../../../bd/SoC/ipshared/6cf9/src/mod34.v" \
"../../../bd/SoC/ipshared/6cf9/src/onegen.v" \
"../../../bd/SoC/ipshared/6cf9/src/onegen_ct.v" \
"../../../bd/SoC/ipshared/6cf9/src/poly_mult.v" \
"../../../bd/SoC/ipshared/6cf9/src/rc.v" \
"../../../bd/SoC/ipshared/6cf9/src/reed_muller_encode.v" \
"../../../bd/SoC/ipshared/6cf9/src/reed_solomon_encode.v" \
"../../../bd/SoC/ipshared/6cf9/src/rm_encoder.v" \
"../../../bd/SoC/ipshared/6cf9/src/state_ram.v" \
"../../../bd/SoC/ipshared/6cf9/src/stateram_inference.v" \
"../../../bd/SoC/ipshared/6cf9/src/syncfifo.v" \
"../../../bd/SoC/ipshared/6cf9/src/transform.v" \
"../../../bd/SoC/ipshared/6cf9/src/v_minus_uy.v" \
"../../../bd/SoC/ipshared/6cf9/src/vect_set_random.v" \
"../../../bd/SoC/ipshared/6cf9/src/xor_based_adder.v" \
"../../../bd/SoC/ipshared/6cf9/src/axi_wrapper.v" \
"../../../bd/SoC/ip/SoC_axi_wrapper_0_0/sim/SoC_axi_wrapper_0_0.v" \

vlog -work generic_baseblocks_v2_1_0  -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/abef/hdl" "+incdir+../../../bd/SoC/ipshared/6cf9/src" "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/6cf9/src" "+incdir+D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/SoC/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \

vlog -work axi_register_slice_v2_1_27  -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/abef/hdl" "+incdir+../../../bd/SoC/ipshared/6cf9/src" "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/6cf9/src" "+incdir+D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/SoC/ipshared/f0b4/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work fifo_generator_v13_2_7  -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/abef/hdl" "+incdir+../../../bd/SoC/ipshared/6cf9/src" "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/6cf9/src" "+incdir+D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/SoC/ipshared/83df/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_7  -93  \
"../../../../project_1.gen/sources_1/bd/SoC/ipshared/83df/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_7  -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/abef/hdl" "+incdir+../../../bd/SoC/ipshared/6cf9/src" "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/6cf9/src" "+incdir+D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/SoC/ipshared/83df/hdl/fifo_generator_v13_2_rfs.v" \

vlog -work axi_data_fifo_v2_1_26  -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/abef/hdl" "+incdir+../../../bd/SoC/ipshared/6cf9/src" "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/6cf9/src" "+incdir+D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/SoC/ipshared/3111/hdl/axi_data_fifo_v2_1_vl_rfs.v" \

vlog -work axi_crossbar_v2_1_28  -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/abef/hdl" "+incdir+../../../bd/SoC/ipshared/6cf9/src" "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/6cf9/src" "+incdir+D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/SoC/ipshared/c40e/hdl/axi_crossbar_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/abef/hdl" "+incdir+../../../bd/SoC/ipshared/6cf9/src" "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/6cf9/src" "+incdir+D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../bd/SoC/ip/SoC_xbar_0/sim/SoC_xbar_0.v" \

vlog -work axi_protocol_converter_v2_1_27  -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/abef/hdl" "+incdir+../../../bd/SoC/ipshared/6cf9/src" "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/6cf9/src" "+incdir+D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/SoC/ipshared/aeb3/hdl/axi_protocol_converter_v2_1_vl_rfs.v" \

vlog -work axi_clock_converter_v2_1_26  -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/abef/hdl" "+incdir+../../../bd/SoC/ipshared/6cf9/src" "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/6cf9/src" "+incdir+D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/SoC/ipshared/b8be/hdl/axi_clock_converter_v2_1_vl_rfs.v" \

vlog -work blk_mem_gen_v8_4_5  -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/abef/hdl" "+incdir+../../../bd/SoC/ipshared/6cf9/src" "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/6cf9/src" "+incdir+D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/SoC/ipshared/25a8/simulation/blk_mem_gen_v8_4.v" \

vlog -work axi_dwidth_converter_v2_1_27  -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/abef/hdl" "+incdir+../../../bd/SoC/ipshared/6cf9/src" "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/6cf9/src" "+incdir+D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../project_1.gen/sources_1/bd/SoC/ipshared/4675/hdl/axi_dwidth_converter_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/abef/hdl" "+incdir+../../../bd/SoC/ipshared/6cf9/src" "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/6cf9/src" "+incdir+D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../bd/SoC/ip/SoC_auto_ds_0/sim/SoC_auto_ds_0.v" \
"../../../bd/SoC/ip/SoC_auto_pc_0/sim/SoC_auto_pc_0.v" \
"../../../bd/SoC/ip/SoC_auto_ds_1/sim/SoC_auto_ds_1.v" \
"../../../bd/SoC/ip/SoC_auto_pc_1/sim/SoC_auto_pc_1.v" \

vcom -work lib_cdc_v1_0_2  -93  \
"../../../../project_1.gen/sources_1/bd/SoC/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work proc_sys_reset_v5_0_13  -93  \
"../../../../project_1.gen/sources_1/bd/SoC/ipshared/8842/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib  -93  \
"../../../bd/SoC/ip/SoC_rst_ps8_0_99M_0/sim/SoC_rst_ps8_0_99M_0.vhd" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/ec67/hdl" "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/abef/hdl" "+incdir+../../../bd/SoC/ipshared/6cf9/src" "+incdir+../../../../project_1.gen/sources_1/bd/SoC/ipshared/6cf9/src" "+incdir+D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../bd/SoC/sim/SoC.v" \

vlog -work xil_defaultlib \
"glbl.v"

