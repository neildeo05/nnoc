#ifndef FP_HELPERS_H
#define FP_HELPERS_H
#include <stdint.h>
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


#endif
