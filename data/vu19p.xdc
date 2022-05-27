set_property PACKAGE_PIN BW60            [get_ports "CLK_100MHZ_N"] ;
set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "CLK_100MHZ_N"] ;
set_property PACKAGE_PIN BV60            [get_ports "CLK_100MHZ_P"] ;
set_property IOSTANDARD  DIFF_SSTL12_DCI [get_ports "CLK_100MHZ_P"] ;

create_clock -add -name sys_clk_pin -period 10 [get_nets i_clk];

set_property PACKAGE_PIN M21     [get_ports "UART_TXD"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "UART_TXD"] ;

set_property RAM_STYLE block [get_cells corescorecore/core_*/serving/ram/mem_reg]
