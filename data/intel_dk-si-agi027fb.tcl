# Base Clock 100 MHz
set_location_assignment PIN_CM29 -to i_clk
set_instance_assignment -name IO_STANDARD "TRUE DIFFERENTIAL SIGNALING" -to i_clk

# CPU_RESETn 
set_location_assignment PIN_AB53 -to i_rstn

# Build assignments
set_instance_assignment -name FORCE_SYNCH_CLEAR ON -to * -entity serv_state
set_instance_assignment -name FORCE_SYNCH_CLEAR ON -to * -entity serv_alu
set_global_assignment -name OPTIMIZATION_MODE "AGGRESSIVE AREA"
set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
set_global_assignment -name MAX_CORE_JUNCTION_TEMP 100

# SDM assignments
set_global_assignment -name USE_PWRMGT_SCL SDM_IO0
set_global_assignment -name USE_PWRMGT_SDA SDM_IO12
set_global_assignment -name USE_CONF_DONE SDM_IO16
set_global_assignment -name PWRMGT_SLAVE_DEVICE_TYPE ED8401
set_global_assignment -name PWRMGT_SLAVE_DEVICE0_ADDRESS 62
set_global_assignment -name PWRMGT_VOLTAGE_OUTPUT_FORMAT "LINEAR FORMAT"
set_global_assignment -name PWRMGT_LINEAR_FORMAT_N "-13"
set_global_assignment -name ACTIVE_SERIAL_CLOCK AS_FREQ_115MHZ_IOSC
set_global_assignment -name STRATIXV_CONFIGURATION_SCHEME "ACTIVE SERIAL X4"

set_global_assignment -name ERROR_ON_WARNINGS_PARSING_SDC_ON_RTL_CONSTRAINTS ON
set_global_assignment -name ERROR_ON_WARNINGS_LOADING_SDC_ON_RTL_CONSTRAINTS ON
set_global_assignment -name RTL_SDC_FILE src/corescore_0/data/intel_agilex7.sdc

