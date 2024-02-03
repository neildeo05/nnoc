module ShiftBuffer #(parameter WIDTH = 8)(clk, reset, load, activation, row1_val, row2_val, row3_val, row4_val);
   input logic clk;
   input logic reset;
   input logic load;

   input logic  [WIDTH-1:0] activation [15:0];
   output logic [WIDTH-1:0] row1_val;
   output logic [WIDTH-1:0] row2_val;
   output logic [WIDTH-1:0] row3_val;
   output logic [WIDTH-1:0] row4_val;
   logic [WIDTH-1:0]        shift_row_1_wires [4:0];
   logic [WIDTH-1:0]        shift_row_2_wires [5:0];
   logic [WIDTH-1:0]        shift_row_3_wires [6:0];
   logic [WIDTH-1:0]        shift_row_4_wires [7:0];
   assign row1_val = shift_row_1_wires[4];
   assign row2_val = shift_row_2_wires[5];
   assign row3_val = shift_row_3_wires[6];
   assign row4_val = shift_row_4_wires[7];
   
   assign shift_row_1_wires[0] = 0;
   assign shift_row_2_wires[0] = 0;
   assign shift_row_3_wires[0] = 0;
   assign shift_row_4_wires[0] = 0;
   
   generate
      genvar i;
      for(i = 1; i <= 4; i++) begin
         ShiftReg #(.WIDTH(WIDTH)) shr(clk, reset, load, activation[4-i], shift_row_1_wires[i-1], shift_row_1_wires[i]);
      end
   endgenerate;
   generate
      genvar j;
      for(j = 1; j <= 4; j++) begin
         ShiftReg #(.WIDTH(WIDTH)) shr(clk, reset, load, activation[8-j], shift_row_2_wires[j-1], shift_row_2_wires[j]);
      end
   endgenerate;
   ShiftReg #(.WIDTH(WIDTH)) shr_1_0(clk, reset, load, 0, shift_row_2_wires[4], shift_row_2_wires[5]);

   
   generate
      genvar k;
      for(k = 1; k <= 4; k++) begin
         ShiftReg #(.WIDTH(WIDTH)) shr(clk, reset, load, activation[12-k], shift_row_3_wires[k-1], shift_row_3_wires[k]);
      end
   endgenerate;
   ShiftReg #(.WIDTH(WIDTH)) shr_2_0(clk, reset, load, 0, shift_row_3_wires[4], shift_row_3_wires[5]);
   ShiftReg #(.WIDTH(WIDTH)) shr_2_1(clk, reset, load, 0, shift_row_3_wires[5], shift_row_3_wires[6]);
   
   
   generate
      genvar l;
      for(l = 1; l <= 4; l++) begin
         ShiftReg #(.WIDTH(WIDTH)) shr(clk, reset, load, activation[16-l], shift_row_4_wires[l-1], shift_row_4_wires[l]);
      end
   endgenerate;
   ShiftReg #(.WIDTH(WIDTH)) shr_3_0(clk, reset, load, 0, shift_row_4_wires[4], shift_row_4_wires[5]);
   ShiftReg #(.WIDTH(WIDTH)) shr_3_1(clk, reset, load, 0, shift_row_4_wires[5], shift_row_4_wires[6]);
   ShiftReg #(.WIDTH(WIDTH)) shr_3_2(clk, reset, load, 0, shift_row_4_wires[6], shift_row_4_wires[7]);
   
   
   
   
endmodule;
   
