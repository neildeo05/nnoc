core: 
	verilator -I../ -Wall -Wno-fatal --trace --cc --exe --build CoreTest.cpp ../Core_int8.sv
	./obj_dir/VCore_int8

fp:
	verilator -I../ -Wall -Wno-fatal --trace --cc --exe --build FPTest.cpp ../FMA.sv 
	./obj_dir/VFMA

pe_fp:
	verilator -I../ -Wall -Wno-fatal --trace --cc --exe --build FloatPETest.cpp ../PE_bf16.sv
	./obj_dir/VPE_bf16

dequant:
	verilator -I../ -Wall -Wno-fatal --trace --cc --exe --build tb_dequant.cpp ../dequant.sv 
	./obj_dir/Vdequant
