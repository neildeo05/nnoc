module TileFIFO #(parameter MAX_INPUT_TILES = 4, parameter WIDTH = 16) (clk, reset, read, write, in, out, full);
   input logic clk;
   input logic reset;
   input logic read;
   input logic write;
   input logic [WIDTH-1:0] in;
   output logic [WIDTH-1:0] out;
   output logic             full;


   logic [$clog2(MAX_INPUT_TILES) - 1: 0] read_pointer;
   logic [$clog2(MAX_INPUT_TILES) - 1: 0] write_pointer;
   logic [WIDTH-1:0]                      fifo [MAX_INPUT_TILES-1:0];
   
   
   
   

   

endmodule; // TileFifo
