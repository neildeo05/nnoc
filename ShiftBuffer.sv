module ShiftBuffer (clk, reset, load, activation, row1_val, row2_val, row3_val, row4_val);
   
   input logic clk;
   input logic reset;
   input logic load;
   input logic [7:0] activation [15:0];
   output logic [7:0] row1_val;
   output logic [7:0] row2_val;
   output logic [7:0] row3_val;
   output logic [7:0] row4_val;
   

   logic [7:0]        shift_row_1_wires [6:0];
   logic [7:0]        shift_row_2_wires [6:0];
   logic [7:0]        shift_row_3_wires [6:0];
   logic [7:0]        shift_row_4_wires [6:0];
   assign row1_val = shift_row_1_wires[6];
   assign row2_val = shift_row_2_wires[6];
   assign row3_val = shift_row_3_wires[6];
   assign row4_val = shift_row_4_wires[6];
   
   


   
   // Row 1
   ShiftReg first_row_shr(clk, reset, load, 0, 0, shift_row_1_wires[0]);

   // Row 2
   ShiftReg second_row_shr1(clk, reset, load, 0, 0, shift_row_2_wires[0]);
   ShiftReg second_row_shr2(clk, reset, load, 0, 0, shift_row_2_wires[1]);

   // Row 3
   ShiftReg third_row_shr1(clk, reset, load, 0, 0, shift_row_3_wires[0]);
   generate
      genvar i;
      for(i = 1; i < 7; i++) begin
         if(i > 2) ShiftReg shr(clk, reset, load, activation[i-3], shift_row_1_wires[i-1], shift_row_1_wires[i]);
         else ShiftReg shr(clk, reset, load,0,shift_row_1_wires[i-1], shift_row_1_wires[i]);
      end
   endgenerate;

   
   generate
      genvar j;
      for(j = 2; j < 7; j++) begin
         if (j < 6) ShiftReg shr (clk, reset, load, activation[4+(j-2)], shift_row_2_wires[j-1], shift_row_2_wires[j]);
         else ShiftReg shr(clk, reset, load, 0, shift_row_2_wires[j-1], shift_row_2_wires[j]);
      end
   endgenerate;

   generate
      genvar k;
      for(k = 1; k < 7; k++) begin
         if (k < 5) ShiftReg shr (clk, reset, load, activation[9+(k-3)], shift_row_3_wires[k-1], shift_row_3_wires[k]);
         else ShiftReg shr(clk, reset, load, 0, shift_row_3_wires[k-1], shift_row_3_wires[k]);
      end
   endgenerate;

   generate
      genvar l;
      for(l = 0; l < 7; l++) begin
         if (l < 4) ShiftReg shr (clk, reset, load, activation[14+(l-3)], shift_row_4_wires[l-1], shift_row_4_wires[l]);
         else ShiftReg shr(clk, reset, load, 0, shift_row_4_wires[l-1], shift_row_4_wires[l]);
      end
   endgenerate;
  

   



   


   
   
   

endmodule; // ShiftBuffer
