#include <stdlib.h>
#include <stdint.h>
#include <iostream>
#include <bitset>
#include "FPHelpers.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "VPE_bf16.h"

#define MAX_TIME 25
uint8_t cnt = 0;

using namespace std;

int main() { 
  VPE_bf16 *to = new VPE_bf16;

  Verilated::traceEverOn(true);
  VerilatedVcdC *trace = new VerilatedVcdC;
  to->trace(trace, 5);
  trace->open("waveform.vcd");
  float weight = 1;
  float north_val = 0;
  float west_val = 2;
  uint16_t af = float32_to_bfloat16(west_val);
  uint16_t bf = float32_to_bfloat16(weight);
  float should_be = (bfloat16_to_float32(extract_bfloat16_components(af)) * bfloat16_to_float32(extract_bfloat16_components(bf)))+ north_val;
  printf("%f\n", should_be);

  
  uint16_t weight_bits = float32_to_bfloat16(weight);
  uint16_t west_bits = float32_to_bfloat16(west_val);
  to->load = 1;

  uint32_t north_bits = *((uint32_t*)(&north_val));
  to->i_west = west_bits;
  to->i_weight = weight_bits;
  to->i_north = north_bits;

  bfloat16 o_east;
  int32_t o_south;
  while (cnt != MAX_TIME) {
    if(cnt > 1) {
      to->load = 0;
    }
    to->eval();
    o_east = extract_bfloat16_components(to->o_east);
    o_south = to->o_south;
    trace->dump(cnt);
    cnt++;
    to->clk ^= 1; 

  }
    printf("o_east = %f, o_south = %f\n", bfloat16_to_float32(o_east), int32_to_float_32(o_south));
    trace->close();
    exit(0);
}
