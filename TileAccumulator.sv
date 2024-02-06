module TileAccumulator #(parameter WIDTH=16, parameter MAX_INPUT_TILES = 4) (clk, reset, act_load, num_input_tiles, activation_input, ready);

   input logic clk;
   input logic reset;
   output logic act_load;
   input logic [3:0] num_input_tiles;
   input logic [WIDTH-1:0] activation_input [15:0];
   

   /*
    Collect inputs in a tile queue while act_load is low
    When act_load is low, push from queue to accumulator
    When done accumulating, set act_load high
    */


   
endmodule; // TileAccumulator 
