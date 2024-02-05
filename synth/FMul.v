module FMul (
	a,
	b,
	mul_out
);
	reg _sv2v_0;
	input wire [15:0] a;
	input wire [15:0] b;
	wire sign_a;
	wire sign_b;
	wire sign_product;
	assign sign_a = a[15];
	assign sign_b = b[15];
	assign sign_product = sign_a ^ sign_b;
	wire [7:0] exponent_a;
	wire [7:0] exponent_b;
	reg [7:0] exponent_product;
	assign exponent_a = a[14:7];
	assign exponent_b = b[14:7];
	wire [7:0] man_a;
	wire [7:0] man_b;
	reg [15:0] man_product;
	output wire [31:0] mul_out;
	assign man_a = {1'b1, a[6:0]};
	assign man_b = {1'b1, b[6:0]};
	always @(*) begin
		if (_sv2v_0)
			;
		exponent_product = (exponent_a + exponent_b) - 127;
		man_product = man_a * man_b;
		if ((exponent_a == 0) | (exponent_b == 0)) begin
			man_product = 16'b0000000000000000;
			exponent_product = 8'b00000000;
		end
		else if (man_product[15] == 1) begin
			man_product = man_product << 1;
			exponent_product = exponent_product + 1;
		end
		else if (man_product[14] == 1)
			man_product = man_product << 2;
	end
	assign mul_out[31] = sign_product;
	assign mul_out[30:23] = exponent_product[7:0];
	assign mul_out[22:7] = man_product;
	assign mul_out[6:0] = 7'b0000000;
	initial _sv2v_0 = 0;
endmodule
