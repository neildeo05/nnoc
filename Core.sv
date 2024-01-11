// System Verilog for Core
// The core contains the array of PEs and some memory to cycle in activations

/*
 Instructions:
 
 High-level operation:
   - Compute Systolic Matmul
   - Load activation from input to shift register 
   - Load weight from input to grid 

 */


module Core (clk, reset, load, weights,  activation, result);
   input logic clk;
   input logic reset;
   input logic load;
   
   
   input logic [7:0] weights [15:0]; // 15 el vector of weights
   input logic [7:0] activation [15:0];
   output logic [7:0] result [15:0];

   logic [7:0] row1_val;
   logic [7:0] row2_val;
   logic [7:0] row3_val;
   logic [7:0] row4_val;
   ShiftBuffer shb (clk, reset, load, activation, row1_val, row2_val, row3_val, row4_val);
   


   
endmodule;
   
