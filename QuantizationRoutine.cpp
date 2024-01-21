#include <stdint.h>
#include <stdio.h>

typedef struct {
  uint16_t mantissa : 7;
  uint16_t exponent : 8;
  uint16_t sign     : 1;
} bfloat16;

uint16_t float32_to_bfloat16(float f) {
  uint32_t *f_as_int = (uint32_t*)&f;
  uint16_t bfloat = (*f_as_int) >> 16; // Shift right to truncate mantissa
  return bfloat;
}

bfloat16 extract_bfloat16_components(uint16_t bfloat) {
  bfloat16 result;
    //    result.mantissa = bfloat & 0x7F;         // Last 7 bits
    //    result.exponent = (bfloat >> 7) & 0xFF;  // Next 8 bits
    //    result.sign = (bfloat >> 15) & 0x1;      // First bit

  result.mantissa = bfloat & 0x7F;         // Last 7 bits
  result.exponent = (bfloat >> 7) & 0xFF;  // Next 8 bits
  result.sign = (bfloat >> 15) & 0x1;      // First bit
  return result;
}

/*
1. Weights are stored in int8 or GPTQ int4
2. Weights are dequantized to bfloat16, and loaded onto each core
3. Activations are also dequantized to bfloat16
4. In systolic array, values are mulitplied, then accumulated into float32
5. When result is collected, output is quantized to int8 or gptq int4
*/

int main() {
  int8_t weight = 3;
  uint16_t dequantized_bfloat = dequantize_int8_to_bfloat16(weight);

  //  float f = 6.9f;
  //  uint16_t bfloat = float32_to_bfloat16(f);
  //  bfloat16 components = extract_bfloat16_components(bfloat);
  //  printf("Sign: %d, Exponent: %d, Mantissa: %d\n", components.sign, components.exponent, components.mantissa);
  return 0;
}
