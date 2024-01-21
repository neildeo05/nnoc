#include <stdlib.h>
#include <stdint.h>
#include <iostream>
#include <bitset>
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "VShiftBuffer.h"

#define MAX_TIME 50
uint8_t cnt = 0;

using namespace std;

int main() { 
  VShiftBuffer *to = new VShiftBuffer;

  Verilated::traceEverOn(true);
  VerilatedVcdC *trace = new VerilatedVcdC;
  to->trace(trace, 5);
  trace->open("waveform.vcd");

  for(int i = 0; i < 16; i++) {
    to->activation[i] = i+1;
  }
  to->load = 1;
  while (cnt != MAX_TIME) {

    if (cnt > 1) {
      if (cnt == 30 || cnt == 31) {
        to->load = 1;
      }
      else to->load = 0;
    }

    to->eval();
    trace->dump(cnt);

    cnt++;
    to->clk ^= 1; //tick dat shit
  }

    trace->close();
    exit(0);
}
