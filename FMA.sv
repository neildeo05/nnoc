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

   logic signed [23:0]        addendMant;
   logic signed [23:0]        mulOutMant;
   logic [7:0]         addendExp;
   logic [7:0]         mulOutExp;
   logic [7:0]         biggerExp;
   logic signed [27:0]        finalMant;
   logic 		guard_bit;
   logic 		rounding_bit;
   logic 		sticky_bit;
   int			i;
   logic [26:0]		mulMantNew;
   logic [26:0]		addMantNew;
   int temp;
   
   
   //assign addendExp = c[30:23] ;
   

   FMul multiplier(a, b, mul_out);
   
   always_comb begin
      guard_bit = 1'b0;
      rounding_bit = 1'b0;
      sticky_bit = 1'b0;
      addendExp = c[30:23];
      addendMant = {1'b1, c[22:0]};
      mulOutExp = mul_out[30:23];
      mulOutMant = {1'b1, mul_out[22:0]};
      mulMantNew = {mulOutMant, 3'b000};
      addMantNew = {addendMant, 3'b000};
      $display("%b\n", mulOutExp == addendExp);
      if (mulOutExp < addendExp) begin
          biggerExp = addendExp;
          //mulOutMant = (mulOutMant >> (signed'(biggerExp - mulOutExp)));
          temp = signed'(biggerExp - mulOutExp);
          $display("%d\n", temp);
	  for (i = 0; i < 23; i++) begin
	  	if(i >= temp) begin
	  		i = 23;
	  	end
	  	else begin
	  		sticky_bit |= rounding_bit;
	  		guard_bit = mulOutMant[0];
	  		rounding_bit = guard_bit;
	  		mulOutMant = mulOutMant >> 1;
	  	end
	  end
	  mulMantNew = {mulOutMant, guard_bit, rounding_bit, sticky_bit};
      end
      else if (addendExp < mulOutExp) begin 
         biggerExp = mulOutExp;
         //addendMant = (addendMant >> (signed'(biggerExp - addendExp)));
         for (i = 0; i < 23; i++) begin
         	$display("%d\n", temp);
          	temp = signed'(biggerExp - mulOutExp);
	  	if(i >= temp) begin
	  		i = 23;
	  	end
	  	else begin
	  		sticky_bit |= rounding_bit;
	  		guard_bit = mulOutMant[0];
	  		rounding_bit = guard_bit;
	  		addendMant = addendMant >> 1;
	  	end
	  end
	  addMantNew = {mulOutMant, guard_bit, rounding_bit, sticky_bit};
      end else begin
         biggerExp = mulOutExp;
         //addendMant = (addendMant >> (signed'(biggerExp - addendExp)));
         /*for (i = 0; i < 23; i++) begin
	  	if(i >= signed'(biggerExp - mulOutExp)) begin
	  		i = 23;
	  	end
	  	else begin
	  		sticky_bit |= guard_bit;
	  		guard_bit = mulOutMant[0];
	  		rounding_bit = guard_bit;
	  		mulOutMant = mulOutMant >> 1;
	  	end
	  end
	  mulMantNew = {mulOutMant, guard_bit, rounding_bit, sticky_bit};*/
      end

      //biggerExp becomes the initial exponent of the sum
      if (!(c[31] && mul_out[31])) begin
      	if (c[31] == 1'b1) begin
       		addMantNew = (~addMantNew) + 1'b1;
       		$display("cvrt addend");
      	end
      	if (mul_out[31] == 1'b1) begin
      		mulMantNew = (~mulMantNew) +1'b1;
      		$display("cvrt mulout");
      	end
      end
      
      finalMant = signed'(addMantNew + mulMantNew);
      
      if((c[31] ^ mul_out[31])) begin
      	   finalMant = (finalMant[27] == 1'b1) ? ~finalMant + 1'b1 : finalMant;
      end
      
      $display("fM: %b", finalMant);
      
      for (i = 0; i < 27; i++) begin //do this routine a max of 23 times in case the answer is zero
	if (finalMant[27] == 1'b1) begin // if we have encountered a one we are done bc we can make the final silent bit
		i = 27; 
	end
	else begin // if we haven't encountered a one then we have to continue left shifting to find a one for the silent bit.
		finalMant = finalMant << 1;
		biggerExp = biggerExp - 1'b1;
	end
      end
	finalMant = finalMant << 1;
	biggerExp = biggerExp + 1'b1;
      
      /*if (finalMant[21] == 1) begin
         finalMant = finalMant << 1;
      end
      else begin
         if (finalMant[22] == 0 && finalMant[21] == 0) begin
            if (!finalMant[23]) begin 
               finalMant = finalMant << 1;
            end
            else begin
               biggerExp = biggerExp + 1;
            end
            
            
         end
         else begin
            if (finalMant[23] == 1 && finalMant[22] == 1) begin
               finalMant = finalMant << 1;
               finalMant = finalMant + 1;
            end
            else biggerExp = biggerExp + 1;
            
         end
      end*/
      
      
      
      out[31] = 0;
      out[30:23] = biggerExp;
<<<<<<< Updated upstream
      out[22:0] = finalMant[23:1];
//      $display("%b\n", out);
=======
      out[22:0] = finalMant[27:5];
      $display("%b\n", out);
>>>>>>> Stashed changes
      
      

   end
   
endmodule; // FMA
