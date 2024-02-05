module dequant (
	int8Num,
	scale,
	outputFP
);
	reg _sv2v_0;
	input wire [7:0] int8Num;
	input wire [31:0] scale;
	output reg [31:0] outputFP;
	reg sign;
	reg [7:0] ex1;
	reg [22:0] mantissa;
	reg signed [31:0] i;
	reg [23:0] newMant1;
	reg [23:0] newMant2;
	reg [47:0] newMantProds;
	always @(*) begin
		if (_sv2v_0)
			;
		mantissa[22:15] = int8Num;
		mantissa[14:0] = 15'b000000000000000;
		i = 8;
		sign = 1'b0;
		ex1 = 8'b01111111;
		newMant1 = 24'h000000;
		newMant2 = 24'h000000;
		newMantProds = 48'h000000000000;
		ex1 = ex1 + 8;
		for (i = 0; i < 8; i = i + 1)
			if (mantissa[22] == 1'b1)
				i = 8;
			else begin
				mantissa = mantissa << 1;
				ex1 = ex1 - 1;
			end
		mantissa = mantissa << 1;
		ex1 = ex1 - 1;
		sign = sign ^ scale[31];
		ex1 = (ex1 + scale[30:23]) - 8'b01111111;
		newMant1 = {1'b1, mantissa};
		newMant2 = {1'b1, scale[22:0]};
		newMantProds = newMant1 * newMant2;
		mantissa = newMantProds[47:25];
		i = 0;
		for (i = 0; i < 23; i = i + 1)
			if (mantissa[22] == 1'b1)
				i = 23;
			else begin
				mantissa = mantissa << 1;
				mantissa[0] = newMantProds[24];
				newMantProds = newMantProds << 1;
				ex1 = ex1 - 1;
			end
		mantissa = mantissa << 1;
		ex1 = ex1 + 1;
		mantissa[0] = newMantProds[24];
		outputFP = {sign, ex1, mantissa};
	end
	initial _sv2v_0 = 0;
endmodule
