module ResultBuffer (
	clk,
	reset,
	result_port,
	res_buffer
);
	parameter ACCUMULATE = 32;
	input wire clk;
	input wire reset;
	input wire [(4 * ACCUMULATE) - 1:0] result_port;
	output reg [(16 * ACCUMULATE) - 1:0] res_buffer;
	reg [(4 * ACCUMULATE) - 1:0] state_registers;
	reg ready_signals [3:0];
	reg [1:0] pointers [3:0];
	always @(posedge clk) begin
		if (reset) begin
			state_registers[0+:ACCUMULATE] <= 0;
			state_registers[ACCUMULATE+:ACCUMULATE] <= 0;
			state_registers[2 * ACCUMULATE+:ACCUMULATE] <= 0;
			state_registers[3 * ACCUMULATE+:ACCUMULATE] <= 0;
			ready_signals[0] <= 0;
			ready_signals[1] <= 0;
			ready_signals[2] <= 0;
			ready_signals[3] <= 0;
			pointers[0] <= 0;
			pointers[1] <= 0;
			pointers[2] <= 0;
			pointers[3] <= 0;
		end
		state_registers <= result_port;
		if (result_port[0+:ACCUMULATE] != state_registers[0+:ACCUMULATE]) begin
			ready_signals[0] <= 1'b1;
			if (ready_signals[0]) begin
				res_buffer[(0 + pointers[0]) * ACCUMULATE+:ACCUMULATE] <= state_registers[0+:ACCUMULATE];
				pointers[0] <= pointers[0] + 1;
			end
		end
		if (result_port[ACCUMULATE+:ACCUMULATE] != state_registers[ACCUMULATE+:ACCUMULATE]) begin
			ready_signals[1] <= 1'b1;
			if (ready_signals[1]) begin
				res_buffer[(4 + pointers[1]) * ACCUMULATE+:ACCUMULATE] <= state_registers[ACCUMULATE+:ACCUMULATE];
				pointers[1] <= pointers[1] + 1;
			end
		end
		if (result_port[2 * ACCUMULATE+:ACCUMULATE] != state_registers[2 * ACCUMULATE+:ACCUMULATE]) begin
			ready_signals[2] <= 1'b1;
			if (ready_signals[2]) begin
				res_buffer[(8 + pointers[2]) * ACCUMULATE+:ACCUMULATE] <= state_registers[2 * ACCUMULATE+:ACCUMULATE];
				pointers[2] <= pointers[2] + 1;
			end
		end
		if (result_port[3 * ACCUMULATE+:ACCUMULATE] != state_registers[3 * ACCUMULATE+:ACCUMULATE]) begin
			ready_signals[3] <= 1'b1;
			if (ready_signals[3]) begin
				res_buffer[(12 + pointers[3]) * ACCUMULATE+:ACCUMULATE] <= state_registers[3 * ACCUMULATE+:ACCUMULATE];
				pointers[3] <= pointers[3] + 1;
			end
		end
	end
endmodule
