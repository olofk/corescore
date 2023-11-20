# Base Clock 100 MHz
set_location_assignment PIN_CU24 -to i_clk
set_instance_assignment -name IO_STANDARD "TRUE DIFFERENTIAL SIGNALING" -to i_clk -entity corescore_intel_agilex7

# CPU_RESETn 
set_location_assignment PIN_A24 -to i_rstn
set_instance_assignment -name IO_STANDARD "1.2 V" -to i_rstn -entity corescore_intel_agilex7

# Build assignments
set_instance_assignment -name FORCE_SYNCH_CLEAR ON -to * -entity serv_state
set_instance_assignment -name FORCE_SYNCH_CLEAR ON -to * -entity serv_alu
set_global_assignment -name OPTIMIZATION_MODE "AGGRESSIVE AREA"
set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
set_global_assignment -name MAX_CORE_JUNCTION_TEMP 100

# SDM assignments
set_global_assignment -name STRATIXV_CONFIGURATION_SCHEME "ACTIVE SERIAL X4"
set_global_assignment -name USE_CONFIGURATION_DEVICE ON
set_global_assignment -name GENERATE_PR_RBF_FILE ON
set_global_assignment -name ENABLE_ED_CRC_CHECK ON
set_global_assignment -name MINIMUM_SEU_INTERVAL 0
set_global_assignment -name PWRMGT_SLAVE_DEVICE_TYPE ED8401
set_global_assignment -name PWRMGT_SLAVE_DEVICE0_ADDRESS 47
set_global_assignment -name PWRMGT_SLAVE_DEVICE1_ADDRESS 00
set_global_assignment -name PWRMGT_SLAVE_DEVICE2_ADDRESS 00
set_global_assignment -name ACTIVE_SERIAL_CLOCK AS_FREQ_100MHZ
set_global_assignment -name USE_PWRMGT_SCL SDM_IO14
set_global_assignment -name USE_PWRMGT_SDA SDM_IO11
set_global_assignment -name USE_CONF_DONE SDM_IO16

# SDC on RTL assignments
set_global_assignment -name ERROR_ON_WARNINGS_PARSING_SDC_ON_RTL_CONSTRAINTS ON
set_global_assignment -name ERROR_ON_WARNINGS_LOADING_SDC_ON_RTL_CONSTRAINTS ON
set_global_assignment -name RTL_SDC_FILE src/corescore_0/data/intel_agilex7.sdc

