

set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
set_global_assignment -name MAX_CORE_JUNCTION_TEMP 100
set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 256
set_global_assignment -name PWRMGT_VOLTAGE_OUTPUT_FORMAT "LINEAR FORMAT"
set_global_assignment -name PWRMGT_LINEAR_FORMAT_N "-12"
set_global_assignment -name POWER_APPLY_THERMAL_MARGIN ADDITIONAL

set_global_assignment -name VERILOG_CU_MODE MFCU
set_global_assignment -name OPTIMIZATION_MODE "AGGRESSIVE AREA"

set_global_assignment -name EDA_SIMULATION_TOOL "Questa Intel FPGA (Verilog)"
set_global_assignment -name EDA_TIME_SCALE "1 ps" -section_id eda_simulation
set_global_assignment -name EDA_OUTPUT_DATA_FORMAT "VERILOG HDL" -section_id eda_simulation

set_global_assignment -name ERROR_ON_WARNINGS_PARSING_SDC_ON_RTL_CONSTRAINTS ON
set_global_assignment -name ERROR_ON_WARNINGS_LOADING_SDC_ON_RTL_CONSTRAINTS ON
set_global_assignment -name RTL_SDC_FILE src/corescore_0/data/agilex25MHz.sdc

# 1.3-V LVCMOS is used to fake Quartus since 
set_location_assignment PIN_A7  -to i_clk
set_instance_assignment -name IO_STANDARD "1.3-V LVCMOS" -to i_clk

# Push-Button Switches
set_location_assignment PIN_A12  -to i_rstn
set_instance_assignment -name IO_STANDARD "1.3-V LVCMOS" -to i_rstn
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to i_rstn

# PLL Settings for 25MHz reference
set_parameter -name PLL_REF_CLK_FREQ "25.0 MHz"
set_parameter -name PLL_N_DIV 1
set_parameter -name PLL_M_DIV 32
set_parameter -name PLL_OUT_DIV 50
