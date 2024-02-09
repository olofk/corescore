#!/usr/bin/python3
from fusesoc.capi2.generator import Generator
from math import ceil, floor, log2
import os
import shutil
import subprocess

from verilogwriter import Instance, ModulePort, Parameter, Port, VerilogWriter, Wire

#HEX_TEMPLATE implements the following program
#/*
#* Read a string and send as packet to emitter
#*
#*
#*/
##define AXIS_ADDR 0xC0000000
#
#	/*
#	a0 = String address
#	a1 = Emitter FIFO address
#	t0 = Character to write
#	*/
#
#.globl _start
#_start:
#	nop
#	/* Load string address to a0 */
#	la	a0, str
#
#	/* Load axis address to a1 */
#	li	a1, AXIS_ADDR
#
#	/* Write MSGPack string header (0b101xxxxx + len) */
#	li	t0, 0xa0+23
#
#next:	/* Write to FIFO */
#	sb	t0, 0(a1)
#
#	/* Read byte from str */
#	lb	t0, 0(a0)
#
#	/* Load next address */
#	addi	a0, a0, 1
#
#	/* Check if this was last byte in packet */
#	bnez	t0, next
#
#	/* Write packet end to FIFO */
#	ori	t0, t0, 0x100
#	sh	t0, 0(a1)
#
#	li	t0, 10000
#loop:	addi	t0, t0, -1
#	bnez	t0, loop
#	j _start
#
#str:
#	.string "Core XXXXX says hello\n"

HEX_TEMPLATE = '''@0000
13 00 00 00
17 05 00 00
13 05 c5 03
b7 05 00 c0
93 02 70 0b
23 80 55 00
83 02 05 00
13 05 15 00
e3 9a 02 fe
93 e2 02 10
23 90 55 00
b7 22 00 00
93 82 02 71
93 82 f2 ff
e3 9e 02 fe
6f f0 5f fc
43 6F 72 65
20 {} {} {}
{} {} 20 73
61 79 73 20
68 65 6C 6C
6F 0A 00 00
'''

HEX_TEMPLATE2 = '''@0100
13 00 00 00
17 05 00 00
13 05 c5 03
b7 05 00 c0
93 02 70 0b
23 80 55 00
83 02 05 00
13 05 15 00
e3 9a 02 fe
93 e2 02 10
23 90 55 00
b7 22 00 00
93 82 02 71
93 82 f2 ff
e3 9e 02 fe
6f f0 5f fc
43 6F 72 65
20 {} {} {}
{} {} 20 73
61 79 73 20
68 65 6C 6C
6F 0A 00 00
'''

class CoreScoreCoreGenerator(Generator):
    def run(self):
        files = [{'corescorecore.v': {'file_type': 'verilogSource'}}]
        count = self.config.get('count')

        for idx in range(count):
            name = 'core_{}'.format(idx)
            memfile = name+'.hex'

            # Create hex file
            with open(memfile, 'w') as f:
                _s = '{:05}'.format(idx)
                f.write(HEX_TEMPLATE.format(hex(ord(_s[0]))[2:],
                                            hex(ord(_s[1]))[2:],
                                            hex(ord(_s[2]))[2:],
                                            hex(ord(_s[3]))[2:],
                                            hex(ord(_s[4]))[2:]))
                _s = '{:05}'.format(idx+1)
                f.write(HEX_TEMPLATE2.format(hex(ord(_s[0]))[2:],
                                            hex(ord(_s[1]))[2:],
                                            hex(ord(_s[2]))[2:],
                                            hex(ord(_s[3]))[2:],
                                            hex(ord(_s[4]))[2:]))
            files.append({memfile: {'file_type': 'user', 'copyto': memfile}})

        self.gen_corescorecore(count)
        self.add_files(files)

    def gen_corescorecore(self, count, bufsize=128):

        n = floor(bufsize/23)

        corescorecore = VerilogWriter('corescorecore')

        corescorecore.add(ModulePort('i_clk', 'input'))
        corescorecore.add(ModulePort('i_rst', 'input'))
        corescorecore.add(ModulePort('o_tdata', 'output', 8))
        corescorecore.add(ModulePort('o_tlast', 'output'))
        corescorecore.add(ModulePort('o_tvalid', 'output'))
        corescorecore.add(ModulePort('i_tready', 'input'))

        corescorecore.add(Wire('data' , 8))
        corescorecore.add(Wire('valid'))
        corescorecore.add(Wire('empty'))

        for idx in range(count):
            corescorecore.add(Wire(f'data{idx}' , 8))
            corescorecore.add(Wire(f'valid{idx}'))
            corescorecore.add(Wire(f'token{idx}'))

            corescorecore.add(Wire('waddr'+str(idx), 8))
            corescorecore.add(Wire('wdata'+str(idx), 8))
            corescorecore.add(Wire('wen'+str(idx)))
            corescorecore.add(Wire('raddr'+str(idx), 8))
            corescorecore.add(Wire('rdata'+str(idx), 8))

            if idx == 0:
                idata  = "8'd0"
                ilast  = "1'b0"
                ivalid = "1'b0"
                itoken = f"token{count-1}"
                odata  = f"data{idx}"
                olast  = f"last{idx}"
                ovalid = f"valid{idx}"
                otoken = f"token{idx}"
            elif idx == count-1:
                idata  = f"data{idx-1}"
                ilast  = f"last{idx-1}"
                ivalid = f"valid{idx-1}"
                itoken = f"token{idx-1}"
                odata  = f"data"
                olast  = f"last"
                ovalid = f"valid"
                otoken = f"token{idx}"
            else:
                idata  = f"data{idx-1}"
                ilast  = f"last{idx-1}"
                ivalid = f"valid{idx-1}"
                itoken = f"token{idx-1}"
                odata  = f"data{idx}"
                olast  = f"last{idx}"
                ovalid = f"valid{idx}"
                otoken = f"token{idx}"

            if (idx%n == n-1):
                corescorecore.add(Wire(f'tokenhold{idx}'))
                otokenhold = otoken
                otoken = f"tokenhold{idx}"
                corescorecore.add(Instance('token_hold', f'token_hold{idx}', [],
                                           [Port("i_clk", "i_clk"),
                                           Port("i_rst", "i_rst"),
                                           Port("i_token", otoken),
                                           Port("i_hold" , "!empty"),
                                           Port("o_token", otokenhold)],
                                           ))
                
            base_ports = [
                Port('i_clk'  , 'i_clk'),
                Port('i_rst'  , 'i_rst'),
                Port('i_data' , idata),
                Port('i_last' , "1'b0"),
                Port('i_valid', ivalid),
                Port('i_token', itoken),
                Port('o_data' , odata),
                Port('o_last' , ""),
                Port('o_valid', ovalid),
                Port('o_token', otoken),
                Port('o_waddr', 'waddr'+str(idx)),
                Port('o_wdata', 'wdata'+str(idx)),
                Port('o_wen'  , 'wen'+str(idx)),
                Port('o_raddr', 'raddr'+str(idx)),
                Port('i_rdata', 'rdata'+str(idx))
            ]
            corescorecore.add(Instance('base', 'core_'+str(idx),
                                       [Parameter('memfile', '"core_{}.hex"'.format(idx)),
                                        Parameter('memsize', '256'),
                                        Parameter("TOKEN_INIT", "1'b1" if idx == 0 else "1'b0")],
                                       base_ports))

        for idx in range(0, count, 2):

            ram_ports = [
                Port('clka' , 'i_clk'),
                Port('ena'  , "1'b1"),
                Port('wea'  , 'wen'+str(idx)),
                Port('addra', "{1'b0,"+f"wen{idx} ? waddr{idx} : raddr{idx}"+'}'),
                Port('dia'  , 'wdata'+str(idx)),
                Port('doa'  , 'rdata'+str(idx)),
                Port('clkb' , 'i_clk'),
                Port('enb'  , "1'b1"),
                Port('web'  , 'wen'+str(idx+1)),
                Port('addrb', "{1'b1,"+f"wen{idx+1} ? waddr{idx+1} : raddr{idx+1}"+'}'),
                Port('dib'  , 'wdata'+str(idx+1)),
                Port('dob'  , 'rdata'+str(idx+1)),
            ]

            corescorecore.add(Instance('rams_tdp_rf_rf', 'ram_'+str(idx),
                                       [Parameter('memfile', '"core_{}.hex"'.format(idx))],
                                       ram_ports))
        #for idx in range(count):
        #
        #    ram_ports = [
        #        Port('i_clk'  , 'i_clk'),
        #        Port('i_waddr', 'waddr'+str(idx)),
        #        Port('i_wdata', 'wdata'+str(idx)),
        #        Port('i_wen'  , 'wen'+str(idx)),
        #        Port('i_raddr', 'raddr'+str(idx)),
        #        Port('o_rdata', 'rdata'+str(idx))]
        #
        #    corescorecore.add(Instance('serving_ram', 'ram_'+str(idx),
        #                               [Parameter('memfile', '"core_{}.hex"'.format(idx)),
        #                                Parameter('depth', '256')],
        #                               ram_ports))

        fifoports = [
            Port("clk", "i_clk"),
            Port("rst", "i_rst"),
            Port("din" , "data"),
            Port("wr_en"   , "valid"),
            Port("full", ""),
            Port("dout" , "o_tdata"),
            Port("rd_en"   , "i_tready & ~empty"),
            Port("empty" , "empty"),
            ]
        fifoparams = [
            Parameter('DEPTH_WIDTH', ceil(log2(bufsize))),
            Parameter('DATA_WIDTH', 8),
        ]

        corescorecore.add(
            Instance('fifo_fwft', 'fifo', fifoparams, fifoports))
        corescorecore.raw = "assign o_tvalid = ~empty;\n\n"
        corescorecore.write('corescorecore.v')


g = CoreScoreCoreGenerator()
g.run()
g.write()
