// BFloat16 Multiply

      //TODO: Normalize in case of overflow
      //Round the mantissa to fit into the 23-bit mantissa field of the float32 format. Use an appropriate rounding method, typically round-to-nearest.
      //TODO: Handle subnormal and infinity/NaNs

module FMul (a, b,mul_out);
   // Multiplies two BF16s (Technically FPAlt from FPNew)
   // Converts it into a FP32
   // Accumulates into a FP32
   // Converts back to a BF16 using Fast RNE (from Eigen)
   input logic [15:0] a;
   input logic [15:0] b;
   
   logic sign_a;
   logic sign_b;
   logic sign_product;
   assign sign_a = a[15];
   assign sign_b = b[15];
   assign sign_product = sign_a ^ sign_b;
   
/*
   logic signed [8:0] exponent_a;
   logic signed [8:0] exponent_b;
   logic signed [8:0] exponent_product;
   assign exponent_a = signed'({1'b0, a[14:7]});
   assign exponent_b = signed'({1'b0, b[14:7]});
   assign exponent_product = signed'(((exponent_a + exponent_b) - 127));
 */
   logic [7:0] exponent_a;
   logic [7:0] exponent_b;
   logic [7:0] exponent_product;
   assign exponent_a = a[14:7];
   assign exponent_b = b[14:7];
   // If we shift once, we have to add 1 (makes sense)
   // If we shift twice, we don't have to add anything????
   // TODO: Figure out this stuff

   logic [7:0] man_a;
   logic [7:0] man_b;
   logic [15:0] man_product;
   output logic [31:0] mul_out;

   assign man_a = {1'b1, a[6:0]};
   assign man_b = {1'b1, b[6:0]};
   //HACK: This is a terrible hack, but for some reason it works (because of the range of values we get). This terrible logic ensures that this isn't exactly a floating point multiply unit at all. Once this is fixed, it will be much better
   //TODO: Subnormal, Correct normalization, NaN, Infinity
   always_comb begin
      exponent_product = ((exponent_a + exponent_b) - 127);
      man_product = man_a * man_b;
      if (man_product[15] == 1) begin
         man_product = man_product << 1;
         exponent_product = exponent_product + 1;
      end
      else if (man_product[14] == 1) begin
         man_product = man_product << 2;
      end
   end
   
   assign mul_out[31] = sign_product;
   assign mul_out[30:23] = exponent_product[7:0];
   assign mul_out[22:7] = man_product;
   assign mul_out[6:0] = 7'b0;


   
   
endmodule; // FMul
