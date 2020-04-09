## Clock signal
set_property -dict { PACKAGE_PIN H9 IOSTANDARD LVDS } [get_ports i_clk_p];
set_property -dict { PACKAGE_PIN G9 IOSTANDARD LVDS } [get_ports i_clk_n];
create_clock -add -name sys_clk_pin -period 8 [get_nets i_clk];

## LED
set_property -dict { PACKAGE_PIN AL11 IOSTANDARD LVCMOS12 } [get_ports q];
set_property -dict { PACKAGE_PIN AL17 IOSTANDARD LVCMOS12 } [get_ports o_uart_tx]

set_property RAM_STYLE block [get_cells corescorecore/core_1*/serving/ram/mem_reg]
set_property RAM_STYLE block [get_cells corescorecore/core_2*/serving/ram/mem_reg]
set_property RAM_STYLE block [get_cells corescorecore/core_3*/serving/ram/mem_reg]
set_property RAM_STYLE block [get_cells corescorecore/core_4*/serving/ram/mem_reg]
set_property RAM_STYLE block [get_cells corescorecore/core_5*/serving/ram/mem_reg]
#555
set_property RAM_STYLE block [get_cells corescorecore/core_60*/serving/ram/mem_reg]
#555+11 = 566
set_property RAM_STYLE block [get_cells corescorecore/core_61*/serving/ram/mem_reg]
#566+11 = 577
set_property RAM_STYLE block [get_cells corescorecore/core_62*/serving/ram/mem_reg]
#566+11 = 588
set_property RAM_STYLE block [get_cells corescorecore/core_63*/serving/ram/mem_reg]
#566+11 = 599
set_property RAM_STYLE block [get_cells corescorecore/core_64*/serving/ram/mem_reg]
#566+11 = 610
set_property RAM_STYLE block [get_cells corescorecore/core_65*/serving/ram/mem_reg]
#566+11 = 621
set_property RAM_STYLE block [get_cells corescorecore/core_666/serving/ram/mem_reg]
set_property RAM_STYLE block [get_cells corescorecore/core_667/serving/ram/mem_reg]
