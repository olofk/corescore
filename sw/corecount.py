import curses
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

def main(stdscr):
    dev = sys.argv[1] if len(sys.argv) > 1 else '/dev/ttyUSB0'

    stdscr = curses.initscr()
    curses.curs_set(0)
    y = 0
    for l in COREY.split('\n'):
        stdscr.addstr(y, 0, l)
        y += 1
    stdscr.box(0,0)
    stdscr.refresh()
    win = curses.newwin(curses.LINES//2-2, curses.COLS-2, curses.LINES//2+1, 1)
    win.scrollok(True)
    win.addstr(1,10,'')
    win.refresh()

    found_cores = []
    with serial.Serial(dev, 57600) as ser:
        while(True):
            u = umsgpack.unpack(ser)
            if type(u) == str:
                (y,x) = win.getyx()
                win.addstr(curses.LINES//2-3,6,u[0:-1])
                win.refresh()
                n = int(u[5:10])
                if not (n in found_cores):
                    found_cores.append(n)
                    stdscr.addstr(10, 35, "Found {} cores".format(len(found_cores)))
                    stdscr.refresh()

curses.wrapper(main)
