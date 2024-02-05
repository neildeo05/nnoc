module Array (
	clk,
	reset,
	load,
	weights,
	row1_val,
	row2_val,
	row3_val,
	row4_val,
	result_buffer
);
	parameter WIDTH = 8;
	parameter ACCUMULATE = 32;
	input wire clk;
	input wire load;
	input wire reset;
	input wire [(16 * WIDTH) - 1:0] weights;
	wire [ACCUMULATE - 1:0] col_interconnects [4:0][3:0];
	output wire [(4 * ACCUMULATE) - 1:0] result_buffer;
	wire [WIDTH - 1:0] row1 [4:0];
	wire [WIDTH - 1:0] row2 [4:0];
	wire [WIDTH - 1:0] row3 [4:0];
	wire [WIDTH - 1:0] row4 [4:0];
	input wire [WIDTH - 1:0] row1_val;
	input wire [WIDTH - 1:0] row2_val;
	input wire [WIDTH - 1:0] row3_val;
	input wire [WIDTH - 1:0] row4_val;
	assign row1[0] = row1_val;
	assign row2[0] = row2_val;
	assign row3[0] = row3_val;
	assign row4[0] = row4_val;
	genvar _gv_i_1;
	generate
		for (_gv_i_1 = 0; _gv_i_1 < 4; _gv_i_1 = _gv_i_1 + 1) begin : genblk1
			localparam i = _gv_i_1;
			if (WIDTH == 8) begin : gen_block_8bit
				PE_int8 pe(
					.clk(clk),
					.reset(reset),
					.load(load),
					.i_weight(weights[(0 + i) * WIDTH+:WIDTH]),
					.i_west(row1[i]),
					.o_east(row1[i + 1]),
					.i_north(col_interconnects[i][0]),
					.o_south(col_interconnects[i][1])
				);
			end
			else if (WIDTH == 16) begin : gen_block_16bit
				PE_bf16 pe(
					.clk(clk),
					.reset(reset),
					.load(load),
					.i_weight(weights[(0 + i) * WIDTH+:WIDTH]),
					.i_west(row1[i]),
					.o_east(row1[i + 1]),
					.i_north(col_interconnects[i][0]),
					.o_south(col_interconnects[i][1])
				);
			end
		end
	endgenerate
	genvar _gv_j_1;
	generate
		for (_gv_j_1 = 0; _gv_j_1 < 4; _gv_j_1 = _gv_j_1 + 1) begin : genblk2
			localparam j = _gv_j_1;
			if (WIDTH == 8) begin : gen_block_8bit
				PE_int8 pe(
					.clk(clk),
					.reset(reset),
					.load(load),
					.i_weight(weights[(4 + j) * WIDTH+:WIDTH]),
					.i_west(row2[j]),
					.o_east(row2[j + 1]),
					.i_north(col_interconnects[j][1]),
					.o_south(col_interconnects[j][2])
				);
			end
			else if (WIDTH == 16) begin : gen_block_16bit
				PE_bf16 pe(
					.clk(clk),
					.reset(reset),
					.load(load),
					.i_weight(weights[(4 + j) * WIDTH+:WIDTH]),
					.i_west(row2[j]),
					.o_east(row2[j + 1]),
					.i_north(col_interconnects[j][1]),
					.o_south(col_interconnects[j][2])
				);
			end
		end
	endgenerate
	genvar _gv_k_1;
	generate
		for (_gv_k_1 = 0; _gv_k_1 < 4; _gv_k_1 = _gv_k_1 + 1) begin : genblk3
			localparam k = _gv_k_1;
			if (WIDTH == 8) begin : gen_block_8bit
				PE_int8 pe(
					.clk(clk),
					.reset(reset),
					.load(load),
					.i_weight(weights[(8 + k) * WIDTH+:WIDTH]),
					.i_west(row3[k]),
					.o_east(row3[k + 1]),
					.i_north(col_interconnects[k][2]),
					.o_south(col_interconnects[k][3])
				);
			end
			else if (WIDTH == 16) begin : gen_block_16bit
				PE_bf16 pe(
					.clk(clk),
					.reset(reset),
					.load(load),
					.i_weight(weights[(8 + k) * WIDTH+:WIDTH]),
					.i_west(row3[k]),
					.o_east(row3[k + 1]),
					.i_north(col_interconnects[k][2]),
					.o_south(col_interconnects[k][3])
				);
			end
		end
	endgenerate
	genvar _gv_l_1;
	generate
		for (_gv_l_1 = 0; _gv_l_1 < 4; _gv_l_1 = _gv_l_1 + 1) begin : genblk4
			localparam l = _gv_l_1;
			if (WIDTH == 8) begin : gen_block_8bit
				PE_int8 pe(
					.clk(clk),
					.reset(reset),
					.load(load),
					.i_weight(weights[(12 + l) * WIDTH+:WIDTH]),
					.i_west(row4[l]),
					.o_east(row4[l + 1]),
					.i_north(col_interconnects[l][3]),
					.o_south(result_buffer[l * ACCUMULATE+:ACCUMULATE])
				);
			end
			else if (WIDTH == 16) begin : gen_block_16bit
				PE_bf16 pe(
					.clk(clk),
					.reset(reset),
					.load(load),
					.i_weight(weights[(12 + l) * WIDTH+:WIDTH]),
					.i_west(row4[l]),
					.o_east(row4[l + 1]),
					.i_north(col_interconnects[l][3]),
					.o_south(result_buffer[l * ACCUMULATE+:ACCUMULATE])
				);
			end
		end
	endgenerate
endmodule
