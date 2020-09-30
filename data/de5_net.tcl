# OSC_50_B3B - 50 MHz system clock
set_instance_assignment -name IO_STANDARD "2.5 V" -to i_clk
set_location_assignment PIN_AW35 -to i_clk

# LED_BRACKET[0]
set_location_assignment PIN_AH15 -to o_led_n
set_instance_assignment -name IO_STANDARD "2.5 V" -to o_led_n
set_instance_assignment -name CURRENT_STRENGTH_NEW 12MA -to o_led_n
set_instance_assignment -name SLEW_RATE 1 -to o_led_n ; # fast

# CPU_RESET_n
set_instance_assignment -name IO_STANDARD "2.5 V" -to i_rst_n
set_location_assignment PIN_BC37 -to i_rst_n

# 7-Segement decimal points
set_instance_assignment -name IO_STANDARD "1.5 V" -to o_hex0_dp_n
set_instance_assignment -name IO_STANDARD "1.5 V" -to o_hex1_dp_n
set_location_assignment PIN_P8  -to o_hex0_dp_n
set_location_assignment PIN_E9  -to o_hex1_dp_n
set_instance_assignment -name CURRENT_STRENGTH_NEW 12MA -to o_hex0_dp_n
set_instance_assignment -name CURRENT_STRENGTH_NEW 12MA -to o_hex1_dp_n
set_instance_assignment -name SLEW_RATE 1 -to o_hex0_dp_n ; # fast
set_instance_assignment -name SLEW_RATE 1 -to o_hex1_dp_n ; # fast

# RS422
set_instance_assignment -name IO_STANDARD "2.5 V" -to o_rs422_de      ; # RS422_DE
set_instance_assignment -name IO_STANDARD "2.5 V" -to o_uart_txd      ; # RS422_DOUT
set_instance_assignment -name IO_STANDARD "2.5 V" -to o_rs422_re_n    ; # RS422_RE_n
set_instance_assignment -name IO_STANDARD "2.5 V" -to o_rs422_te      ; # RS422_TE
set_location_assignment PIN_AG14 -to o_rs422_de                       ; # RS422_DE
set_location_assignment PIN_AE17 -to o_uart_txd                       ; # RS422_DOUT
set_location_assignment PIN_AF17 -to o_rs422_re_n                     ; # RS422_RE_n
set_location_assignment PIN_AF16 -to o_rs422_te                       ; # RS422_TE
set_instance_assignment -name CURRENT_STRENGTH_NEW 12MA -to o_rs422_de
set_instance_assignment -name CURRENT_STRENGTH_NEW 12MA -to o_uart_txd
set_instance_assignment -name CURRENT_STRENGTH_NEW 12MA -to o_rs422_re_n
set_instance_assignment -name CURRENT_STRENGTH_NEW 12MA -to o_rs422_te
set_instance_assignment -name SLEW_RATE 1 -to o_rs422_de     ; # fast
set_instance_assignment -name SLEW_RATE 1 -to o_uart_txd     ; # fast
set_instance_assignment -name SLEW_RATE 1 -to o_rs422_re_n   ; # fast
set_instance_assignment -name SLEW_RATE 1 -to o_rs422_te     ; # fast

