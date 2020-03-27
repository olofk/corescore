#include <stdint.h>
#include <signal.h>

#include "verilated_vcd_c.h"
#include "Vcorescore_generic.h"

#include <fstream>

using namespace std;

static bool done;

vluint64_t main_time = 0;       // Current simulation time
// This is a 64-bit integer to reduce wrap over issues and
// allow modulus.  You can also use a double, if you wish.

ofstream file ("msgpack.bin", ios::out|ios::binary);

double sc_time_stamp () {       // Called by $time in Verilog
  return main_time;           // converts to double, to match
  // what SystemC does
}

void INThandler(int signal)
{
	printf("\nCaught ctrl-c\n");
	done = true;
}

typedef struct {
  uint8_t state;
  char ch;
  uint32_t baud_t;
  vluint64_t last_update;
} uart_context_t;

void uart_init(uart_context_t *context, uint32_t baud_rate) {
  context->baud_t = 1000*1000*1000/baud_rate;
  context->state = 0;
}

void do_uart(uart_context_t *context, bool rx) {
  if (context->state == 0) {
    if (rx)
      context->state++;
  }
  else if (context->state == 1) {
    if (!rx) {
      context->last_update = main_time + context->baud_t/2;
      context->state++;
    }
  }
  else if(context->state == 2) {
    if (main_time > context->last_update) {
      context->last_update += context->baud_t;
      context->ch = 0;
      context->state++;
    }
  }
  else if (context->state < 11) {
    if (main_time > context->last_update) {
      context->last_update += context->baud_t;
      context->ch |= rx << (context->state-3);
      context->state++;
    }
  }
  else {
    if (main_time > context->last_update) {
      context->last_update += context->baud_t;
      file.write (&context->ch, 1);
      putchar(context->ch);
      context->state=1;
    }
  }
}


int main(int argc, char **argv, char **env)
{
  Verilated::commandArgs(argc, argv);
  Vcorescore_generic* top = new Vcorescore_generic;

  VerilatedVcdC * tfp = 0;
  const char *vcd = Verilated::commandArgsPlusMatch("vcd=");
  if (vcd[0]) {
    Verilated::traceEverOn(true);
    tfp = new VerilatedVcdC;
    top->trace (tfp, 99);
    tfp->open ("trace.vcd");
  }


  uart_context_t uart_context;
  int baud_rate = 0;
  const char *arg = Verilated::commandArgsPlusMatch("uart_baudrate=");
  if (arg[0]) {
    baud_rate = atoi(arg+15);
    if (baud_rate) {
      uart_init(&uart_context, baud_rate);
    }
  }

  vluint64_t timeout = 0;
  const char *arg_timeout = Verilated::commandArgsPlusMatch("timeout=");
  if (arg_timeout[0])
    timeout = atoi(arg_timeout+9);

  signal(SIGINT, INThandler);

  top->i_clk = 1;
  bool q = top->o_uart_tx;

  while (!(done || Verilated::gotFinish())) {
    top->i_rst = main_time < 100;
    top->eval();
    if (tfp)
      tfp->dump(main_time);
    if (baud_rate) do_uart(&uart_context, top->o_uart_tx);

    if (timeout && (main_time >= timeout)) {
      printf("Timeout: Exiting at time %lu\n", main_time);
      done = true;
    }

    top->i_clk = !top->i_clk;
    main_time+=31.25;

  }
  if (tfp)
    tfp->close();
  if (file.is_open())
    file.close();
  exit(0);
}
