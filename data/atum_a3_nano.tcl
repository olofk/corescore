set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
set_global_assignment -name MAX_CORE_JUNCTION_TEMP 100
set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 256
set_global_assignment -name PWRMGT_VOLTAGE_OUTPUT_FORMAT "LINEAR FORMAT"
set_global_assignment -name PWRMGT_LINEAR_FORMAT_N "-12"
set_global_assignment -name POWER_APPLY_THERMAL_MARGIN ADDITIONAL

set_global_assignment -name VERILOG_CU_MODE MFCU
set_global_assignment -name OPTIMIZATION_MODE "AGGRESSIVE AREA"

set_global_assignment -name ERROR_ON_WARNINGS_PARSING_SDC_ON_RTL_CONSTRAINTS ON
set_global_assignment -name ERROR_ON_WARNINGS_LOADING_SDC_ON_RTL_CONSTRAINTS ON
set_global_assignment -name RTL_SDC_FILE src/corescore_0/data/agilex50MHz.sdc

#============================================================
# Configuration scheme/pin
#============================================================
set_global_assignment -name USE_CONF_DONE SDM_IO16
set_global_assignment -name USE_INIT_DONE SDM_IO13
set_global_assignment -name STRATIXV_CONFIGURATION_SCHEME "ACTIVE SERIAL X4"
set_global_assignment -name ACTIVE_SERIAL_CLOCK AS_FREQ_100MHZ
set_global_assignment -name DEVICE_INITIALIZATION_CLOCK OSC_CLK_1_125MHZ

# Clock
set_instance_assignment -name IO_STANDARD "1.2-V" -to i_clk 
set_location_assignment PIN_K43 -to i_clk

# Push-Button Switches
set_location_assignment PIN_E2  -to i_rstn
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to i_rstn

# PLL Settings for 25MHz reference
set_parameter -name PLL_REF_CLK_FREQ "50.0 MHz"
set_parameter -name PLL_N_DIV 1
set_parameter -name PLL_M_DIV 16
set_parameter -name PLL_OUT_DIV 50
