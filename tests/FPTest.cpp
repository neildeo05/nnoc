#include <stdlib.h>
#include <stdint.h>
#include <iostream>
#include <bitset>
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "VFPMulacc.h"

#define MAX_TIME 25
uint8_t cnt = 0;

using namespace std;

int main() { 
  VFPMulacc *to = new VFPMulacc;

  Verilated::traceEverOn(true);
  VerilatedVcdC *trace = new VerilatedVcdC;
  to->trace(trace, 5);
  trace->open("waveform.vcd");

  
  while (cnt != MAX_TIME) {
    to->eval();
    trace->dump(cnt);
    cnt++;
    to->clk ^= 1; //tick dat shit

  }

    trace->close();
    exit(0);
}
