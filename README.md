# CoreScore

## Background

CoreScore is an award-giving benchmark for FPGAs and their synthesis/P&R tools. It tests how many [SERV](https://github.com/olofk/serv) cores that can be put into a particular FPGA.

## Quick start

1. Install [FuseSoC](https://github.com/olofk/fusesoc)

       pip install fusesoc

2. Set up a workspace directory and get the FuseSoC base library

       mkdir workspace
       cd workspace
       fusesoc library add fusesoc-cores https://github.com/fusesoc/fusesoc-cores

3. Add CoreScore as a library in your workspace

       fusesoc library add corescore https://github.com/olofk/corescore

4. Check available corescore targets

       fusesoc core show corescore

5. Build one of the supported targets (cyc1000 is one of the currently supported cores)

       fusesoc run --target=cyc1000 corescore

6. If the board is connected it will be automatically programmed. Otherwise connect it and run `fusesoc run --run --target=cyc1000 corescore` to program without rebuilding

7. Run the corecount utility (Might need to adjust for the correct UART port)

       python3 fusesoc_libraries/corescore/sw/corecount.py /dev/ttyUSB0
