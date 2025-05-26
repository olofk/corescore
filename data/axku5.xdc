set_property PACKAGE_PIN K22 [get_ports i_clk_p]
set_property PACKAGE_PIN K23 [get_ports i_clk_n]
set_property IOSTANDARD LVDS [get_ports {i_clk_p i_clk_n}]
create_clock -name sys_clk_pin -period 5.000 [get_ports i_clk_p]

set_property -dict { PACKAGE_PIN  J12 IOSTANDARD LVCMOS33 } [get_ports { q }];
set_property -dict { PACKAGE_PIN AD15 IOSTANDARD LVCMOS33 } [get_ports { o_uart_tx }]

set_property RAM_STYLE block [get_cells corescorecore/core_*/serving/ram/mem_reg]
