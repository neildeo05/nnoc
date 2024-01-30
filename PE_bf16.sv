module PE_bf16 (clk, reset, load, i_weight, i_north, i_west, o_south, o_east);
   input logic clk;
   input logic reset;
   input logic load;
   input logic [15:0] i_weight;
   input logic [31:0] i_north;
   input logic [15:0] i_west;

   output logic [15:0] o_east;
   output logic [31:0] o_south;
   
   reg [15:0]          weight;
   reg [15:0]          east_ff;
   // These are the 32 bit values
   reg [31:0]          south_ff;

   reg [31:0]          fma_value;

   FMA fma_unit(
       .a(i_west), 
       .b(weight),
       .c(i_north), 
       .out(fma_value));
   
                   

   always_ff @(posedge clk) begin
      if (reset) begin
         east_ff <= 0;
         south_ff <= 0;
      end
      else begin
         if(load) weight <= i_weight;
         else begin
            east_ff <= i_west;
            south_ff <= fma_value;
         end
      end
   end // always_ff @ (posedge clk)
   assign o_east = east_ff;
   assign o_south = south_ff;
   
      

   
endmodule; // PE_bf16
