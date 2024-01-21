#include <stdlib.h>
#include <stdint.h>
#include <iostream>
#include <bitset>
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "VCore.h"

#define MAX_TIME 40
uint8_t cnt = 0;

using namespace std;

int main() { 
  VCore *to = new VCore;

  Verilated::traceEverOn(true);
  VerilatedVcdC *trace = new VerilatedVcdC;
  to->trace(trace, 5);
  trace->open("waveform.vcd");

  for(int i = 0; i < 16; i++) {
    to->activation[i] = i+1;
  }
  printf("\n");
  for(int i = 0; i < 4; i++) {
     for(int j = 0; j < 4; j++) {
       to->weights[i][j] = ((i+1)*(j+1));
	printf("%d ", to->weights[i][j]);
     }
     printf("\n");
  }
  
  to->load = 1;
  while (cnt != MAX_TIME) {
    // have to wait to laod the weight
    if(cnt > 1) {
      to->load = 0;
    }
    to->eval();
    trace->dump(cnt);

    cnt++;
    to->clk ^= 1; //tick dat shit

  }

    trace->close();
    exit(0);
}
