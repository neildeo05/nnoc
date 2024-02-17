module ShiftReg #(parameter WIDTH = 8) (clk, reset, load, pload, shin, out);
   input logic clk;
   input logic reset;
   input logic load;
   
   input logic [WIDTH-1:0] pload;
   input logic [WIDTH-1:0] shin;
   logic [WIDTH-1:0]       curr;
   
   output logic [WIDTH-1:0] out;
   


   always_ff @(posedge clk) begin
      if(reset) begin
         curr <= 0;
      end
      
      else begin
         if(load) begin
            curr <= pload;
            
         end
         else begin
            curr <= shin;
         end
         
      end
      
      
   end
   assign out = curr;
   
   
endmodule; // ShiftReg

   
