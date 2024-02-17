#include <stdlib.h>
#include <verilated.h>
#include <iostream>
#include <verilated_vcd_c.h>
#include "Vdequant.h"
#include <bitset>

#define MAX_TIME 20
uint8_t cnt = 0;

float int32_to_float_32(uint32_t val) {
  float *f = (float*)&val;
  return *f;
}


 int main (int argc, char** argv, char** env) {
 	Vdequant *vdq = new Vdequant;
 	float sc = -546.99;
	uint8_t num = 25;
 	Verilated::traceEverOn(true);
 	VerilatedVcdC *l_trace = new VerilatedVcdC;
 	vdq->trace(l_trace, 5);
 	l_trace->open("deqWaveform.vcd");
 	
	vdq->scale = *((uint32_t*)(&sc));
	vdq->int8Num = num;

 	while (cnt < MAX_TIME) {
 		vdq->eval();
 		l_trace->dump(cnt);
 		cnt++;
 	}
 	
	uint32_t output = vdq->outputFP;

	printf("Actual: %f\n", sc*num);
	printf("Calculated: %f\n", int32_to_float_32(output));
 	l_trace->close();
 	exit(0);
 }
