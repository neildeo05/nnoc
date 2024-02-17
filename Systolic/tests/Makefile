core: 
	verilator -I../ -Wall -Wno-fatal --trace --cc --exe --build CoreTest.cpp ../Core.sv
	./obj_dir/VCore

fp:
	verilator -I../ -Wall -Wno-fatal --trace --cc --exe --build FPTest.cpp ../FMA.sv 
	./obj_dir/VFMA

pe_fp:
	verilator -I../ -Wall -Wno-fatal --trace --cc --exe --build FloatPETest.cpp ../PE_bf16.sv
	./obj_dir/VPE_bf16
pe_i8:
	verilator -I../ -Wall -Wno-fatal --trace --cc --exe --build PETest.cpp ../PE_int8.sv
	./obj_dir/VPE_int8

tile_accum:
	verilator -I../ -Wall -Wno-fatal --trace --cc --exe --build TileAccumTest.cpp ../TileAccumulator.sv
	./obj_dir/VTileAccumulator

dequant:
	verilator -I../ -Wall -Wno-fatal --trace --cc --exe --build tb_dequant.cpp ../dequant.sv 
	./obj_dir/Vdequant
	
quantization:
	verilator -I../ -Wall -Wno-fatal --trace --cc --exe --build tb_quant.cpp ../quantization.sv 
	./obj_dir/Vquantization
