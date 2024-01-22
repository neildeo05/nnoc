module faddNew (
    input [31:0] num1,
    input [31:0] num2, 
    output [31:0] out1 
);
    
    //Purpose: add two floating point numbers (IEEE-754) together
    //Step 1: Find number with bigger exponent and match exponents with the smaller exponent number
    //Matching exponents includes shifting the mantissa of the bigger number to the left n times
    //Step 2: Add or subtract mantissas in accordance of the two sign bits (+/+ = +, +/- = -, -/- = +)
    //Step 3: If the mantissa is not normalized, then do so by shifting left and subtracting one from the exponent until the leading bit is a 1.
    //Step 4: Finalize operation by determining final sign bit and putting everything together

    //Pipelining: 3 Stages
    //Stage 1: Decode - take instruction and decode and fetch from FPRegFile or SEXT immediates
    //Stage 2: Execute - Do the instruction and store into pipeline registers
    //Stage 3: Writeback - Take outputs and write back to FPURegFile or IntRegFile or Bus

    logic [7:0] finalExp;
    logic finalSB;
    logic [22:0] finalMant;

    logic [22:0] num1Mant;
    logic [22:0] num2Mant;
    logic num1Big;
    int i;

    always @ (*) begin
        // Step 1
        num1Mant = num1[22:0];
        num2Mant = num2[22:0];
        if (num1[30:23] > num2[30:23]) begin
            finalExp = num2[30:23];
            num1Mant = num1Mant << (num1[30:23] - finalExp);
            num1Big = 1'b1;
        end else if (num1[30:23] < num2[30:23]) begin
            finalExp = num1[30:23];
            num2Mant = num2Mant << (num2[30:23] - finalExp);
            num1Big = 1'b0;
        end
        else begin
            finalExp = num1[30:23];
            num1Big = (num1Mant > num2Mant) ? 1'b1 : 1'b0;
        end
        // Step 2
        if (num1[31] && num2[31]) begin
            finalMant = num1Mant + num2Mant;
            finalSB = 1'b0;
        end
        else if (num1[31] && !num2[31]) begin
            finalMant = num1Mant - num2Mant;
            finalSB = num1Big ? num1[31] : num2[31]; 
        end
        else if (!num1[31] && num2[31]) begin
            finalMant = num2Mant - num1Mant;
            finalSB = num1Big ? num1[31] : num2[31];
        end
        else begin 
            finalMant = num1Mant + num2Mant;
            finalSB = 1'b1;
        end
        // Step 3
        i = 0;
        while (!finalMant[22] && i < 23) begin 
            finalMant = finalMant << 1;
            i++;
        end
		  // Step 4
		  out1 = {finalSB, finalExp, finalMant};
    end
endmodule