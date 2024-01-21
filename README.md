# NNChip

Goals:
0. [ ] Change from integer to bfloat16
1. [ ] Collect results in result buffer, and quantize from 32 bits back to 16 bits
2. [ ] Load, Accumulate, Route in Router (Target router gets two values and adds them based on head flit)
  ---- Send Email ---
5. [ ] Network on Chip



# Routine

1. Weights are stored in int8 or GPTQ int4
2. Weights are loaded to each core
3. Weights are dequantized to bfloat16
4. In systolic array, values are mulitplied, then accumulated into float32
5. When result is collected, output is quantized to int8 or gptq int4

The way it currently works is it writes quantized int8 values to a core, then converts them bfloat16, then transfers them to a systolic array, where they are accumulated into a float32. It then quantizes the float32 values into int8, and that is the output. 
