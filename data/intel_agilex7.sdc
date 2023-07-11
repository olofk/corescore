# input clock (100 Mhz)
create_clock -name "clk100MHz" -period 10.0 [get_ports {i_clk}]
# main system clock (16 Mhz)
create_generated_clock -name "clk16MHz" -multiply_by 8 -divide_by 50 -source [get_ports {i_clk}] [get_nets {clk}]
