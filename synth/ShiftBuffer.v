module ShiftBuffer (
	clk,
	reset,
	load,
	activation,
	row1_val,
	row2_val,
	row3_val,
	row4_val
);
	parameter WIDTH = 8;
	input wire clk;
	input wire reset;
	input wire load;
	input wire [(16 * WIDTH) - 1:0] activation;
	output wire [WIDTH - 1:0] row1_val;
	output wire [WIDTH - 1:0] row2_val;
	output wire [WIDTH - 1:0] row3_val;
	output wire [WIDTH - 1:0] row4_val;
	wire [WIDTH - 1:0] shift_row_1_wires [4:0];
	wire [WIDTH - 1:0] shift_row_2_wires [5:0];
	wire [WIDTH - 1:0] shift_row_3_wires [6:0];
	wire [WIDTH - 1:0] shift_row_4_wires [7:0];
	assign row1_val = shift_row_1_wires[4];
	assign row2_val = shift_row_2_wires[5];
	assign row3_val = shift_row_3_wires[6];
	assign row4_val = shift_row_4_wires[7];
	assign shift_row_1_wires[0] = 0;
	assign shift_row_2_wires[0] = 0;
	assign shift_row_3_wires[0] = 0;
	assign shift_row_4_wires[0] = 0;
	genvar _gv_i_2;
	generate
		for (_gv_i_2 = 1; _gv_i_2 <= 4; _gv_i_2 = _gv_i_2 + 1) begin : genblk1
			localparam i = _gv_i_2;
			ShiftReg #(.WIDTH(WIDTH)) shr(
				.clk(clk),
				.reset(reset),
				.load(load),
				.pload(activation[(4 - i) * WIDTH+:WIDTH]),
				.shin(shift_row_1_wires[i - 1]),
				.out(shift_row_1_wires[i])
			);
		end
	endgenerate
	genvar _gv_j_2;
	generate
		for (_gv_j_2 = 1; _gv_j_2 <= 4; _gv_j_2 = _gv_j_2 + 1) begin : genblk2
			localparam j = _gv_j_2;
			ShiftReg #(.WIDTH(WIDTH)) shr(
				.clk(clk),
				.reset(reset),
				.load(load),
				.pload(activation[(8 - j) * WIDTH+:WIDTH]),
				.shin(shift_row_2_wires[j - 1]),
				.out(shift_row_2_wires[j])
			);
		end
	endgenerate
	ShiftReg #(.WIDTH(WIDTH)) shr_1_0(
		.clk(clk),
		.reset(reset),
		.load(load),
		.pload(0),
		.shin(shift_row_2_wires[4]),
		.out(shift_row_2_wires[5])
	);
	genvar _gv_k_2;
	generate
		for (_gv_k_2 = 1; _gv_k_2 <= 4; _gv_k_2 = _gv_k_2 + 1) begin : genblk3
			localparam k = _gv_k_2;
			ShiftReg #(.WIDTH(WIDTH)) shr(
				.clk(clk),
				.reset(reset),
				.load(load),
				.pload(activation[(12 - k) * WIDTH+:WIDTH]),
				.shin(shift_row_3_wires[k - 1]),
				.out(shift_row_3_wires[k])
			);
		end
	endgenerate
	ShiftReg #(.WIDTH(WIDTH)) shr_2_0(
		.clk(clk),
		.reset(reset),
		.load(load),
		.pload(0),
		.shin(shift_row_3_wires[4]),
		.out(shift_row_3_wires[5])
	);
	ShiftReg #(.WIDTH(WIDTH)) shr_2_1(
		.clk(clk),
		.reset(reset),
		.load(load),
		.pload(0),
		.shin(shift_row_3_wires[5]),
		.out(shift_row_3_wires[6])
	);
	genvar _gv_l_2;
	generate
		for (_gv_l_2 = 1; _gv_l_2 <= 4; _gv_l_2 = _gv_l_2 + 1) begin : genblk4
			localparam l = _gv_l_2;
			ShiftReg #(.WIDTH(WIDTH)) shr(
				.clk(clk),
				.reset(reset),
				.load(load),
				.pload(activation[(16 - l) * WIDTH+:WIDTH]),
				.shin(shift_row_4_wires[l - 1]),
				.out(shift_row_4_wires[l])
			);
		end
	endgenerate
	ShiftReg #(.WIDTH(WIDTH)) shr_3_0(
		.clk(clk),
		.reset(reset),
		.load(load),
		.pload(0),
		.shin(shift_row_4_wires[4]),
		.out(shift_row_4_wires[5])
	);
	ShiftReg #(.WIDTH(WIDTH)) shr_3_1(
		.clk(clk),
		.reset(reset),
		.load(load),
		.pload(0),
		.shin(shift_row_4_wires[5]),
		.out(shift_row_4_wires[6])
	);
	ShiftReg #(.WIDTH(WIDTH)) shr_3_2(
		.clk(clk),
		.reset(reset),
		.load(load),
		.pload(0),
		.shin(shift_row_4_wires[6]),
		.out(shift_row_4_wires[7])
	);
endmodule
