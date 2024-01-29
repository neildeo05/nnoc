module PE_int8 (clk, reset, load, i_weight, i_north, i_west, o_south, o_east);

   input logic clk;
   input logic reset;
   input logic load;
   input logic [7:0] i_weight;
   input logic [31:0] i_north;
   input logic [7:0] i_west;

   output logic [7:0] o_east;
   // These are the 32 bit values
   output logic [31:0] o_south;


   reg [7:0]          weight;
   reg [7:0]          east_ff;
   // These are the 32 bit values
   reg [31:0]          south_ff;


   always_ff @(posedge clk) begin
      if (reset) begin
         east_ff <= 0;
         south_ff <= 0;
      end
      else begin
         if(load) weight <= i_weight;
         else begin
            east_ff <= i_west;
            south_ff <= (weight * i_west) + i_north;
         end;
      end
   end
   assign o_east = east_ff;
   assign o_south = south_ff;



endmodule; // PE
