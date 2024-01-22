// BFloat16 Multiply-Accumulate into Float32


module FPMulacc (a, b,c, out);
   input logic [15:0] a;
   input logic [15:0] b;
   input logic [15:0] c;
   output logic [31:0] out;

   logic        sign_a;
   logic        exp_a;
   logic        mts_a;
   logic        sign_b;
   logic        exp_b;
   logic        mts_b;
   assign sign_a = a[15];
   assign sign_b = b[15];
   assign exp_a = a[14:7];
   assign exp_b = b[14:7];
   assign mts_a = a[6:0];
   assign mts_b = b[6:0];
   
   always_comb begin
      // Multiply is:
      // 1. Xor sign bits
      // 2. Add and renormalize exponents
      // 3. Multiply mantissas with implicit one re-added

      

      

      // Accumulate is:

   end;
   


   
endmodule; // FPMulacc

