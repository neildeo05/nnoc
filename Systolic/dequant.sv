// TODO: Need to verify some of this works (mul, cvrt) and then this is a final code.
module dequant (
	int8Num,
	scale, // given through software
	outputFP
);
	input logic [7:0] int8Num;
	input logic [31:0] scale;
	output logic [31:0] outputFP;

	logic sign;
	logic [7:0] ex1;
	logic [22:0] mantissa;
	int i;
//	logic [31:0] int8FPd;
	logic [23:0] newMant1;
	logic [23:0] newMant2;
	logic [47:0] newMantProds;
	
	// Steps to dequantize the number
	// Take the scale factor and multiply input int8 number by it
	// This entails first converting the int8 number into fp  - most likely source of error as I have cooked a weird algorithm.
	// Then you do the mul between the scale factor and the converted int8 num. 
	// This should give you a floating point number that is scaled back
	
	always_comb 
	begin // change to always @ (*) if sv gives u a hard time
		mantissa[22:15] = int8Num;
		mantissa[14:0] = 15'b000000000000000;
		i = 8;
		sign = 1'b0;
		ex1 = 8'b01111111;
//		int8FPd = 32'h00000000;
		newMant1 = 24'h000000;
		newMant2 = 24'h000000;
		newMantProds = 48'h000000000000;

		// first, plop int8 number in front of floating point 
		// then, adjust till the hidden bit is one
		// adjust the exponent accordingly
		// adjustment is done
		ex1 = ex1 + 8;
		for (i = 0; i < 8; i++) begin
			if(mantissa[22] == 1'b1) begin // if we find a one in the msb then we're done and we can adjust for the hidden bit
				i = 8;
			end else begin // if we don't then we still need to adjust
				mantissa = mantissa << 1;
				ex1 = ex1 - 1;
			end
		end
		mantissa = mantissa << 1;
		ex1 = ex1 - 1;
		// Now that int8 has been converted to fp, let's mul by scale and be on our way
		sign = sign ^ scale[31];
		ex1 = ex1+scale[30:23] - 8'b01111111; 
		newMant1 = {1'b1, mantissa};
		newMant2 = {1'b1, scale[22:0]}; // get absolutely multiplied
		newMantProds = newMant1 * newMant2;
		mantissa = newMantProds[47:25]; // the rest of the bits of the mul will be used for preserving precision
		i = 0;
		for (i = 0; i < 23; i++) begin //do this routine a max of 23 times in case the answer is zero
			if (mantissa[22] == 1'b1) begin // if we have encountered a one we are done bc we can make the final silent bit
				i = 23; 
			end
			else begin // if we haven't encountered a one then we have to continue left shifting to find a one for the silent bit.
				mantissa = mantissa << 1;
				mantissa[0] = newMantProds[24];
				newMantProds = newMantProds << 1;
				ex1 = ex1-1;
			end
		end
		mantissa = mantissa << 1;
		ex1 = ex1+1;
		mantissa[0] = newMantProds[24];
		outputFP = {sign, ex1, mantissa};

	end

endmodule

//maybe something to consider (not really though its not ideal)
// for (i = 0; i > 8; i++) begin
// 	if (num4Shift[0] == 1'b1) begin
// 		placeholder = i;
// 	end
// 	mantissa[22] = num4shift[7];
// 	mantissa = mantissa >> 1;
// 	num4shift = num4shift >> 1; 
// end

//broken code pile
// while (i > 0 && numB4[7] == 1'b0) begin // Maybe expand code out to do every single shift manually rather than use a while loop?
// 			i--;
// 			mantissa = mantissa << 1;
// 		end
// 		mantissa = mantissa << 1;
// 		ex1 = ex1 + i + 1;
