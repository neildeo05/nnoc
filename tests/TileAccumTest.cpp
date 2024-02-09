#include <stdlib.h>
#include <stdint.h>
#include <iostream>
#include <bitset>
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "VTileAccumulator.h"

#define MAX_TIME 25
uint8_t cnt = 0;

using namespace std;

int main() { 
  VTileAccumulator *to = new VTileAccumulator;

  Verilated::traceEverOn(true);
  VerilatedVcdC *trace = new VerilatedVcdC;
  to->trace(trace, 5);
  trace->open("waveform_tile.vcd");

  for(int i = 0 ; i < 15; i++) {
    to->activation_input[i] = i;
  }
  
  to->act_load = 1;
  while (cnt != MAX_TIME) {
    if(cnt > 1) {
      if(cnt == 3 || cnt == 5 || cnt == 11) to->act_load = 1;
      else to->act_load = 0;
    }
    to->eval();
    trace->dump(cnt);

    cnt++;
    to->clk ^= 1; 

  }

    trace->close();
    exit(0);
}
