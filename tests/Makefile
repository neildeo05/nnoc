core: 
	verilator -I../ -Wall -Wno-fatal --trace --cc --exe --build CoreTest.cpp ../Core_int8.sv 
	./obj_dir/VCore_int8

fp:
	verilator -I../ -Wall -Wno-fatal --trace --cc --exe --build FPTest.cpp ../FMA.sv 
	./obj_dir/VFMA
