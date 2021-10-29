set_property -dict {PACKAGE_PIN AC9  IOSTANDARD DIFF_SSTL15 } [get_ports i_clk_p];
set_property -dict {PACKAGE_PIN AD9  IOSTANDARD DIFF_SSTL15 } [get_ports i_clk_n];

set_property -dict {PACKAGE_PIN K15  IOSTANDARD LVCMOS25 } [get_ports o_uart_tx]

create_clock -add -name sys_clk_pin -period 8 [get_ports i_clk_p];
