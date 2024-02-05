module ShiftReg (
	clk,
	reset,
	load,
	pload,
	shin,
	out
);
	parameter WIDTH = 8;
	input wire clk;
	input wire reset;
	input wire load;
	input wire [WIDTH - 1:0] pload;
	input wire [WIDTH - 1:0] shin;
	reg [WIDTH - 1:0] curr;
	output wire [WIDTH - 1:0] out;
	always @(posedge clk)
		if (reset)
			curr <= 0;
		else if (load)
			curr <= pload;
		else
			curr <= shin;
	assign out = curr;
endmodule
