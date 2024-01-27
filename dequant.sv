// TODO: Need to verify some of this works (mul, cvrt) and then this is a final code.
module dequant (
	input logic [7:0] int8Num,
	input logic [31:0] amax, //given through software
	input logic [31:0] scale, // given through software
	output logic [31:0] outputFP
);

	logic sign;
	logic [7:0] ex1;
	logic [22:0] mantissa;
	int i;
	logic [31:0] int8FPd;
	logic [23:0] newMant1;
	logic [23:0] newMant2;
	logic [47:0] newMantProds;
	
	// Steps to dequantize the number
	// Take the scale factor and multiply input int8 number by it
	// This entails first converting the int8 number into fp  - most likely source of error as I have cooked a weird algorithm.
	// Then you do the mul between the scale factor and the converted int8 num. 
	// This should give you a floating point number that is scaled back
	
	always_comb begin // change to always @ (*) if sv gives u a hard time
		mantissa[22:15] = int8Num;
		i = 8;
		sign = 1'b0;
		ex1 = 8'b01111111;
		// first, plop int8 number in front of floating point 
		// then, adjust till the hidden bit is one
		// adjust the exponent accordingly
		// adjustment is done
		while (i > 0 && numB4[7] == 1'b0) begin // Maybe expand code out to do every single shift manually rather than use a while loop?
			i--;
			mantissa = mantissa << 1;
		end
		mantissa = mantissa << 1;
		ex1 = ex1 + i + 1;
		// Now that int8 has been converted to fp, let's mul by scale and be on our way
		sign = sign ^ scale[31];
		ex1 = ex1+scale[30:23] - 8'b01111111;
		mantissa = mantissa * scale[22:0]; // get absolutely multiplied
		newMant1 = {1'b1, mantissa};
		newMant2 = {1'b1, scale[22:0]};
		newMantProds = newMant1 * newMant2;
		mantissa = newMantProds[47:25]; // the rest of the bits of the mul will be used for preserving precision
		i = 0;
		while (i < 23 && mantissa[22] == 1'b0) begin
			mantissa = mantissa << 1
			mantissa[0] = newMantProds[24];
			newMantProds = newMantProds << 1;
			ex1++;
			i++;
		end
		mantissa = mantissa << 1;
		ex1 = ex1+1;
		mantissa[0] = newMantProds[24];
		outputFP = {sign, ex1, mantissa};
	end

endmodule