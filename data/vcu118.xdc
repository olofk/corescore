## Clock signal
set_property -dict { PACKAGE_PIN AY24 IOSTANDARD LVDS } [get_ports i_clk_p];
set_property -dict { PACKAGE_PIN AY23 IOSTANDARD LVDS } [get_ports i_clk_n];
create_clock -add -name sys_clk_pin -period 8 [get_nets i_clk];

## LED
set_property -dict { PACKAGE_PIN AT32 IOSTANDARD LVCMOS12 } [get_ports q];
set_property -dict { PACKAGE_PIN BB21 IOSTANDARD LVCMOS12 } [get_ports o_uart_tx]

set_property RAM_STYLE block [get_cells corescorecore/core_*/serving/ram/mem_reg]
