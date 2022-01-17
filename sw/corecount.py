import curses
import serial
import sys
import msgpack

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
        try:
            stdscr.addstr(y, 0, l)
        except curses.error:
            pass
        y += 1
    stdscr.box(0, 0)
    stdscr.refresh()
    win = curses.newwin(curses.LINES//2-2, curses.COLS-2, curses.LINES//2+1, 1)
    win.scrollok(True)
    win.addstr(1, 10, '')
    win.refresh()

    found_cores = []
    with serial.Serial(dev, 57600) as ser:
        unpacker = msgpack.Unpacker(raw=False)
        while(True):
            buf = ser.read()
            unpacker.feed(buf)
            for o in unpacker:
                if type(o) == str:
                    (y, x) = win.getyx()
                    win.addstr(curses.LINES//2-3, 6, o[0:-1])
                    win.refresh()
                    n = int(o[5:10])
                    if not (n in found_cores):
                        found_cores.append(n)
                        stdscr.addstr(
                            10, 35, "Found {} cores".format(len(found_cores)))
                        stdscr.refresh()


curses.wrapper(main)
