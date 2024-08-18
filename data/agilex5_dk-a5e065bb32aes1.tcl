set_global_assignment -name VERILOG_CU_MODE MFCU
set_global_assignment -name OPTIMIZATION_MODE "AGGRESSIVE AREA"
*
set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 256
set_global_assignment -name EDA_SIMULATION_TOOL "Questa Intel FPGA (Verilog)"
set_global_assignment -name EDA_TIME_SCALE "1 ps" -section_id eda_simulation
set_global_assignment -name EDA_OUTPUT_DATA_FORMAT "VERILOG HDL" -section_id eda_simulation

set_global_assignment -name GENERATE_COMPRESSED_SOF ON
set_global_assignment -name AUTO_RESTART_CONFIGURATION OFF
set_global_assignment -name STRATIXV_CONFIGURATION_SCHEME "AVST X8"
set_global_assignment -name ON_CHIP_BITSTREAM_DECOMPRESSION OFF
set_global_assignment -name USE_CONF_DONE SDM_IO12
set_global_assignment -name USE_HPS_COLD_RESET SDM_IO7
set_global_assignment -name DEVICE_INITIALIZATION_CLOCK OSC_CLK_1_125MHZ
set_global_assignment -name POWER_APPLY_THERMAL_MARGIN ADDITIONAL

set_global_assignment -name ERROR_ON_WARNINGS_PARSING_SDC_ON_RTL_CONSTRAINTS ON
set_global_assignment -name ERROR_ON_WARNINGS_LOADING_SDC_ON_RTL_CONSTRAINTS ON
set_global_assignment -name RTL_SDC_FILE src/corescore_0/data/intel_agilex7.sdc

# Clock
set_location_assignment PIN_D8 -to i_clk -comment IOBANK_6C
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to clk -entity veerwolf_agilex

# Reset PB SW11 HPS_COLD_RESETn Bank 5B 3.3V
set_location_assignment PIN_BM109 -to i_rstn -comment IOBANK_5B
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to rstn -entity veerwolf_agilex
