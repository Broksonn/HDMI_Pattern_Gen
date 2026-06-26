# --- DODANE: PRZEŁĄCZNIKI ---
set_property PACKAGE_PIN AB1 [get_ports {SW[0]}]
set_property IOSTANDARD LVCMOS12 [get_ports {SW[0]}]

set_property PACKAGE_PIN AF1 [get_ports {SW[1]}]
set_property IOSTANDARD LVCMOS12 [get_ports {SW[1]}]
# ------------------------------------------------------------

# ZEGAR 100MHz z płyty
set_property PACKAGE_PIN D7 [get_ports CLK_100MHz_P]
set_property PACKAGE_PIN D6 [get_ports CLK_100MHz_N]
set_property IOSTANDARD LVDS [get_ports CLK_100MHz_*]
create_clock -period 10.000 -name Clk_100MHz [get_ports CLK_100MHz_P]

# ZŁĄCZE HDMI z płyty rozszerzeń
set_property PACKAGE_PIN AF11 [get_ports HDMI_D2_P]
set_property PACKAGE_PIN AG11 [get_ports HDMI_D2_N]
set_property PACKAGE_PIN AH11 [get_ports HDMI_D1_P]
set_property PACKAGE_PIN AH12 [get_ports HDMI_D1_N]
set_property PACKAGE_PIN AF10 [get_ports HDMI_D0_P]
set_property PACKAGE_PIN AE10 [get_ports HDMI_D0_N]
set_property PACKAGE_PIN AD12 [get_ports HDMI_CK_P]
set_property PACKAGE_PIN AC12 [get_ports HDMI_CK_N]
set_property IOSTANDARD LVCMOS33 [get_ports HDMI_*]

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]

create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list CLK_GEN/inst/clk_out1]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 10 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {pos_y[0]} {pos_y[1]} {pos_y[2]} {pos_y[3]} {pos_y[4]} {pos_y[5]} {pos_y[6]} {pos_y[7]} {pos_y[8]} {pos_y[9]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 10 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {pos_x[0]} {pos_x[1]} {pos_x[2]} {pos_x[3]} {pos_x[4]} {pos_x[5]} {pos_x[6]} {pos_x[7]} {pos_x[8]} {pos_x[9]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 1 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list sync_h]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 1 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list sync_v]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list vde]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_25M]