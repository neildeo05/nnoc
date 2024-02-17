#include <stdlib.h>
#include <verilated.h>
#include <iostream>
#include <verilated_vcd_c.h>
#include "Vquantization.h"
#include <bitset>

#define MAX_TIME 20
uint8_t cnt = 0;

float int32_to_float_32(uint32_t val) {
  float *f = (float*)&val;
  return *f;
}


 int main (int argc, char** argv, char** env) {
 	Vquantization *vq = new Vquantization;
 	float sc = 1.23;
	float iFP = 23.92;
 	Verilated::traceEverOn(true);
 	VerilatedVcdC *l_trace = new VerilatedVcdC;
 	vq->trace(l_trace, 5);
 	l_trace->open("qWaveform.vcd");
 	
	vq->scale = *((uint32_t*)(&sc));
	vq->inputFP = *((uint32_t*)(&iFP));

 	while (cnt < MAX_TIME) {
 		vq->eval();
 		l_trace->dump(cnt);
 		cnt++;
 	}
 	
	int8_t output = vq->outputInt8;
	uint32_t div = vq->scaledFp32;

	printf("Actual: %f\n", ((iFP*sc)));
	printf("Calculated: %d\n", output);
	printf("Division: %f\n", int32_to_float_32(div));
 	l_trace->close();
 	exit(0);
 }
