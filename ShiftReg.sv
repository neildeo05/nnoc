module ShiftReg (clk, reset, load, pload, shin, out);
   input logic clk;
   input logic reset;
   input logic load;
   
   input logic [7:0] pload;
   input logic [7:0] shin;
   logic [7:0]       curr;
   
   output logic [7:0] out;
   


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

   
