#include <stdlib.h>
#include <stdint.h>
#include <iostream>
#include <bitset>
#include "FPHelpers.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "VCore.h"

#define MAX_TIME 100
#define PE_TYPE 16
uint8_t cnt = 0;

using namespace std;

int main() { 
  VCore *to = new VCore;

  Verilated::traceEverOn(true);
  VerilatedVcdC *trace = new VerilatedVcdC;
  to->trace(trace, 5);
  if (PE_TYPE == 8) {
    trace->open("waveform_i8.vcd");
  }
  else trace->open("waveform_bf16.vcd");

  for(int i = 0; i < 16; i++) {
    if (PE_TYPE == 8) {
      to->activation[i] = 17-(i+1);
      printf("%d ",to->activation[i]);
    }
    else if (PE_TYPE == 16) {
      uint16_t bf_val = float32_to_bfloat16((float)17-(i+1));
      to->activation[i] = bf_val;
      printf("%f ", bfloat16_to_float32(extract_bfloat16_components(to->activation[i])));
    }
  }
  printf("\n");
  for(int i = 0; i < 4; i++) {
     for(int j = 0; j < 4; j++) {
       if (PE_TYPE == 8) {
       to->weights[i][j] = ((i+1)*(j+1));
         printf("%d ", to->weights[i][j]);
       } 
       else if (PE_TYPE == 16) {
         uint16_t wf_val = float32_to_bfloat16((float)((i+1)*(j+1)));
         to->weights[i][j] = wf_val;
       printf("%f ", bfloat16_to_float32(extract_bfloat16_components(to->weights[i][j])));
         
       }
     }

     printf("\n");
  }
  
  to->weight_load = 1;
  while (cnt != MAX_TIME) {
    // have to wait to load the weight
    if(cnt > 1) {
      if (cnt == 40 || cnt == 41) {
        to->weight_load = 1;
      }
      else {
        to->weight_load = 0;
      }
    }

    to->eval();
    trace->dump(cnt);

    cnt++;
    to->clk ^= 1; 

  }

     for(int i = 0; i < 4; i++) {
       for(int j = 0; j < 4; j++){
         if (PE_TYPE == 16) printf("%f ", int32_to_float_32(to->result_buffer[(4*i)+j]));
         else printf("%d ", to->result_buffer[(4*i)+j]);
       }
       printf("\n");
       
     }
    trace->close();
    exit(0);
}
