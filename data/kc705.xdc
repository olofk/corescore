set_property -dict { PACKAGE_PIN AD12 IOSTANDARD LVDS } [get_ports i_clk_p];
set_property -dict { PACKAGE_PIN AD11 IOSTANDARD LVDS } [get_ports i_clk_n];
create_clock -add -name sys_clk_pin -period 5 [get_nets i_clk];

set_property -dict { PACKAGE_PIN F16 IOSTANDARD LVCMOS25 } [get_ports q];
set_property -dict { PACKAGE_PIN M19 IOSTANDARD LVCMOS25 } [get_ports o_uart_tx]

set_property RAM_STYLE block [get_cells corescorecore/core_*/serving/ram/mem_reg]
