-makelib xcelium_lib/xilinx_vip -sv \
  "D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
  "D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
  "D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
  "D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
  "D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
  "D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
  "D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
  "D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
  "D:/Apps/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/rst_vip_if.sv" \
-endlib
-makelib xcelium_lib/axi_infrastructure_v1_1_0 \
  "../../../../wrapper.gen/sources_1/bd/SoC/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_vip_v1_1_13 -sv \
  "../../../../wrapper.gen/sources_1/bd/SoC/ipshared/ffc2/hdl/axi_vip_v1_1_vl_rfs.sv" \
-endlib
-makelib xcelium_lib/zynq_ultra_ps_e_vip_v1_0_13 -sv \
  "../../../../wrapper.gen/sources_1/bd/SoC/ipshared/abef/hdl/zynq_ultra_ps_e_vip_v1_0_vl_rfs.sv" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/SoC/ip/SoC_zynq_ultra_ps_e_0_0/sim/SoC_zynq_ultra_ps_e_0_0_vip_wrapper.v" \
  "../../../bd/SoC/ipshared/1e43/src/HQC_wrapper.v" \
  "../../../bd/SoC/ipshared/1e43/src/add_fft.v" \
  "../../../bd/SoC/ipshared/1e43/src/axi_wrapper_slave_lite_v1_0_S00_AXI.v" \
  "../../../bd/SoC/ipshared/1e43/src/barrett_red_gen.v" \
  "../../../bd/SoC/ipshared/1e43/src/cdw_xor_tmp.v" \
  "../../../bd/SoC/ipshared/1e43/src/concat_code.v" \
  "../../../bd/SoC/ipshared/1e43/src/control_path.v" \
  "../../../bd/SoC/ipshared/1e43/src/data_path.v" \
  "../../../bd/SoC/ipshared/1e43/src/decap.v" \
  "../../../bd/SoC/ipshared/1e43/src/decrypt.v" \
  "../../../bd/SoC/ipshared/1e43/src/encap.v" \
  "../../../bd/SoC/ipshared/1e43/src/encrypt.v" \
  "../../../bd/SoC/ipshared/1e43/src/encrypt_parallel.v" \
  "../../../bd/SoC/ipshared/1e43/src/fft_leaves_butterfly.v" \
  "../../../bd/SoC/ipshared/1e43/src/fft_part1.v" \
  "../../../bd/SoC/ipshared/1e43/src/fft_part2.v" \
  "../../../bd/SoC/ipshared/1e43/src/fft_retrieve_error_poly.v" \
  "../../../bd/SoC/ipshared/1e43/src/fixed_weight.v" \
  "../../../bd/SoC/ipshared/1e43/src/fixed_weight_ct.v" \
  "../../../bd/SoC/ipshared/1e43/src/fixed_weight_cww.v" \
  "../../../bd/SoC/ipshared/1e43/src/gf_mul.v" \
  "../../../bd/SoC/ipshared/1e43/src/gfmul.v" \
  "../../../bd/SoC/ipshared/1e43/src/hqc_barrett_red.v" \
  "../../../bd/SoC/ipshared/1e43/src/hqc_decod_top.v" \
  "../../../bd/SoC/ipshared/1e43/src/hqc_kem_joint_design.v" \
  "../../../bd/SoC/ipshared/1e43/src/hqc_rmdecod_ctrl.v" \
  "../../../bd/SoC/ipshared/1e43/src/hqc_rmdecod_expnsum.v" \
  "../../../bd/SoC/ipshared/1e43/src/hqc_rmdecod_findpeaks.v" \
  "../../../bd/SoC/ipshared/1e43/src/hqc_rmdecod_hadamard.v" \
  "../../../bd/SoC/ipshared/1e43/src/hqc_rmdecod_top.v" \
  "../../../bd/SoC/ipshared/1e43/src/hqc_rsdecod_elp.v" \
  "../../../bd/SoC/ipshared/1e43/src/hqc_rsdecod_err_val.v" \
  "../../../bd/SoC/ipshared/1e43/src/hqc_rsdecod_roots.v" \
  "../../../bd/SoC/ipshared/1e43/src/hqc_rsdecod_syndromes.v" \
  "../../../bd/SoC/ipshared/1e43/src/hqc_rsdecod_top.v" \
  "../../../bd/SoC/ipshared/1e43/src/hqc_rsdecod_zpoly.v" \
  "../../../bd/SoC/ipshared/1e43/src/karatsuba_small.v" \
  "../../../bd/SoC/ipshared/1e43/src/keccak_top.v" \
  "../../../bd/SoC/ipshared/1e43/src/keygen.v" \
  "../../../bd/SoC/ipshared/1e43/src/loc_based_adder.v" \
  "../../../bd/SoC/ipshared/1e43/src/mem_dual.v" \
  "../../../bd/SoC/ipshared/1e43/src/mem_single.v" \
  "../../../bd/SoC/ipshared/1e43/src/mod34.v" \
  "../../../bd/SoC/ipshared/1e43/src/onegen.v" \
  "../../../bd/SoC/ipshared/1e43/src/onegen_ct.v" \
  "../../../bd/SoC/ipshared/1e43/src/poly_mult.v" \
  "../../../bd/SoC/ipshared/1e43/src/rc.v" \
  "../../../bd/SoC/ipshared/1e43/src/reed_muller_encode.v" \
  "../../../bd/SoC/ipshared/1e43/src/reed_solomon_encode.v" \
  "../../../bd/SoC/ipshared/1e43/src/rm_encoder.v" \
  "../../../bd/SoC/ipshared/1e43/src/state_ram.v" \
  "../../../bd/SoC/ipshared/1e43/src/stateram_inference.v" \
  "../../../bd/SoC/ipshared/1e43/src/syncfifo.v" \
  "../../../bd/SoC/ipshared/1e43/src/transform.v" \
  "../../../bd/SoC/ipshared/1e43/src/v_minus_uy.v" \
  "../../../bd/SoC/ipshared/1e43/src/vect_set_random.v" \
  "../../../bd/SoC/ipshared/1e43/src/xor_based_adder.v" \
  "../../../bd/SoC/ipshared/1e43/src/axi_wrapper.v" \
  "../../../bd/SoC/ip/SoC_axi_wrapper_0_0/sim/SoC_axi_wrapper_0_0.v" \
-endlib
-makelib xcelium_lib/generic_baseblocks_v2_1_0 \
  "../../../../wrapper.gen/sources_1/bd/SoC/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_register_slice_v2_1_27 \
  "../../../../wrapper.gen/sources_1/bd/SoC/ipshared/f0b4/hdl/axi_register_slice_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_7 \
  "../../../../wrapper.gen/sources_1/bd/SoC/ipshared/83df/simulation/fifo_generator_vlog_beh.v" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_7 \
  "../../../../wrapper.gen/sources_1/bd/SoC/ipshared/83df/hdl/fifo_generator_v13_2_rfs.vhd" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_7 \
  "../../../../wrapper.gen/sources_1/bd/SoC/ipshared/83df/hdl/fifo_generator_v13_2_rfs.v" \
-endlib
-makelib xcelium_lib/axi_data_fifo_v2_1_26 \
  "../../../../wrapper.gen/sources_1/bd/SoC/ipshared/3111/hdl/axi_data_fifo_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_crossbar_v2_1_28 \
  "../../../../wrapper.gen/sources_1/bd/SoC/ipshared/c40e/hdl/axi_crossbar_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/SoC/ip/SoC_xbar_0/sim/SoC_xbar_0.v" \
-endlib
-makelib xcelium_lib/axi_protocol_converter_v2_1_27 \
  "../../../../wrapper.gen/sources_1/bd/SoC/ipshared/aeb3/hdl/axi_protocol_converter_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_clock_converter_v2_1_26 \
  "../../../../wrapper.gen/sources_1/bd/SoC/ipshared/b8be/hdl/axi_clock_converter_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/blk_mem_gen_v8_4_5 \
  "../../../../wrapper.gen/sources_1/bd/SoC/ipshared/25a8/simulation/blk_mem_gen_v8_4.v" \
-endlib
-makelib xcelium_lib/axi_dwidth_converter_v2_1_27 \
  "../../../../wrapper.gen/sources_1/bd/SoC/ipshared/4675/hdl/axi_dwidth_converter_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/SoC/ip/SoC_auto_ds_0/sim/SoC_auto_ds_0.v" \
  "../../../bd/SoC/ip/SoC_auto_pc_0/sim/SoC_auto_pc_0.v" \
  "../../../bd/SoC/ip/SoC_auto_ds_1/sim/SoC_auto_ds_1.v" \
  "../../../bd/SoC/ip/SoC_auto_pc_1/sim/SoC_auto_pc_1.v" \
-endlib
-makelib xcelium_lib/lib_cdc_v1_0_2 \
  "../../../../wrapper.gen/sources_1/bd/SoC/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \
-endlib
-makelib xcelium_lib/proc_sys_reset_v5_0_13 \
  "../../../../wrapper.gen/sources_1/bd/SoC/ipshared/8842/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/SoC/ip/SoC_rst_ps8_0_99M_0/sim/SoC_rst_ps8_0_99M_0.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/SoC/sim/SoC.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

