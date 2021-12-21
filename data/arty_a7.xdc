# Clock signal
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports  i_clk ]; 
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports  i_clk ];

# USB-UART Interface
set_property -dict { PACKAGE_PIN D10   IOSTANDARD LVCMOS33 } [get_ports o_uart_tx ];

# LEDs
set_property -dict { PACKAGE_PIN H5    IOSTANDARD LVCMOS33 } [get_ports  q ];