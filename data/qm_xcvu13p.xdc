## Clock signal
set_property -dict { PACKAGE_PIN AL20 IOSTANDARD LVCMOS18 } [get_ports i_clk_in];
create_clock -add -name sysclk -period 10.0 [get_nets i_clk]; # 100 MHz

# EMCCLK is not clock input, so allow it here
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets i_clk]

## LED
set_property -dict { PACKAGE_PIN BB32 IOSTANDARD LVCMOS12 } [get_ports q];

## UART
set_property -dict { PACKAGE_PIN AW22 IOSTANDARD LVCMOS18 } [get_ports o_uart_tx]
set_property -dict { PACKAGE_PIN AW23 IOSTANDARD LVCMOS18 } [get_ports o_uart_tx_dir]

#set_property RAM_STYLE block [get_cells corescorecore/core_*/serving/ram/mem_reg]

# Force all inferred memories within all hierarchical modules to use Block RAM
set_property RAM_STYLE block [get_cells -hierarchical -filter {IS_PRIMITIVE == 0}]
