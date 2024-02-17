module fpToInt8 (
	input logic [31:0] inputFP,
	input logic [31:0] amax,
	output logic [7:0] outputInt8
);
	// fpToInt8: Input a floating point 32-bit number, and output a scaled int8 number that represents this quantity.
	// Need to find the range of numbers in the dataset and then scale accordingly.
	// Scale Equation: int8 = Clip(Round(fp32/scale))
	// amax = max(abs(fp32)), scale = (2*amax)/256
	// Cool Syntax: |V = all of the bits in V or'd together.
	
	logic [31:0] scale; 
	logic [31:0] scaleI; 
	logic [31:0] scale1;
	
	assign scale1 = 01000000000000000000000000000000; // allegedly 2.0 in fp32 (check pls)
	fmul m0(amax, scale1, scaleI);
	logic [31:0] divisor;
	assign divisor = 00111011100000000000000000000000;// TODO: fill with fp representation of 1/256
	fmul m1(scaleI, divisor, scale);
	
	logic [7:0] int8Rep;
	logic [7:0] expBits;
	logic [22:0] mantissaBits;
	logic [31:0] bigInt;
	logic [31:0] scaledFP;
	int exp;
	
	// can you find the reciprocal of a floating point number by 2's comp-ing the exponent bits
	//fdiv d0(inputFP, scale, scaledFP);
	scale = {scale[31], (~scale[30:23])+1, scale[22:0]};
	fmul m2(inputFP, scale, scaledFP);
	
	assign  expBits = scaledFP[30:23];
	assign mantissaBits = scaledFP[22:0];

	// aim of this portion of code
	// this is the round function, need to take fp number and only find the int part.
	always @(*) begin
		exp = expBits - 127;
		if(exp < 0) begin
			int8Rep = 8'b0;
		end
		else if (exp > 8) begin
			if(inputFP[31]) begin
				int8Rep = 8'b11111111;
			end else begin
				int8Rep = 8'b01111111;
			end
		end
		bigInt = 32'b01; //set it equal to ghost 1
		while (exp != 0) begin
			bigInt = bigInt << 1;
			bigInt[0] = mantissa[22];
			mantissaBits = mantissaBits << 1;
			exp--;
		end
		int8Rep = bigInt[7:0]; // should be no overflow bc of exponent logic preceding the while loop.
		if(inputFP[31]) begin // make sure the number isn't negative
			int8Rep = ~int8Rep + 1'b1;
		end
	end
	
	outputInt8 = int8Rep;
	
endmodule

module fmul (
	input [31:0] var1,
	input [31:0] var2,
	output [31:0] res
);

	logic [31:0] in1;
	logic [31:0] in2;
	logic [31:0] out;
	in1 = var1;
	in2 = var2;
	

	logic [7:0] exp1;
	exp1 = in1[30:23];
	logic [7:0] exp2;
	exp2 = in2[30:23]

	logic [23:0] mantissa1;
	mantissa1 = {1, in1[22:0]};
	logic [23:0] mantissa2; 
	mantissa2 = {1, in2[22:0]};
	logic [24:0] mantissaProd;
	logic expC [7:0];
	logic signF;
	always @ (*) begin
		signF = in1[31] ^ in2[31];
		expC = (exp1 - 8b'01111111) + (exp2 - 8b'01111111) + 8b'01111111;
		mantissaProd = mantissa1*mantissa2;
		if(mantissaProd[24] == 1) begin
			mantissaProd >> 1;
			expC = expC + 1'b1;
		end
		res = {signF, expC, mantissaProd[22:0]};
	end

endmodule

module fdiv (
	input [31:0] var1,
	input [31:0] var2,
	output [31:0] res
);

	logic [31:0] in1;
	logic [31:0] in2;
	logic [31:0] out;
	assign in1 = var1;
	assign in2 = var2;
	

	logic [7:0] exp1;
	assign exp1 = in1[30:23];
	logic [7:0] exp2;
	assign exp2 = in2[30:23]

	logic [23:0] mantissa1;
	assign mantissa1 = {1, in1[22:0]};
	logic [23:0] mantissa2; 
	assign mantissa2 = {1, in2[22:0]};
	logic [24:0] mantissaProd;
	logic expC [7:0];
	logic signF;
	always @ (*) begin
		signF = in1[31] ^ in2[31];
		expC = (exp1 - 8b'01111111) - (exp2 - 8b'01111111) + 8b'01111111;
		mantissaProd = mantissa1/mantissa2;
		if(mantissaProd[24] == 1) begin
			mantissaProd >> 1;
			expC = expC + 1'b1;
		end
		res = {signF, expC, mantissaProd[22:0]};
	end
	
endmodule
