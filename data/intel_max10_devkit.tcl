set_location_assignment PIN_M9   -to clk50
set_location_assignment PIN_T20  -to led0
set_location_assignment PIN_W18  -to uart_txd
set_location_assignment PIN_Y19  -to uart_rxd

set_global_assignment -name RESERVE_ALL_UNUSED_PINS "AS INPUT TRI-STATED WITH WEAK PULL-UP"
set_global_assignment -name INTERNAL_FLASH_UPDATE_MODE "SINGLE COMP IMAGE WITH ERAM"

set_global_assignment -name IOBANK_VCCIO 2.5V -section_id 1A
set_global_assignment -name IOBANK_VCCIO 2.5V -section_id 1B
set_global_assignment -name IOBANK_VCCIO 2.5V -section_id 2
set_global_assignment -name IOBANK_VCCIO 2.5V -section_id 3
set_global_assignment -name IOBANK_VCCIO 2.5V -section_id 4
set_global_assignment -name IOBANK_VCCIO 1.5V -section_id 5
set_global_assignment -name IOBANK_VCCIO 1.5V -section_id 6
set_global_assignment -name IOBANK_VCCIO 3.3V -section_id 7
set_global_assignment -name IOBANK_VCCIO 3.3V -section_id 8

set_instance_assignment -name IO_STANDARD "1.5 V" -to led0
