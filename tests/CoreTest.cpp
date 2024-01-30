#include <stdlib.h>
#include <stdint.h>
#include <iostream>
#include <bitset>
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "VCore_int8.h"

#define MAX_TIME 40
uint8_t cnt = 0;

using namespace std;

int main() { 
  VCore_int8 *to = new VCore_int8;

  Verilated::traceEverOn(true);
  VerilatedVcdC *trace = new VerilatedVcdC;
  to->trace(trace, 5);
  trace->open("waveform.vcd");

  for(int i = 0; i < 16; i++) {
    to->activation[i] = i+1;
    printf("%d ",to->activation[i]);
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
    to->clk ^= 1; 

  }

     for(int i = 0; i < 4; i++) {
       for(int j = 0; j < 4; j++){
         printf("%d ", to->result_buffer[(4*i)+j]);
       }
       printf("\n");
       
     }
    trace->close();
    exit(0);
}
