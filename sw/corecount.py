import serial
import sys
import umsgpack

COREY = r'''
/---------\
|   Hi!   |
|I'm Corey|---------\
\----------         |
     |  O"      O"  |
     |  _________   |
     |  \_______/   |
     \___________------------\
                 |Let's count|
                 |   cores!  |
                 \-----------/
'''

dev = sys.argv[1] if len(sys.argv) > 1 else '/dev/ttyUSB0'

found_cores = []
with serial.Serial(dev, 57600) as ser:
    print(COREY)
    while(True):
        u = umsgpack.unpack(ser)
        if type(u) == str:
            n = int(u[4:7])
            if not (n in found_cores):
                found_cores.append(n)
                print("Found {} cores".format(len(found_cores)))
