create_ip -name sem -vendor xilinx.com -library ip -version 4.1 -module_name sem_0
set_property -dict [list CONFIG.CLOCK_FREQ {100}] [get_ips sem_0]
generate_target all [get_ips]
