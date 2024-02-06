// System Verilog for Core
// The core contains the array of PEs and some memory to cycle in activations

/*
 Instructions:
 
 High-level operation:
   - Compute Systolic Matmul
   - Load activation from input to shift register 
   - Load weight from input to grid 
 
 
 Accumulate into 32 bits. Then do a hardware quantize of the accumulated value


 */



module Core #(parameter WIDTH = 16, parameter ACCUMULATE = 32, parameter NUM_INP_TILES = 1) (clk, reset, weight_load, act_load, weights,  activation, result, result_buffer);
   input logic clk;
   input logic reset;
   input logic weight_load;
   input logic act_load;
   
   input logic [WIDTH-1:0] activation [15:0];
   input logic [WIDTH-1:0] weights [3:0][3:0]; // 15 el vector of weights
   output logic [ACCUMULATE-1:0] result [3:0];
   output logic [ACCUMULATE-1:0] result_buffer [15:0];
   

   logic [WIDTH-1:0] row1_val;
   logic [WIDTH-1:0] row2_val;
   logic [WIDTH-1:0] row3_val;
   logic [WIDTH-1:0] row4_val;
//   TileMem #(.WIDTH(WIDTH), .ACCUMULATE(ACCUMULATE)) (clk, reset, act_load, 
   ShiftBuffer #(.WIDTH(WIDTH)) shb (clk, reset, weight_load, activation, row1_val, row2_val, row3_val, row4_val);

   Array #(.WIDTH(WIDTH), .ACCUMULATE(ACCUMULATE)) arr(clk, reset, weight_load, weights, row1_val, row2_val, row3_val, row4_val, result);


   ResultBuffer #(.ACCUMULATE(ACCUMULATE)) rb(clk, weight_load, result, result_buffer);



   // Router module should take the result and quantize it back to a 8 bit num
   
   


   
endmodule;
   
