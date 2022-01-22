# Clock signal
set_property -dict { PACKAGE_PIN L17    IOSTANDARD LVCMOS33 } [get_ports  i_clk ]; 
create_clock -add -name sys_clk_pin -period 83.33 -waveform {0 41.66} [get_ports  i_clk ];

# USB-UART Interface
set_property -dict { PACKAGE_PIN J17   IOSTANDARD LVCMOS33 } [get_ports o_uart_tx ];

# LEDs
set_property -dict { PACKAGE_PIN A17    IOSTANDARD LVCMOS33 } [get_ports  q ];
