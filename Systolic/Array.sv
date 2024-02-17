module Array #(parameter WIDTH=8, parameter ACCUMULATE=32)(clk, reset, load, weights, row1_val, row2_val, row3_val, row4_val, result_buffer);
   input logic clk;
   input logic load;
   input logic reset;
   

   input logic [WIDTH-1:0] weights [3:0][3:0]; // Weight input

   wire [ACCUMULATE-1:0]	      col_interconnects [4:0] [3:0];
   output logic [ACCUMULATE-1:0] result_buffer [3:0];
   wire [WIDTH-1:0]	      row1 [4:0];
   wire [WIDTH-1:0]	      row2 [4:0];
   wire [WIDTH-1:0]	      row3 [4:0];
   wire [WIDTH-1:0]	      row4 [4:0];
   
   
   input reg [WIDTH-1:0]    row1_val;
   input reg [WIDTH-1:0]    row2_val;
   input reg [WIDTH-1:0]    row3_val;
   input reg [WIDTH-1:0]    row4_val;
 
   
 
   
   
   
   assign row1[0] = row1_val;
   assign row2[0] = row2_val;
   assign row3[0] = row3_val;
   assign row4[0] = row4_val;
  
 
   
   generate
      genvar i;
      for (i = 0; i < 4; i++) begin
         if(WIDTH == 8) begin : gen_block_8bit
            PE_int8 pe(.clk(clk),
                       .reset(reset),
                       .load(load),
                       .i_weight(weights[0][i]),
                       .i_west(row1[i]),
                       .o_east(row1[i+1]),
 	               .i_north(col_interconnects[i][0]),
                       .o_south(col_interconnects[i][1])
                       );
         end
         else if (WIDTH == 16) begin : gen_block_16bit
            PE_bf16 pe(.clk(clk),
                       .reset(reset),
                       .load(load),
                       .i_weight(weights[0][i]),
                       .i_west(row1[i]),
                       .o_east(row1[i+1]),
 	               .i_north(col_interconnects[i][0]),
                       .o_south(col_interconnects[i][1])
                       );
         end;
         
      end // for (i = 0; i < 4; i++)
      
      
      
   endgenerate;
   
 
    generate
       genvar j;
       for (j = 0; j < 4; j++) begin
          if (WIDTH == 8) begin: gen_block_8bit
 	     PE_int8 pe(.clk(clk),
                        .reset(reset),
 	                .load(load),
 	                .i_weight(weights[1][j]),
 	                
 	                .i_west(row2[j]),
 	                .o_east(row2[j+1]),
 		        .i_north(col_interconnects[j][1]),
 	                .o_south(col_interconnects[j][2])
 	                );
          end // if (WIDTH == 8)
          else if (WIDTH == 16) begin: gen_block_16bit
 	     PE_bf16 pe(.clk(clk),
                        .reset(reset),
 	                .load(load),
 	                .i_weight(weights[1][j]),
 	                
 	                .i_west(row2[j]),
 	                .o_east(row2[j+1]),
 		        .i_north(col_interconnects[j][1]),
 	                .o_south(col_interconnects[j][2])
 	                );
          end
       end;
       
    endgenerate;
 
 
    generate
       genvar k;
       for (k = 0; k < 4; k++) begin
          if (WIDTH == 8) begin: gen_block_8bit
 	 PE_int8 pe(.clk(clk),
               .reset(reset),
 	       .load(load),
 	       .i_weight(weights[2][k]),
 	
 	       .i_west(row3[k]),
 	       .o_east(row3[k+1]),
 		.i_north(col_interconnects[k][2]),
 	       .o_south(col_interconnects[k][3])
 	       );
          end // if (WIDTH == 8)
          else if (WIDTH == 16) begin: gen_block_16bit
 	 PE_bf16 pe(.clk(clk),
               .reset(reset),
 	       .load(load),
 	       .i_weight(weights[2][k]),
 	
 	       .i_west(row3[k]),
 	       .o_east(row3[k+1]),
 		.i_north(col_interconnects[k][2]),
 	       .o_south(col_interconnects[k][3])
 	       );
          end
          
          
       end;
       
    endgenerate;
   
    generate
       genvar l;
       for (l = 0; l < 4; l++) begin
          if (WIDTH == 8) begin: gen_block_8bit
 	 PE_int8 pe(.clk(clk),
               .reset(reset),
 	       .load(load),
 	       .i_weight(weights[3][l]),
 	
 	       .i_west(row4[l]),
 	       .o_east(row4[l+1]),
 	       .i_north(col_interconnects[l][3]),
 	       .o_south(result_buffer[l])
 	       );
          end // if (WIDTH == 8)
          else if (WIDTH == 16) begin : gen_block_16bit
 	 PE_bf16 pe(.clk(clk),
               .reset(reset),
 	       .load(load),
 	       .i_weight(weights[3][l]),
 	
 	       .i_west(row4[l]),
 	       .o_east(row4[l+1]),
 	       .i_north(col_interconnects[l][3]),
 	       .o_south(result_buffer[l])
 	       );
          end
          
          
       end;
       
    endgenerate;
 
 
    
endmodule; // Array
