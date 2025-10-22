# input clock (100 Mhz)
create_clock -name "clk25MHz" -period 40.0 [get_ports {i_clk}]
# main system clock (16 Mhz)
create_generated_clock -name "clk16MHz" -multiply_by 32 -divide_by 50 -source [get_ports {i_clk}] [get_nets {clk}]

create_clock -name {altera_reserved_tck} -period 40 {altera_reserved_tck}

set_false_path -from {clk25MHz} -to {clk16MHz}
set_false_path -from {altera_reserved_tck} -to {clk16MHz}
set_false_path -from {clk16MHz} -to {altera_reserved_tck}

