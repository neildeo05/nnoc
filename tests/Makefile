core: 
	verilator -I../ -Wall -Wno-fatal --trace --cc --exe --build CoreTest.cpp ../Core.sv 
	./obj_dir/VCore

fp:
	verilator -I../ -Wall -Wno-fatal --trace --cc --exe --build FPTest.cpp ../FPMulacc.sv 
	./obj_dir/VFPMulacc
