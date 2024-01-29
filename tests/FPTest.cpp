#include <stdlib.h>
#include <stdint.h>
#include <iostream>
#include <bitset>
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "VFMA.h"

#define MAX_TIME 25
uint8_t cnt = 0;

using namespace std;
typedef struct {
  uint16_t mantissa : 7;
  uint16_t exponent : 8;
  uint16_t sign     : 1;
} bfloat16;

uint16_t float32_to_bfloat16(float f) {
  uint32_t *f_as_int = (uint32_t*)&f;
  uint16_t bfloat = (*f_as_int) >> 16; // shift right to truncate mantissa
  return bfloat;
}



bfloat16 extract_bfloat16_components(uint16_t bfloat) {
  bfloat16 result;

  result.mantissa = bfloat & 0x7F;         // last 7 bits
  result.exponent = (bfloat >> 7) & 0xFF;  // next 8 bits
  result.sign = (bfloat >> 15) & 0x1;      // first bit
  return result;
}
float bfloat16_to_float32(bfloat16 bfloat) {
    uint32_t f_as_int = *((uint16_t*)&bfloat) << 16; // extend to 32 bits
    float *f = (float*)&f_as_int;
    return *f;
}

float int32_to_float_32(uint32_t val) {
  float *f = (float*)&val;
  return *f;
}

int main() { 
  VFMA *to = new VFMA;

  //float a = 75021.11893;
  float a = 9210.1;
  float b = 19031.983;
  //float b = 2.1;
  float c = 1912319871.9;
  printf("(%f * %f) + %f\n", a, b, c);
  printf("Desired Mul result: %f\n", a * b);
  printf("Desired Mulacc result: %f\n", (a * b) + c);
  uint16_t af = float32_to_bfloat16(a);
  uint16_t bf = float32_to_bfloat16(b);
  float should_be = bfloat16_to_float32(extract_bfloat16_components(af))* bfloat16_to_float32(extract_bfloat16_components(bf))+ c;
  printf("(%f * %f) + %f = %f\n", bfloat16_to_float32(extract_bfloat16_components(af)), bfloat16_to_float32(extract_bfloat16_components(bf)), c, should_be);
  printf("%f\n", c);
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
