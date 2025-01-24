# Base Clock CLK_FPGA_100M
#100Mhz clk
set_location_assignment PIN_AB57 -to i_clk
set_location_assignment PIN_AC56 -to "i_clk(n)"
set_instance_assignment -name IO_STANDARD "1.2V TRUE DIFFERENTIAL SIGNALING" -to i_clk
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to i_clk

# CPU_RESETn 
set_location_assignment PIN_E38 -to i_rstn

# Build assignments
set_instance_assignment -name FORCE_SYNCH_CLEAR ON -to * -entity serv_state
set_instance_assignment -name FORCE_SYNCH_CLEAR ON -to * -entity serv_alu
set_global_assignment -name OPTIMIZATION_MODE "AGGRESSIVE AREA"
set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
set_global_assignment -name MAX_CORE_JUNCTION_TEMP 100

# SDM assignments
# Assembler Assignments
# =====================
set_global_assignment -name STRATIXV_CONFIGURATION_SCHEME "AVST X8"
set_global_assignment -name PWRMGT_DEVICE_ADDRESS_IN_PMBUS_SLAVE_MODE 3C
set_global_assignment -name PWRMGT_VOLTAGE_OUTPUT_FORMAT "LINEAR FORMAT"
set_global_assignment -name PWRMGT_LINEAR_FORMAT_N "-12"

# Setup VID operation:
set_global_assignment -name VID_OPERATION_MODE "PMBUS SLAVE"

set_global_assignment -name USE_PWRMGT_SCL SDM_IO0
set_global_assignment -name USE_PWRMGT_SDA SDM_IO16
set_global_assignment -name USE_PWRMGT_ALERT SDM_IO9
set_global_assignment -name USE_INIT_DONE SDM_IO5
set_global_assignment -name USE_CONF_DONE SDM_IO12
set_global_assignment -name USE_HPS_COLD_RESET SDM_IO7
set_global_assignment -name DEVICE_INITIALIZATION_CLOCK OSC_CLK_1_125MHZ

set_global_assignment -name FLOW_ENABLE_HYPER_RETIMER_FAST_FORWARD ON
set_global_assignment -name ALLOW_RAM_RETIMING ON


# SDC on RTL assignments
set_global_assignment -name ERROR_ON_WARNINGS_PARSING_SDC_ON_RTL_CONSTRAINTS ON
set_global_assignment -name ERROR_ON_WARNINGS_LOADING_SDC_ON_RTL_CONSTRAINTS ON
set_global_assignment -name RTL_SDC_FILE src/corescore_0/data/intel_agilex7.sdc

