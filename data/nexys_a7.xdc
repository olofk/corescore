set_property -dict {PACKAGE_PIN E3  IOSTANDARD LVCMOS33 } [get_ports i_clk];
set_property -dict {PACKAGE_PIN D4  IOSTANDARD LVCMOS33 } [get_ports o_uart_tx]

create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports i_clk];
