## Clock signal
set_property -dict { PACKAGE_PIN AP26 IOSTANDARD LVCMOS15 } [get_ports i_clk_in];
create_clock -add -name sys_clk_pin -period 7.5001875 [get_nets i_clk]; # 133.33 MHz

## Clock enable
set_property -dict { PACKAGE_PIN AM26 IOSTANDARD LVCMOS15 } [get_ports o_clk_en];

## LED
set_property -dict { PACKAGE_PIN A36 IOSTANDARD LVCMOS18 } [get_ports q];

## UART
set_property -dict { PACKAGE_PIN A35 IOSTANDARD LVCMOS18 } [get_ports o_uart_tx]

set_property RAM_STYLE block [get_cells corescorecore/core_*/serving/ram/mem_reg]
