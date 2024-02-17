
module TileAccumulator #(parameter WIDTH=16, parameter MAX_INPUT_TILES = 4) (clk, reset, act_load, num_input_tiles, activation_input, packed_act_inp);

   typedef logic [255:0] packed_t;
   input logic clk;
   input logic reset;
   input logic act_load;
   input logic [3:0] num_input_tiles;
   input logic [WIDTH-1:0] activation_input [15:0]; // send this input 
   output logic [(WIDTH*16)-1:0]  packed_act_inp ;
   logic [(WIDTH*16) - 1 : 0]     first_out_tile;
   logic                          full;
   logic                          empty;
   
   
   
   
   assign packed_act_inp = {activation_input[0], activation_input[1], activation_input[2], activation_input[3], activation_input[4], activation_input[5], activation_input[6], activation_input[7], activation_input[8], activation_input[9], activation_input[10], activation_input[11], activation_input[12], activation_input[13], activation_input[14], activation_input[15]};
   
   TileFIFO#(.MAX_INPUT_TILES(MAX_INPUT_TILES), .WIDTH(WIDTH)) tf (clk, reset, read, act_load, packed_act_inp, first_out_tile, full, empty);

   

   /*
    Collect inputs in a tile queue while act_load is low
    When act_load is low, push from queue to accumulator
    When done accumulating, set act_load high
    */


   
endmodule; // TileAccumulator 
