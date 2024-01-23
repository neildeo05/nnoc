// BFloat16 Multiply-Accumulate into Float32

// Given a bfloat16 a, a bfloat16 b, and a float32 c, multiply the bfloats accumulate with c into a float32 out

module FPMulacc (a, b,c, out);
   input logic [15:0] a;
   input logic [15:0] b;
   input logic [31:0] c;
   output logic [31:0] out;

   logic        sign_a;
   logic [7:0]  exp_a;
   logic [7:0]  mts_a;
   logic        sign_b;
   logic [7:0]  exp_b;
   logic [7:0]  mts_b;

   logic [31:0] mul_out;
   
   assign sign_a = a[15];
   assign sign_b = b[15];
   assign exp_a = a[14:7];
   assign exp_b = b[14:7];
   assign mts_a[6:0] = a[6:0];
   assign mts_b[6:0] = b[6:0];
   assign mts_a[7] = 1'b1;
   assign mts_b[7] = 1'b1;
   
   
   always_comb begin
      // Multiply is:
      // 1. Xor sign bits
      // 2. Add exponents
      // 3. Multiply mantissas with implicit one re-added
      mul_out[31] = sign_a ^ sign_b;
      // Result Exponent = (Exponent A + Exponent B) - 127
      mul_out[30:23] = (exp_a + exp_b) - 127;
      mul_out[22:15] = mts_a * mts_b;
      
      
   end;
   


   
endmodule; // FPMulacc

