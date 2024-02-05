module PE_int8 (
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
	input wire [7:0] i_weight;
	input wire [31:0] i_north;
	input wire [7:0] i_west;
	output wire [7:0] o_east;
	output wire [31:0] o_south;
	reg [7:0] weight;
	reg [7:0] east_ff;
	reg [31:0] south_ff;
	always @(posedge clk)
		if (reset) begin
			east_ff <= 0;
			south_ff <= 0;
		end
		else if (load)
			weight <= i_weight;
		else begin
			east_ff <= i_west;
			south_ff <= (i_west * weight) + i_north;
		end
	assign o_east = east_ff;
	assign o_south = south_ff;
endmodule
