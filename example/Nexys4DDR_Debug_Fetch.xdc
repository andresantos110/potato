

create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 2 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 16384 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list clkgen/inst/system_clk]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 32 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {processor/processor/fetch/branch_pc[0]} {processor/processor/fetch/branch_pc[1]} {processor/processor/fetch/branch_pc[2]} {processor/processor/fetch/branch_pc[3]} {processor/processor/fetch/branch_pc[4]} {processor/processor/fetch/branch_pc[5]} {processor/processor/fetch/branch_pc[6]} {processor/processor/fetch/branch_pc[7]} {processor/processor/fetch/branch_pc[8]} {processor/processor/fetch/branch_pc[9]} {processor/processor/fetch/branch_pc[10]} {processor/processor/fetch/branch_pc[11]} {processor/processor/fetch/branch_pc[12]} {processor/processor/fetch/branch_pc[13]} {processor/processor/fetch/branch_pc[14]} {processor/processor/fetch/branch_pc[15]} {processor/processor/fetch/branch_pc[16]} {processor/processor/fetch/branch_pc[17]} {processor/processor/fetch/branch_pc[18]} {processor/processor/fetch/branch_pc[19]} {processor/processor/fetch/branch_pc[20]} {processor/processor/fetch/branch_pc[21]} {processor/processor/fetch/branch_pc[22]} {processor/processor/fetch/branch_pc[23]} {processor/processor/fetch/branch_pc[24]} {processor/processor/fetch/branch_pc[25]} {processor/processor/fetch/branch_pc[26]} {processor/processor/fetch/branch_pc[27]} {processor/processor/fetch/branch_pc[28]} {processor/processor/fetch/branch_pc[29]} {processor/processor/fetch/branch_pc[30]} {processor/processor/fetch/branch_pc[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 32 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {processor/processor/fetch/imem_address[0]} {processor/processor/fetch/imem_address[1]} {processor/processor/fetch/imem_address[2]} {processor/processor/fetch/imem_address[3]} {processor/processor/fetch/imem_address[4]} {processor/processor/fetch/imem_address[5]} {processor/processor/fetch/imem_address[6]} {processor/processor/fetch/imem_address[7]} {processor/processor/fetch/imem_address[8]} {processor/processor/fetch/imem_address[9]} {processor/processor/fetch/imem_address[10]} {processor/processor/fetch/imem_address[11]} {processor/processor/fetch/imem_address[12]} {processor/processor/fetch/imem_address[13]} {processor/processor/fetch/imem_address[14]} {processor/processor/fetch/imem_address[15]} {processor/processor/fetch/imem_address[16]} {processor/processor/fetch/imem_address[17]} {processor/processor/fetch/imem_address[18]} {processor/processor/fetch/imem_address[19]} {processor/processor/fetch/imem_address[20]} {processor/processor/fetch/imem_address[21]} {processor/processor/fetch/imem_address[22]} {processor/processor/fetch/imem_address[23]} {processor/processor/fetch/imem_address[24]} {processor/processor/fetch/imem_address[25]} {processor/processor/fetch/imem_address[26]} {processor/processor/fetch/imem_address[27]} {processor/processor/fetch/imem_address[28]} {processor/processor/fetch/imem_address[29]} {processor/processor/fetch/imem_address[30]} {processor/processor/fetch/imem_address[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 32 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {processor/processor/fetch/instruction_address[0]} {processor/processor/fetch/instruction_address[1]} {processor/processor/fetch/instruction_address[2]} {processor/processor/fetch/instruction_address[3]} {processor/processor/fetch/instruction_address[4]} {processor/processor/fetch/instruction_address[5]} {processor/processor/fetch/instruction_address[6]} {processor/processor/fetch/instruction_address[7]} {processor/processor/fetch/instruction_address[8]} {processor/processor/fetch/instruction_address[9]} {processor/processor/fetch/instruction_address[10]} {processor/processor/fetch/instruction_address[11]} {processor/processor/fetch/instruction_address[12]} {processor/processor/fetch/instruction_address[13]} {processor/processor/fetch/instruction_address[14]} {processor/processor/fetch/instruction_address[15]} {processor/processor/fetch/instruction_address[16]} {processor/processor/fetch/instruction_address[17]} {processor/processor/fetch/instruction_address[18]} {processor/processor/fetch/instruction_address[19]} {processor/processor/fetch/instruction_address[20]} {processor/processor/fetch/instruction_address[21]} {processor/processor/fetch/instruction_address[22]} {processor/processor/fetch/instruction_address[23]} {processor/processor/fetch/instruction_address[24]} {processor/processor/fetch/instruction_address[25]} {processor/processor/fetch/instruction_address[26]} {processor/processor/fetch/instruction_address[27]} {processor/processor/fetch/instruction_address[28]} {processor/processor/fetch/instruction_address[29]} {processor/processor/fetch/instruction_address[30]} {processor/processor/fetch/instruction_address[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 32 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {processor/processor/fetch/instruction_data[0]} {processor/processor/fetch/instruction_data[1]} {processor/processor/fetch/instruction_data[2]} {processor/processor/fetch/instruction_data[3]} {processor/processor/fetch/instruction_data[4]} {processor/processor/fetch/instruction_data[5]} {processor/processor/fetch/instruction_data[6]} {processor/processor/fetch/instruction_data[7]} {processor/processor/fetch/instruction_data[8]} {processor/processor/fetch/instruction_data[9]} {processor/processor/fetch/instruction_data[10]} {processor/processor/fetch/instruction_data[11]} {processor/processor/fetch/instruction_data[12]} {processor/processor/fetch/instruction_data[13]} {processor/processor/fetch/instruction_data[14]} {processor/processor/fetch/instruction_data[15]} {processor/processor/fetch/instruction_data[16]} {processor/processor/fetch/instruction_data[17]} {processor/processor/fetch/instruction_data[18]} {processor/processor/fetch/instruction_data[19]} {processor/processor/fetch/instruction_data[20]} {processor/processor/fetch/instruction_data[21]} {processor/processor/fetch/instruction_data[22]} {processor/processor/fetch/instruction_data[23]} {processor/processor/fetch/instruction_data[24]} {processor/processor/fetch/instruction_data[25]} {processor/processor/fetch/instruction_data[26]} {processor/processor/fetch/instruction_data[27]} {processor/processor/fetch/instruction_data[28]} {processor/processor/fetch/instruction_data[29]} {processor/processor/fetch/instruction_data[30]} {processor/processor/fetch/instruction_data[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list processor/processor/fetch/branch_ready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 1 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list processor/processor/fetch/cancel_fetch]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 1 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list processor/processor/fetch/imem_ack]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 1 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list processor/processor/fetch/imem_req]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 1 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list processor/processor/fetch/instruction_ready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 1 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list processor/processor/fetch/wrong_predict]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets system_clk]
