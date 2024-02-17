module TileFIFO #(parameter MAX_INPUT_TILES = 4, parameter WIDTH = 16) (clk, reset, read, write, in, out, full, empty);
   input logic clk;
   input logic reset;
   input logic read;
   input logic write;
   input logic [(WIDTH*16)-1:0] in;
   output logic                 full;
   output logic                 empty;
   
   output logic [(16*WIDTH)-1:0] out;


   logic [$clog2(MAX_INPUT_TILES)-1: 0] read_pointer;
   logic [$clog2(MAX_INPUT_TILES)-1: 0] write_pointer;
   logic [31:0]                         total_count;
   logic [(16*WIDTH)-1:0]               fifo [MAX_INPUT_TILES-1:0];
   
   always @(posedge clk) begin
      if (reset) begin
         total_count <= 0;
         read_pointer <= 0;
         out <= 0;
         write_pointer <= 0;
      end
      else if (write) begin
         if (!full) begin
            write_pointer <= write_pointer + 1;
            fifo[write_pointer] <= in;
            total_count <= total_count+1;
         end
      end
      else if (read) begin
         if(!empty) begin
            out <= fifo[read_pointer];
            read_pointer <= read_pointer + 1;
            total_count <= total_count - 1;
         end
      end
      if (total_count == MAX_INPUT_TILES) full <= 1'b1;
      if (total_count == 0) empty <= 1'b1;
   end
endmodule; // TileFifo
