set_global_assignment -name MAX_CORE_JUNCTION_TEMP 100

set_instance_assignment -name FORCE_SYNCH_CLEAR ON -to * -entity serv_state
set_instance_assignment -name FORCE_SYNCH_CLEAR ON -to * -entity serv_alu
set_global_assignment -name OPTIMIZATION_MODE "AGGRESSIVE AREA"

set_instance_assignment -name IO_STANDARD "TRUE DIFFERENTIAL SIGNALING" -to i_clk -entity corescore_intel_agilex7
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to i_clk -entity corescore_intel_agilex7

set_global_assignment -name ERROR_ON_WARNINGS_PARSING_SDC_ON_RTL_CONSTRAINTS ON
set_global_assignment -name ERROR_ON_WARNINGS_LOADING_SDC_ON_RTL_CONSTRAINTS ON
set_global_assignment -name RTL_SDC_FILE src/corescore_0/data/intel_agilex7.sdc

