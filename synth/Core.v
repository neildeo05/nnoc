module Core (
	clk,
	reset,
	load,
	weights,
	activation,
	result,
	result_buffer
);
	parameter WIDTH = 16;
	parameter ACCUMULATE = 32;
	input wire clk;
	input wire reset;
	input wire load;
	input wire [(16 * WIDTH) - 1:0] activation;
	input wire [(16 * WIDTH) - 1:0] weights;
	output wire [(4 * ACCUMULATE) - 1:0] result;
	output wire [(16 * ACCUMULATE) - 1:0] result_buffer;
	wire [WIDTH - 1:0] row1_val;
	wire [WIDTH - 1:0] row2_val;
	wire [WIDTH - 1:0] row3_val;
	wire [WIDTH - 1:0] row4_val;
	ShiftBuffer #(.WIDTH(WIDTH)) shb(
		.clk(clk),
		.reset(reset),
		.load(load),
		.activation(activation),
		.row1_val(row1_val),
		.row2_val(row2_val),
		.row3_val(row3_val),
		.row4_val(row4_val)
	);
	Array #(
		.WIDTH(WIDTH),
		.ACCUMULATE(ACCUMULATE)
	) arr(
		.clk(clk),
		.reset(reset),
		.load(load),
		.weights(weights),
		.row1_val(row1_val),
		.row2_val(row2_val),
		.row3_val(row3_val),
		.row4_val(row4_val),
		.result_buffer(result)
	);
	ResultBuffer #(.ACCUMULATE(ACCUMULATE)) rb(
		.clk(clk),
		.reset(reset),
		.result_port(result),
		.res_buffer(result_buffer)
	);
endmodule
