module PE_bf16 (
	clk,
	reset,
	load,
	i_weight,
	i_north,
	i_west,
	o_south,
	o_east
);
	input wire clk;
	input wire reset;
	input wire load;
	input wire [15:0] i_weight;
	input wire [31:0] i_north;
	input wire [15:0] i_west;
	output wire [15:0] o_east;
	output wire [31:0] o_south;
	reg [15:0] weight;
	reg [15:0] east_ff;
	reg [31:0] south_ff;
	reg [31:0] fma_value;
	wire [32:1] sv2v_tmp_fma_unit_out;
	always @(*) fma_value = sv2v_tmp_fma_unit_out;
	FMA fma_unit(
		.a(i_west),
		.b(weight),
		.c(i_north),
		.out(sv2v_tmp_fma_unit_out)
	);
	always @(posedge clk)
		if (reset) begin
			east_ff <= 0;
			south_ff <= 0;
		end
		else if (load)
			weight <= i_weight;
		else begin
			east_ff <= i_west;
			south_ff <= fma_value;
		end
	assign o_east = east_ff;
	assign o_south = south_ff;
endmodule
