#include <stdlib.h>
#include <stdint.h>
#include <iostream>
#include <bitset>
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "VPE.h"

#define MAX_TIME 25
uint8_t cnt = 0;

using namespace std;

int main() { 
  VPE *to = new VPE;

  Verilated::traceEverOn(true);
  VerilatedVcdC *trace = new VerilatedVcdC;
  to->trace(trace, 5);
  trace->open("waveform.vcd");

  
  to->i_weight = 10;
  to->load = 1;

  to->i_north = 2;
  to->i_west = 2;
  while (cnt != MAX_TIME) {
    // have to wait to laod the weight
    if(cnt > 1) {
      to->load = 0;
    }
    if(cnt == 10 || cnt == 11) {
      to->reset = 1;
      to->i_north = 3;
      to->i_west = 6;
    }
    else {
      to->reset = 0;
    }
    to->eval();
    trace->dump(cnt);

    cnt++;
    to->clk ^= 1; //tick dat shit

  }

    trace->close();
    exit(0);
}
