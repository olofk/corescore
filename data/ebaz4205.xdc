## 33.333 MHz Clock signal
set_property -dict { PACKAGE_PIN N18 IOSTANDARD LVCMOS33 } [get_ports i_clk];
create_clock -add -name sys_clk_pin -period 30.00 -waveform {0 5} [get_ports i_clk];

## UART on DATA1_8 pin
set_property -dict { PACKAGE_PIN B20 IOSTANDARD LVCMOS33 } [get_ports o_uart_tx];
