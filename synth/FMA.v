module FMA (
	a,
	b,
	c,
	out,
	mul_out
);
	reg _sv2v_0;
	input wire [15:0] a;
	input wire [15:0] b;
	input wire [31:0] c;
	output reg [31:0] out;
	output wire [31:0] mul_out;
	reg [7:0] mulExp;
	reg [7:0] addExp;
	reg [23:0] mulMant;
	reg [23:0] addMant;
	reg [7:0] finalExp;
	reg [24:0] sumMants;
	reg [23:0] finalMant;
	reg signed [31:0] i;
	reg finalSign;
	reg largerMag;
	FMul multiplier(
		.a(a),
		.b(b),
		.mul_out(mul_out)
	);
	always @(*) begin
		if (_sv2v_0)
			;
		finalSign = 1'b0;
		mulExp = mul_out[30:23];
		addExp = c[30:23];
		mulMant = {1'b1, mul_out[22:0]};
		addMant = {1'b1, c[22:0]};
		if (mulExp < addExp) begin
			finalExp = addExp;
			mulMant = mulMant >> (finalExp - mulExp);
			largerMag = 1'b1;
		end
		else if (addExp < mulExp) begin
			finalExp = mulExp;
			addMant = addMant >> (finalExp - addExp);
			largerMag = 1'b0;
		end
		else begin
			finalExp = mulExp;
			if (addMant > mulMant)
				largerMag = 1'b1;
			else
				largerMag = 1'b0;
		end
		if ((mul_out[31] == 1'b1) && (c[31] == 1'b1)) begin
			sumMants = addMant + mulMant;
			finalSign = 1'b0;
			finalMant = sumMants[24:1];
			finalExp = finalExp + 1;
		end
		else if ((mul_out[31] == 1'b1) && (c[31] == 1'b0)) begin
			sumMants = mulMant - addMant;
			finalSign = (largerMag ? 1'b1 : 1'b0);
			finalMant = sumMants[23:0];
			finalMant = (sumMants[24] ? finalMant * -1 : finalMant);
		end
		else if ((mul_out[31] == 1'b0) && (c[31] == 1'b1)) begin
			sumMants = addMant - mulMant;
			finalSign = (largerMag ? 1'b0 : 1'b1);
			finalMant = sumMants[23:0];
			finalMant = (sumMants[24] ? finalMant * -1 : finalMant);
		end
		else begin
			sumMants = addMant + mulMant;
			finalSign = 1'b1;
			finalMant = sumMants[24:1];
			finalExp = finalExp + 1;
		end
		for (i = 0; i < 23; i = i + 1)
			if (finalMant[23] == 1'b1)
				i = 23;
			else begin
				finalMant = finalMant << 1;
				finalExp = finalExp - 1;
			end
		finalMant = finalMant << 1;
		if ((mul_out == 0) && (addExp == 0)) begin
			finalMant = 24'b000000000000000000000000;
			finalExp = 8'b00000000;
		end
		out = {~finalSign, finalExp, finalMant[23:1]};
	end
	initial _sv2v_0 = 0;
endmodule
