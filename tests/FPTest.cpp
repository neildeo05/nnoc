#include <stdlib.h>
#include <iostream>
#include <bitset>
#include "FPHelpers.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "VFMA.h"

#define MAX_TIME 25
uint8_t cnt = 0;

using namespace std;

int main() { 
  VFMA *to = new VFMA;

  float a = 7.21;
  //float a = 9210.1;
  float b = 2.18;
  //float b = 2.1;
  float c = 1912319871.9;
  printf("(%f * %f) + %f\n", a, b, c);
  printf("Desired Mul result: %f\n", a * b);
  printf("Desired Mulacc result: %f\n", (a * b) + c);
  uint16_t af = float32_to_bfloat16(a);
  uint16_t bf = float32_to_bfloat16(b);
  float should_be = bfloat16_to_float32(extract_bfloat16_components(af))* bfloat16_to_float32(extract_bfloat16_components(bf))+ c;
  printf("(%f * %f) + %f = %f\n", bfloat16_to_float32(extract_bfloat16_components(af)), bfloat16_to_float32(extract_bfloat16_components(bf)), c, should_be);
  to->a = af;
  to->b = bf;
  to->c = *((uint32_t*)(&c));
  to->eval();
  float mul_out = int32_to_float_32(to->mul_out);
  float out = int32_to_float_32(to->out);
  printf("%f\n", mul_out);
  printf("%f\n", out);
  //  printf("%f\n", bfloat16_to_float32(result));
  //  printf("%d\n", mul_out);
  exit(0);
}
