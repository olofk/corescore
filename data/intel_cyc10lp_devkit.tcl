set_location_assignment PIN_E1 -to clk50

# PMOD_D0 pin
set_location_assignment PIN_D16 -to uart_txd

set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to clk50
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to uart_txd

set_global_assignment -name RESERVE_ALL_UNUSED_PINS "AS INPUT TRI-STATED WITH WEAK PULL-UP"
set_global_assignment -name INTERNAL_FLASH_UPDATE_MODE "SINGLE COMP IMAGE WITH ERAM"

set_global_assignment -name IOBANK_VCCIO 3.3V -section_id 1
set_global_assignment -name IOBANK_VCCIO 3.3V -section_id 2
set_global_assignment -name IOBANK_VCCIO 3.3V -section_id 3
set_global_assignment -name IOBANK_VCCIO 1.8V -section_id 4
set_global_assignment -name IOBANK_VCCIO 3.3V -section_id 5
set_global_assignment -name IOBANK_VCCIO 3.3V -section_id 6
set_global_assignment -name IOBANK_VCCIO 3.3V -section_id 7
set_global_assignment -name IOBANK_VCCIO 3.3V -section_id 8

