set_property PACKAGE_PIN BK3         [get_ports "QDR4_CLK_100MHZ_N"] ;
set_property IOSTANDARD  DIFF_SSTL12 [get_ports "QDR4_CLK_100MHZ_N"] ;
set_property PACKAGE_PIN BJ4         [get_ports "QDR4_CLK_100MHZ_P"] ;
set_property IOSTANDARD  DIFF_SSTL12 [get_ports "QDR4_CLK_100MHZ_P"] ;

create_clock -add -name sys_clk_pin -period 10 [get_nets i_clk];

set_property PACKAGE_PIN BH24     [get_ports "GPIO_LED_0_LS"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "GPIO_LED_0_LS"] ;

set_property PACKAGE_PIN BJ28     [get_ports "UART1_TXD"] ;
set_property IOSTANDARD  LVCMOS18 [get_ports "UART1_TXD"] ;

set_property RAM_STYLE block [get_cells corescorecore/core_*/serving/ram/mem_reg]
