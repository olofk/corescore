import argparse
import os.path
import shutil
import subprocess

from fusesoc.config import Config
from fusesoc.coremanager import CoreManager
from fusesoc.edalizer import Edalizer
from fusesoc.librarymanager import Library
from fusesoc.vlnv import Vlnv

from edalize import get_edatool

config = Config('fusesoc.conf')

has_fusesoc_cores = False
has_corescore = False
for library in config.libraries:
    if library.name == 'fusesoc-cores':
        has_fusesoc_cores = True
    if library.name == 'corescore':
        has_corescore = True

if not has_fusesoc_cores:
    config.add_library(Library('fusesoc-cores', 'fusesoc_libraries/fusesoc-cores', 'git', 'https://github.com/fusesoc/fusesoc-cores'))

if not has_corescore:
    config.add_library(Library('corescore', 'fusesoc_libraries/corescore', 'git', 'https://github.com/olofk/corescore'))

cm = CoreManager(config)

for library in config.libraries:
    cm.add_library(library)

core = cm.get_core(Vlnv('corescore'))

parser = argparse.ArgumentParser()
parser.add_argument('--score', type=int)
parser.add_argument('target', choices = [x for x in core.targets.keys() if x != 'sim'])
args = parser.parse_args()

target = args.target

#Find highest CoreScore from value set in .core file and previous
# successful runs
max_ok = core.generate['corescorecore_'+target].parameters['count']
if os.path.exists('ok'):
    for d in os.listdir('ok'):
        (_target, _score) = d.rsplit('_', 1)
        if target == _target:
            max_ok = max(max_ok, int(_score))

#Find out lowest failed attempt (if any)
min_fail = None
if os.path.exists('fail'):
    for d in os.listdir('fail'):
        (_target, _score) = d.rsplit('_', 1)
        if target == _target:
            min_fail = min(min_fail or int(_score), int(_score))

#If the highest succesful score is one lower than the
#lowest failed, then we have reached our final CoreScore
if min_fail != None and min_fail-max_ok == 1:
    print("Final CoreScore is " + str(max_ok))
    exit(0)

if min_fail:
    #If we have a failed attempt, aim for something between the highest
    #successful and lowest failed attempt
    score = (max_ok+min_fail)//2
else:
    #Otherwise, just double the number of cores and see where it takes us
    score = max_ok*2

if args.score:
    score = args.score

#Monkeypatch the core with the new CoreScore. Very hacky
core.generate['corescorecore_'+target].parameters['count'] = score
        
flags = {}
flags['target'] = target

#FIXME: Allow overriding, e.g. for ecp5 builds that support diamond and trellis
tool = core.get_tool(flags)
flags['tool'] = tool
work_root = target+'_'+str(score)

eda_api_file = os.path.join(work_root, core.name.sanitized_name + ".eda.yml")

edalizer = Edalizer(
    toplevel=core.name,
    flags=flags,
    core_manager=cm,
    cache_root=cm.config.cache_root,
    work_root=work_root,
    system_name=work_root,
)
edalizer.run()
backend_class = get_edatool(tool)
edam = edalizer.edalize
edalizer.parse_args(backend_class, '', edam)

backend = get_edatool(tool)(edam=edam, work_root=work_root)

backend.configure([])

try:
    backend.build()
except RuntimeError as e:
    os.makedirs('fail', exist_ok=True)
    shutil.move(work_root, 'fail')
    print(work_root + " failed")
else:
    os.makedirs('ok', exist_ok=True)
    shutil.move(work_root, 'ok')
    print(work_root + " ok")
    
