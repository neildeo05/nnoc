module quantization (
	input logic [31:0] inputFP,
	input logic [31:0] scale_inv,
	output logic [7:0] outputInt8,
	output logic [31:0] scaledFp32
);
	// fpToInt8: Input a floating point 32-bit number, and output a scaled int8 number that represents this quantity.
	// Need to find the range of numbers in the dataset and then scale accordingly.
	// Scale Equation: int8 = Clip(Round(fp32/scale))
	// amax = max(abs(fp32)), scale = (2*amax)/256
	// Cool Syntax: |V = all of the bits in V or'd together.
	// int8 = clip(round(fp32/scale))
	// Getting scale as the inverse value (hardware cost too high).
	
	logic [31:0] scaledFp;
	byte j, temp;
	logic [9:0] cvrtInt;
	logic [22:0] manScale;
	
	
	//   fdiv d0(.var1(inputFP), .var2(scale), .result(scaledFp));
	//FMA f0(inputFP, scale_inv, 32'b0, scaledFp32, scaledFp);
	fp32mul fp0(inputFP, scale_inv, scaledFp);
	
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


// Here lies a broken FDiv implementation
// It works for select numbers
// Something is wrong with the combination of left shifting and exponent adding
module fdiv (
	input [31:0] var1,
	input [31:0] var2,
	output [31:0] result
);

	logic [31:0] in1;
	logic [31:0] in2;
	assign in1 = var1;
	assign in2 = var2;
	

	logic [7:0] exp1;
	assign exp1 = in1[30:23];
	logic [7:0] exp2;
	assign exp2 = in2[30:23];
	logic nAn;	
	int i;
	logic [23:0] t;
	logic [23:0] mantissa1;
	logic [23:0] mantissa2; 
	assign mantissa2 = {1'b1, in2[22:0]};
	assign nAn = in2 == 32'b0 ? 1'b1 : 1'b0;
	logic [23:0] mantissaProd;
	logic [23:0] mantissaRema;
	logic [7:0] expC;
	logic signF;
	always_comb begin
	
		mantissa1 = in1 == 32'b0 ? 24'b0 : {1'b1, in1[22:0]};
		t = 24'b0;
		mantissaProd = 24'b0;
		mantissaRema = 24'b0;
		signF = in1[31] ^ in2[31];
		expC = (exp1) - (exp2) + 8'b01111111;
		for (i = 23; i < 0; i--) begin // division
			if (nAn == 1'b1) begin
				break;
			end
			t = mantissa1-mantissa2;
			if (signed'(t) >= 24'b0) begin
				mantissaProd[0] = 1'b1;
				mantissa1 = t;
			end 
			mantissa1 = mantissa1 << 1;
			mantissaProd = mantissaProd << 1;
		end
		
		//mantissaProd = mantissaProd << 1;
		for (i = 0; i < 24; i++) begin //do this routine a max of 23 times in case the answer is zero
			if (mantissaProd[23] == 1'b1) begin // if we have encountered a one we are done bc we can make the final silent bit
				i = 24; 
			end
			else begin // if we haven't encountered a one then we have to continue left shifting to find a one for the silent bit.
				mantissaProd = mantissaProd << 1;
				expC = expC - 1;
			end
		end
		mantissaProd = mantissaProd << 1;
		expC = expC - 1; 
	end
	assign result = nAn ? 32'h7FC00000 : {signF, expC, mantissaProd[22:0]};
endmodule

module fp32mul (
	input logic [31:0] num1,
	input logic [31:0] num2,
	output logic [31:0] out_mul
);
	
	logic sign;
	logic [7:0] expF;
	logic [22:0] mantissa;
	logic [23:0] mantissa1, mantissa2;
	logic [47:0] mantissaProd;
	assign mantissa1 = {1'b1, num1[22:0]};
	assign mantissa2 = {1'b1, num2[22:0]};
	assign sign = num1[31] ^ num2[31];
	
	int i;
	
	always_comb begin
		mantissaProd = mantissa1*mantissa2;
		expF = (num1[30:23] + num2[30:23]) - 8'h7F;
		mantissa = mantissaProd[47:25];
		i = 0;
		for (i = 0; i < 23; i++) begin //do this routine a max of 23 times in case the answer is zero
			if (mantissa[22] == 1'b1) begin // if we have encountered a one we are done bc we can make the final silent bit
				i = 23; 
			end
			else begin // if we haven't encountered a one then we have to continue left shifting to find a one for the silent bit.
				mantissa = mantissa << 1;
				mantissa[0] = mantissaProd[24];
				mantissaProd = mantissaProd << 1;
				expF = expF-1;
			end
		end
		mantissa = mantissa << 1;
		expF = expF+1;
		mantissa[0] = mantissaProd[24];
		
		out_mul = {sign, expF, mantissa};
	end

endmodule
