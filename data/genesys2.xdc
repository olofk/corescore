set_property -dict {PACKAGE_PIN AD11  IOSTANDARD LVDS } [get_ports i_clk_n];
set_property -dict {PACKAGE_PIN AD12  IOSTANDARD LVDS } [get_ports i_clk_p];
create_clock -add -name sys_clk_pin -period 5.00 [get_nets i_clk];

set_property -dict {PACKAGE_PIN Y23  IOSTANDARD LVCMOS33 } [get_ports o_uart_tx];
