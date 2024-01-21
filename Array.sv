module Array (clk, reset, load, weights, row1_val, row2_val, row3_val, row4_val, result_buffer);
   input logic clk;
   input logic load;
   input logic reset;
   

   input logic [7:0] weights [3:0][3:0]; // Weight input

   wire [31:0]	      col_interconnects [4:0] [3:0];
   output logic [31:0] result_buffer [3:0];
   wire [7:0]	      row1 [4:0];
   wire [7:0]	      row2 [4:0];
   wire [7:0]	      row3 [4:0];
   wire [7:0]	      row4 [4:0];
   
   
   input reg [7:0]    row1_val;
   input reg [7:0]    row2_val;
   input reg [7:0]    row3_val;
   input reg [7:0]    row4_val;
 
   
 
   
   
   
   assign row1[0] = row1_val;
   assign row2[0] = row2_val;
   assign row3[0] = row3_val;
   assign row4[0] = row4_val;
  
 
   
   generate
      genvar i;
      for (i = 0; i < 4; i++) begin
  PE pe(.clk(clk),
        .reset(reset),
        .load(load),
        .i_weight(weights[0][i]),
     // why we call it i right if it comes from left idk
        .i_west(row1[i]),
        .o_east(row1[i+1]),
 	.i_north(col_interconnects[i][0]),
        .o_south(col_interconnects[i][1])
        );
      end;
      
   endgenerate;
   
 
    generate
       genvar j;
       for (j = 0; j < 4; j++) begin
 	 PE pe(.clk(clk),
               .reset(reset),
 	       .load(load),
 	       .i_weight(weights[1][j]),
 	
 	       .i_west(row2[j]),
 	       .o_east(row2[j+1]),
 		.i_north(col_interconnects[j][1]),
 	       .o_south(col_interconnects[j][2])
 	       );
       end;
       
    endgenerate;
 
 
    generate
       genvar k;
       for (k = 0; k < 4; k++) begin
 	 PE pe(.clk(clk),
               .reset(reset),
 	       .load(load),
 	       .i_weight(weights[2][k]),
 	
 	       .i_west(row3[k]),
 	       .o_east(row3[k+1]),
 		.i_north(col_interconnects[k][2]),
 	       .o_south(col_interconnects[k][3])
 	       );
       end;
       
    endgenerate;
   
    generate
       genvar l;
       for (l = 0; l < 4; l++) begin
 	 PE pe(.clk(clk),
               .reset(reset),
 	       .load(load),
 	       .i_weight(weights[3][l]),
 	
 	       .i_west(row4[l]),
 	       .o_east(row4[l+1]),
 	       .i_north(col_interconnects[l][3]),
 	       .o_south(result_buffer[l])
 	       );
          
       end;
       
    endgenerate;
 
 
    
endmodule; // Array
