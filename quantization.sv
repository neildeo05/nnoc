module quantization (
	input logic [31:0] inputFP,
	input logic [31:0] scale,
	output logic [7:0] outputInt8,
	output logic [31:0] scaledFp32
);
	// fpToInt8: Input a floating point 32-bit number, and output a scaled int8 number that represents this quantity.
	// Need to find the range of numbers in the dataset and then scale accordingly.
	// Scale Equation: int8 = Clip(Round(fp32/scale))
	// amax = max(abs(fp32)), scale = (2*amax)/256
	// Cool Syntax: |V = all of the bits in V or'd together.
	// int8 = clip(round(fp32/scale))
	
	logic [31:0] scaledFp;
	byte j, temp;
	logic [9:0] cvrtInt;
	logic [23:0] manScale;
	
	
	fdiv d0(.var1(inputFP), .var2(scale), .result(scaledFp));
	
	assign scaledFp32 = scaledFp;
	
	always_comb begin
		cvrtInt = 10'b0000000001;
		manScale = scaledFp[22:0];
		temp = signed'(scaledFp[30:23]-127);
		for(j = 0; j < 7; j++) begin
			if (j >= temp) begin
				j = 8;
			end
			else begin
				cvrtInt = cvrtInt << 1;
				cvrtInt[0] = manScale[22];
				manScale = manScale << 1;
			end
		end
		if (signed'(cvrtInt) > 127) begin
			cvrtInt = 10'b0001111111;
		end else if (signed'(cvrtInt) < -128) begin
			cvrtInt = 10'b1110000000;
		end
		outputInt8 = cvrtInt[7:0];
		//outputInt8 = scaledFp[31] ? outputInt8*-1 : outputInt8;
	end
	
endmodule

module fdiv (
	input [31:0] var1,
	input [31:0] var2,
	output [31:0] result
);

	logic [31:0] in1;
	logic [31:0] in2;
	logic [31:0] out;
	assign in1 = var1;
	assign in2 = var2;
	

	logic [7:0] exp1;
	assign exp1 = in1[30:23];
	logic [7:0] exp2;
	assign exp2 = in2[30:23];
	logic nAn;	
	int i;
	logic [23:0] t;
	logic [22:0] mantissa;

	logic [23:0] mantissa1;
	assign mantissa1 = in1 == 32'b0 ? 23'b0 : {1'b1, in1[22:0]};
	logic [23:0] mantissa2; 
	assign mantissa2 = {1'b1, in2[22:0]};
	assign nAn = in2 == 32'b0 ? 1'b1 : 1'b0;
	logic [23:0] mantissaProd;
	logic [7:0] expC;
	logic signF;
	always_comb begin
		t = 24'b0;
		mantissaProd = 24'b0;
		signF = in1[31] ^ in2[31];
		expC = (exp1) - (exp2) + 8'b01111111;
		for (i = 0; i < 24; i++) begin // division
			t = mantissa1-mantissa2;
			if (signed'(t) >= 0) begin
				mantissaProd[0] = 1'b1;
				mantissa1 = t;
			end 
			mantissa1 = mantissa1 << 1;
			mantissaProd = mantissaProd << 1;
		end
		mantissaProd = mantissaProd << 1;
		for (i = 0; i < 24; i++) begin //do this routine a max of 23 times in case the answer is zero
			if (mantissaProd[23] == 1'b1) begin // if we have encountered a one we are done bc we can make the final silent bit
				i = 23; 
			end
			else begin // if we haven't encountered a one then we have to continue left shifting to find a one for the silent bit.
				mantissaProd = mantissaProd << 1;
			end
		end
		mantissaProd = mantissaProd << 1;
		//expC = expC - 1;
		$display("%b", {signF, expC, mantissaProd[23:1]});
	end
	assign result = nAn ? 32'h7FC00000 : {signF, expC, mantissaProd[23:1]};
endmodule
