// NOTE: This kinda works but not in the way I expected
// Also I don't think signed numbers work
//TODO: Fixed signed number implementation
// Also there are some issues (could be massive)
module FMA (a, b, c, out, mul_out);
   input logic [15:0] a;
   input logic [15:0] b;
   input logic [31:0] c;
   output logic [31:0] out;
   output logic [31:0]        mul_out;

   logic signed [23:0]        addendMant;
   logic signed [23:0]        mulOutMant;
   logic [7:0]         addendExp;
   logic [7:0]         mulOutExp;
   logic [7:0]         biggerExp;
   logic signed [23:0]        finalMant;
   
   
   assign addendExp = c[30:23] ;
   

   FMul multiplier(a, b, mul_out);
   
   always_comb begin
      addendMant = {1'b1, c[22:0]};
      mulOutExp = mul_out[30:23];
      mulOutMant = {1'b1, mul_out[22:0]};
      if (mulOutExp < addendExp) biggerExp = addendExp;
      else biggerExp = mulOutExp;
      //biggerExp becomes the initial exponent of the sum
      addendMant = (addendMant >> (signed'(biggerExp - addendExp))) ;
      
      mulOutMant = (mulOutMant >> (signed'(biggerExp - mulOutExp)));
      if (c[31]) addendMant[23] = 1;
      if (mul_out[31]) mulOutMant[23] = 1;
      finalMant = signed'(addendMant + mulOutMant);

      
      if (finalMant[21] == 1) begin
         finalMant = finalMant << 1;
      end
      else begin
         if (finalMant[22] == 0 && finalMant[21] == 0) begin
            if (!finalMant[23]) begin 
               finalMant = finalMant << 1;
            end
            else begin
               biggerExp = biggerExp + 1;
            end
            
            
         end
         else begin
            if (finalMant[23] == 1 && finalMant[22] == 1) begin
               finalMant = finalMant << 1;
               finalMant = finalMant + 1;
            end
            else biggerExp = biggerExp + 1;
            
         end
      end
      
      
      
      out[31] = 0;
      out[30:23] = biggerExp;
      out[22:0] = finalMant[23:1];
//      $display("%b\n", out);
      
      

   end
   
endmodule; // FMA
