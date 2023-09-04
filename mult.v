//Group 32
//E/19/205
//E/19/210

//This module represents the multiplication functional unit ,Calculates the product of two 8-bit numbers
//Contains a delay of 3 time units
module MULT(MULTIPLICAND, MULTIPLIER, OUT);

	//Input and output port declaration
	//two 8 bits input ports (MULTIPLICAND, MULTIPLIER) and one output port (OUT)
	input [7:0] MULTIPLICAND, MULTIPLIER;
	output [7:0] OUT;
	
	//Each wire represents a specific bit or carry value within the multiplication circuit

	//Carry bits for intermediate sums
	wire C0 [5:0];
	wire C1 [4:0];
	wire C2 [3:0];
	wire C3 [2:0];
	wire C4 [1:0];
	wire C5;
	
	//Intermediate sums
	wire sum0 [5:0];
	wire sum1 [4:0];
	wire sum2 [3:0];
	wire sum3 [2:0];
	wire sum4 [1:0];
	wire sum5;
	
	//The RESULT wire is an 8-bit wire that stores the final product before it is assigned to the output port OUT
	wire [7:0] RESULT;
	
	//First bit of RESULT can be directly set
	//This line calculates the first bit of the result, RESULT[0]. 
	//It is directly set as the logical AND of the MULTIPLIER and MULTIPLICAND inputs
	assign RESULT[0] = MULTIPLIER[0] & MULTIPLICAND[0];	
	
	
	//Full Adder array to calculate result by shifting and adding
	
	//Layer 0
	FullAdder FA0_0(MULTIPLIER[0] & MULTIPLICAND[1], MULTIPLIER[1] & MULTIPLICAND[0], 1'b0, RESULT[1], C0[0]);
	FullAdder FA0_1(MULTIPLIER[0] & MULTIPLICAND[2], MULTIPLIER[1] & MULTIPLICAND[1], C0[0], sum0[0], C0[1]);
	FullAdder FA0_2(MULTIPLIER[0] & MULTIPLICAND[3], MULTIPLIER[1] & MULTIPLICAND[2], C0[1], sum0[1], C0[2]);
	FullAdder FA0_3(MULTIPLIER[0] & MULTIPLICAND[4], MULTIPLIER[1] & MULTIPLICAND[3], C0[2], sum0[2], C0[3]);
	FullAdder FA0_4(MULTIPLIER[0] & MULTIPLICAND[5], MULTIPLIER[1] & MULTIPLICAND[4], C0[3], sum0[3], C0[4]);
	FullAdder FA0_5(MULTIPLIER[0] & MULTIPLICAND[6], MULTIPLIER[1] & MULTIPLICAND[5], C0[4], sum0[4], C0[5]);
	FullAdder FA0_6(MULTIPLIER[0] & MULTIPLICAND[7], MULTIPLIER[1] & MULTIPLICAND[6], C0[5], sum0[5], );
	
	//Layer 1
	FullAdder FA1_0(sum0[0], MULTIPLIER[2] & MULTIPLICAND[0], 1'b0, RESULT[2], C1[0]);
	FullAdder FA1_1(sum0[1], MULTIPLIER[2] & MULTIPLICAND[1], C1[0], sum1[0], C1[1]);
	FullAdder FA1_2(sum0[2], MULTIPLIER[2] & MULTIPLICAND[2], C1[1], sum1[1], C1[2]);
	FullAdder FA1_3(sum0[3], MULTIPLIER[2] & MULTIPLICAND[3], C1[2], sum1[2], C1[3]);
	FullAdder FA1_4(sum0[4], MULTIPLIER[2] & MULTIPLICAND[4], C1[3], sum1[3], C1[4]);
	FullAdder FA1_5(sum0[5], MULTIPLIER[2] & MULTIPLICAND[5], C1[4], sum1[4], );
	
	//Layer 2
	FullAdder FA2_0(sum1[0], MULTIPLIER[3] & MULTIPLICAND[0], 1'b0, RESULT[3], C2[0]);
	FullAdder FA2_1(sum1[1], MULTIPLIER[3] & MULTIPLICAND[1], C2[0], sum2[0], C2[1]);
	FullAdder FA2_2(sum1[2], MULTIPLIER[3] & MULTIPLICAND[2], C2[1], sum2[1], C2[2]);
	FullAdder FA2_3(sum1[3], MULTIPLIER[3] & MULTIPLICAND[3], C2[2], sum2[2], C2[3]);
	FullAdder FA2_4(sum1[4], MULTIPLIER[3] & MULTIPLICAND[4], C2[3], sum2[3], );
	
	//Layer 3
	FullAdder FA3_0(sum2[0], MULTIPLIER[4] & MULTIPLICAND[0], 1'b0, RESULT[4], C3[0]);
	FullAdder FA3_1(sum2[1], MULTIPLIER[4] & MULTIPLICAND[1], C3[0], sum3[0], C3[1]);
	FullAdder FA3_2(sum2[2], MULTIPLIER[4] & MULTIPLICAND[2], C3[1], sum3[1], C3[2]);
	FullAdder FA3_3(sum2[3], MULTIPLIER[4] & MULTIPLICAND[3], C3[2], sum3[2], );
	
	//Layer 4
	FullAdder FA4_0(sum3[0], MULTIPLIER[5] & MULTIPLICAND[0], 1'b0, RESULT[5], C4[0]);
	FullAdder FA4_1(sum3[1], MULTIPLIER[5] & MULTIPLICAND[1], C4[0], sum4[0], C4[1]);
	FullAdder FA4_2(sum3[2], MULTIPLIER[5] & MULTIPLICAND[2], C4[1], sum4[1], );
	
	//Layer 5
	FullAdder FA5_0(sum4[0], MULTIPLIER[6] & MULTIPLICAND[0], 1'b0, RESULT[6], C5);
	FullAdder FA5_1(sum4[1], MULTIPLIER[6] & MULTIPLICAND[1], C5, sum5, );
	
	//Layer 6
	FullAdder FA6_0(sum5, MULTIPLIER[7] & MULTIPLICAND[0], 1'b0, RESULT[7], );
	
	//Sending out result after #3 time unit delay
	assign #3 OUT = RESULT;

endmodule


//Full Adder
module FullAdder(A, B, C, SUM, CARRY);

	//Input and output port declaration
	input A, B, C;
	output SUM, CARRY;
	
	//Combinational logic for SUM and CARRY bit outputs
	assign SUM = (A ^ B ^ C);
	assign CARRY = (A & B) + (C & (A ^ B));

endmodule