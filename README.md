# NNChip (work in progress)

# Running
This project uses Verilator. If you have verilator installed, you can run `make` in the `tests/` directory, and look at `waveform.vcd`

Goals:
1. [ ] Change from integer to bfloat16
2. [ ] Collect results in result buffer, and quantize from 32 bits back to 16 bits
3. [ ] Load, Accumulate, Route in Router (Target router gets two values and adds them based on head flit)
4. [ ] Bufferless routing



# Organization (in progress)

Each "core" contains a 4x4 systolic array, that does a matrix multiplication based on a routine. These cores are connected to one another using a torus interconnect. Information will be routed using flit-level bufferless routing <https://people.inf.ethz.ch/omutlu/pub/bless_isca09.pdf>. 

There are implementations of both int8 systolic arrays and bfloat16 systolic arrays

## LLM.int8() Quantization Routine
In the LLM.int8() quantization routine, operations that act on "outliers", which are numbers that aren't cleanly representable in the int8 format are kept as bfloat16 values, and a bfloat16 computation unit does the matrix multiplication on those values. The values that can be quantized are quantized, and a int8 compute unit takes care of those values.

## gpt-fast Quantization Routine

1. Weights are stored in int8 or GPTQ int4
2. Weights are dequantized to bfloat16, and loaded onto each process element
3. Activations are also dequantized to bfloat16
4. In systolic array, values are mulitplied, then accumulated into float32
5. When result is collected, output is quantized to int8 or gptq int4

The way it currently works is it writes quantized int8 values to a core, then converts them bfloat16, then transfers them to a systolic array, where they are accumulated into a float32. It then quantizes the float32 values into int8, and that is the output to the routers

That means that weights are only stored using 8 bits in memory, but accuracy shouldn't be degraded too much because all intermediate operations are done in bfloat16

# Routing Routine (not complete)

The goal of this project is to have extremely simple cores, routed with more complex routers.
Since we technically route "tiles" to each core, the output needs to be accumulated with another tile, and the bias, before it ends up in correct core for the next layer. In order to do this, the plan is to have the header flits "convey" the information that 'n' tiles need to be routed to the same place and need to be accumulated. When the router gets the head flits, it weights for 'n' sets of body flits, and when it gets all the tail flits, it accumulates them, before sending them to the core so the matrix multiplication can commence. It is worth analyzing this method and seing if it really is more efficient than doing the accumulations in the core themselves.
