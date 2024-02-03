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



module Core #(parameter WIDTH = 16, parameter ACCUMULATE = 32) (clk, reset, load, weights,  activation, result, result_buffer);
   input logic clk;
   input logic reset;
   input logic load;
   
   
   input logic [WIDTH-1:0] weights [3:0][3:0]; // 15 el vector of weights
   input logic [WIDTH-1:0] activation [15:0];
   output logic [ACCUMULATE-1:0] result [3:0];
   output logic [ACCUMULATE-1:0] result_buffer [15:0];
   

   logic [WIDTH-1:0] row1_val;
   logic [WIDTH-1:0] row2_val;
   logic [WIDTH-1:0] row3_val;
   logic [WIDTH-1:0] row4_val;
   ShiftBuffer #(.WIDTH(WIDTH)) shb (clk, reset, load, activation, row1_val, row2_val, row3_val, row4_val);

   Array #(.WIDTH(WIDTH), .ACCUMULATE(ACCUMULATE)) arr(clk, reset, load, weights, row1_val, row2_val, row3_val, row4_val, result);


   ResultBuffer #(.ACCUMULATE(ACCUMULATE)) rb(clk, reset, result, result_buffer);



   // Router module should take the result and quantize it back to a 8 bit num
   
   


   
endmodule;
   
