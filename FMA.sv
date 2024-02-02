// NOTE: This kinda works but not in the way I expected
// Also I don't think signed numbers work
//TODO: Fixed signed number implementation
// Also there are some issues (could be massive)

module FMA (a, b, c, out, mul_out);
   input logic [15:0] a;
   input logic [15:0] b;
   input logic [31:0] c;
   output logic [31:0] out;
   output logic [31:0]        mul_out;
   
   
   logic [7:0] mulExp;
   logic [7:0] addExp;
   logic [23:0] mulMant;
   logic [23:0] addMant;
   logic [7:0] finalExp;
   logic [24:0] sumMants;
   logic [23:0] finalMant;
   int i;
   logic finalSign;
   logic largerMag;		// Flag that tells us which num is larger in magnitude: 0 for mul_out, 1 for addend
   
   FMul multiplier(a, b, mul_out);
   
   always_comb begin
   	finalSign = 1'b0;
   	mulExp = mul_out[30:23];
   	addExp = c[30:23];
   	mulMant = {1'b1, mul_out[22:0]};
   	addMant = {1'b1, c[22:0]};
   	
   	if(mulExp < addExp) begin
   		finalExp = addExp;
   		mulMant = mulMant >> (finalExp - mulExp);
   		largerMag = 1'b1;
   	end else if (addExp < mulExp) begin
   		finalExp = mulExp;
   		addMant = addMant >> (finalExp - addExp);
   		largerMag = 1'b0;
   	end else begin
   		finalExp = mulExp;
   		if (addMant > mulMant) begin
   			largerMag = 1'b1;
   		end else begin
   			largerMag = 1'b0;
   		end
   	end
   	
   	if ((mul_out[31] == 1'b1) && (c[31] == 1'b1)) begin // two positive so add
   		sumMants = addMant + mulMant;
   		finalSign = 1'b0;
   		
   		finalMant = sumMants[24:1];
      		finalExp = finalExp+1;
   	end else if ((mul_out[31] == 1'b1) && (c[31] == 1'b0)) begin
   		sumMants = mulMant - addMant;
   		finalSign = largerMag ? 1'b1 : 1'b0;
   		
   		finalMant = sumMants[23:0];
   		finalMant = sumMants[24] ? finalMant * -1 : finalMant;
   	end else if ((mul_out[31] == 1'b0) && (c[31] == 1'b1)) begin
   		sumMants = addMant - mulMant;
   		finalSign = largerMag ? 1'b0 : 1'b1;
   		
   		finalMant = sumMants[23:0];
   		finalMant = sumMants[24] ? finalMant * -1 : finalMant;
   	end else begin
   		sumMants = addMant + mulMant;
   		finalSign = 1'b1;
   		
   		finalMant = sumMants[24:1];
   		finalExp = finalExp+1;
   	end
   	
   	//sumMants = addMant + mulMant; //have to change sign instead of two's complementing
   	
   	$display("%b", sumMants);
   	
   	for (i = 0; i < 23; i++) begin //do this routine a max of 23 times in case the answer is zero
		if (finalMant[23] == 1'b1) begin // if we have encountered a one we are done bc we can make the final silent bit
			i = 23; 
		end
		else begin // if we haven't encountered a one then we have to continue left shifting to find a one for the silent bit.
			finalMant = finalMant << 1;
			finalExp = finalExp - 1;
			$display("shifted left");
		end
     	end
     	finalMant = finalMant << 1;
     	//finalExp = finalExp - 1;
     	out = {~finalSign, finalExp, finalMant[23:1]}; //need to do sign bit stuff	
   end
   
   
endmodule;
