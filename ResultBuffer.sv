// Collects the output values

// NOTE: This does WX! PyTorch has it as XW.T, which is equivalent to (WX.T).T, which means if we transpose the inputs ahead of time, the outputs need to be transposed as well. That being said, I don't think we need to do this per-core, rather we can do it when we collect the final matmul (so the routing should do a "transpose" routing)

module ResultBuffer #(parameter ACCUMULATE = 32) (clk, reset, result_port, res_buffer);
   input logic clk;
   input logic reset;
   input logic [ACCUMULATE-1:0] result_port [3:0];
   output logic [ACCUMULATE-1:0] res_buffer [15:0];

   logic [ACCUMULATE-1:0]        state_registers[3:0];
   logic               ready_signals[3:0];
   logic [1:0]         pointers [3:0];
   always @(posedge clk) begin
      if (reset) begin
         state_registers[0] <= 0; state_registers[1] <= 0; state_registers[2] <= 0; state_registers[3] <= 0;
         ready_signals[0] <= 0; ready_signals[1] <= 0; ready_signals[2] <= 0; ready_signals[3] <= 0;
         pointers[0] <= 0; pointers[1] <= 0; pointers[2] <= 0; pointers[3] <= 0;
         for (int i = 0; i < 16; i++) res_buffer[i] <= 0;
         
      end
      // Load state registers
      state_registers <= result_port;
      if(result_port[0] != state_registers[0]) begin
         ready_signals[0] <= 1'b1;
         if(ready_signals[0]) begin
            res_buffer[0+pointers[0]] <= state_registers[0];
            pointers[0] <= pointers[0] + 1;
         end
      end
      if(result_port[1] != state_registers[1]) begin
         ready_signals[1] <= 1'b1;
         if(ready_signals[1]) begin
            res_buffer[4+pointers[1]] <= state_registers[1];
            pointers[1] <= pointers[1] + 1;
         end
      end
      if(result_port[2] != state_registers[2]) begin
         ready_signals[2] <= 1'b1;
         if(ready_signals[2]) begin
            res_buffer[8+pointers[2]] <= state_registers[2];
            pointers[2] <= pointers[2] + 1;
         end
      end
      if(result_port[3] != state_registers[3]) begin
         ready_signals[3] <= 1'b1;
         if(ready_signals[3]) begin
            res_buffer[12+pointers[3]] <= state_registers[3];
            pointers[3] <= pointers[3] + 1;
         end
      end
      
   end

   
      
endmodule; // ResultBuffer_int8
