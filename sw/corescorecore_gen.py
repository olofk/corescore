#!/usr/bin/python
from fusesoc.capi2.generator import Generator
import os
import shutil
import subprocess

from verilogwriter import Instance, ModulePort, Parameter, Port, VerilogWriter, Wire

HEX_TEMPLATE = '''00000013
00000517
03c50513
c00005b7
0b400293
00558023
00050283
00150513
fe029ae3
1002e293
00559023
000022b7
71028293
fff28293
fe029ee3
fc5ff06f
65726f43
20{}{}{}
73796173
6c656820
000a6f6c
'''

class CoreScoreCoreGenerator(Generator):
    def run(self):
        files = [{'corescorecore.v' : {'file_type' : 'verilogSource'}}]
        count = self.config.get('count')

        for idx in range(count):
            name = 'core_{}'.format(idx)
            memfile = name+'.hex'

            #Create hex file
            with open(memfile, 'w') as f:
                _s = '{:03}'.format(idx)
                f.write(HEX_TEMPLATE.format(hex(ord(_s[2]))[2:],
                                            hex(ord(_s[1]))[2:],
                                            hex(ord(_s[0]))[2:]))
            files.append({memfile : {'file_type' : 'user', 'copyto' : memfile }})

        self.gen_corescorecore(count)
        self.add_files(files)

    def gen_corescorecore(self, count):
        corescorecore = VerilogWriter('corescorecore')

        corescorecore.add(ModulePort('i_clk'  , 'input'))
        corescorecore.add(ModulePort('i_rst'  , 'input'))
        corescorecore.add(ModulePort('o_tdata'  , 'output', 8))
        corescorecore.add(ModulePort('o_tlast'  , 'output'))
        corescorecore.add(ModulePort('o_tvalid' , 'output'))
        corescorecore.add(ModulePort('i_tready' , 'input'))

        corescorecore.add(Wire('tdata' , count*8))
        corescorecore.add(Wire('tlast' , count))
        corescorecore.add(Wire('tvalid', count))
        corescorecore.add(Wire('tready', count))

        for idx in range(count):
            base_ports = [
                Port('i_clk', 'i_clk'),
                Port('i_rst', 'i_rst'),
                Port('o_wb_coll_adr', ''),
                Port('o_wb_coll_dat', ''),
                Port('o_wb_coll_we' , ''),
                Port('o_wb_coll_stb', ''),
                Port('i_wb_coll_rdt', "32'd0"),
                Port('i_wb_coll_ack', "1'b0"),
                Port('o_tdata'  , 'tdata[{}:{}]'.format(idx*8+7,idx*8)),
                Port('o_tlast'  , 'tlast[{}]'.format(idx)),
                Port('o_tvalid' , 'tvalid[{}]'.format(idx)),
                Port('i_tready' , 'tready[{}]'.format(idx)),
            ]
            corescorecore.add(Instance('base', 'core_'+str(idx),
                                   [Parameter('memfile', '"core_{}.hex"'.format(idx)),
                                    Parameter('memsize', '84')],
                                   base_ports))

        arbports = [
            Port('clk', 'i_clk'),
            Port('rst', 'i_rst'),
            Port("s_axis_tdata".format(idx) , "tdata"),
            Port("s_axis_tkeep".format(idx) , "{}'d0".format(count)),
            Port("s_axis_tvalid".format(idx), 'tvalid'),
            Port("s_axis_tready".format(idx), 'tready'),
            Port("s_axis_tlast".format(idx) , 'tlast'),
            Port("s_axis_tid".format(idx)   , "{}'d0".format(count*8)),
            Port("s_axis_tdest".format(idx) , "{}'d0".format(count*8)),
            Port("s_axis_tuser".format(idx) , "{}'d0".format(count)),
            Port('m_axis_tdata ', 'o_tdata'),
            Port('m_axis_tkeep ', ''),
            Port('m_axis_tvalid', 'o_tvalid'),
            Port('m_axis_tready', 'i_tready'),
            Port('m_axis_tlast ', 'o_tlast'),
            Port('m_axis_tid   ', ''),
            Port('m_axis_tdest ', ''),
            Port('m_axis_tuser ', ''),
        ]
        arbparams = [
            Parameter('S_COUNT', count),
            Parameter('DATA_WIDTH', 8),
            Parameter('KEEP_ENABLE', 0),
            Parameter('KEEP_WIDTH', 1),
            Parameter('ID_ENABLE', 0),
            Parameter('ID_WIDTH', 8),
            Parameter('DEST_ENABLE', 0),
            Parameter('DEST_WIDTH', 8),
            Parameter('USER_ENABLE', 0),
            Parameter('USER_WIDTH', 1),
            Parameter('ARB_TYPE', '"ROUND_ROBIN"'),
            Parameter('LSB_PRIORITY', '"HIGH"'),
        ]

        corescorecore.add(Instance('axis_arb_mux', 'axis_mux', arbparams, arbports))
        corescorecore.write('corescorecore.v')

g = CoreScoreCoreGenerator()
g.run()
g.write()
