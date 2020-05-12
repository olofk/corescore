set_location_assignment PIN_L2   -to clk25
set_location_assignment PIN_AA19 -to led0
set_location_assignment PIN_N6   -to uart_drv_ena_
set_location_assignment PIN_P6   -to uart_drv_sd_
set_location_assignment PIN_D6   -to uart_txd
set_location_assignment PIN_F4   -to uart_rxd
set_location_assignment PIN_G6   -to uart_rts
set_location_assignment PIN_H6   -to uart_cts

set_global_assignment -name RESERVE_ALL_UNUSED_PINS "AS INPUT TRI-STATED WITH WEAK PULL-UP"

