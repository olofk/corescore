set_property PACKAGE_PIN E23  [get_ports "SYSCLK_N"] ;
set_property IOSTANDARD  LVDS [get_ports "SYSCLK_N"] ;
set_property PACKAGE_PIN F23  [get_ports "SYSCLK_P"] ;
set_property IOSTANDARD  LVDS [get_ports "SYSCLK_P"] ;

create_clock -add -name sys_clk_pin -period 10 [get_nets i_clk];

set_property PACKAGE_PIN AB18     [get_ports "led0_g"] ;
set_property IOSTANDARD  LVCMOS33 [get_ports "led0_g"] ;

set_property PACKAGE_PIN AB6     [get_ports "scu35_uartb_txd"] ;
set_property IOSTANDARD  LVCMOS33 [get_ports "scu35_uartb_txd"] ;

set_property RAM_STYLE block [get_cells corescorecore/core_*/serving/ram/mem_reg]
