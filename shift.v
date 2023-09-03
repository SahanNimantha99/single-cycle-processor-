//Group 32
//E/19/205
//E/19/210

//This module represents a left shift functional unit for an ALU.
//It performs a logical left shift operation on data1 based on the offset provided in data2.
//Contains a delay of #2 time units.
module LEFT_SHIFT(data1 , data2 , OutPut);

	//Declaration of input and output ports.
    //The module has two input ports: data1 and data2, both 8 bits wide.
    input [7:0] data1 ,data2 ;
    //An output port called OutPut, also 8 bits wide.
    output  [7:0] OutPut;
    
	//Intermediate connections between MUX layers 
    wire [7:0] lOut [2:0];
    wire s[7:0];

    //The MUXes take different inputs from data1, data2, 
    //and intermediate outputs from previous layers and produce the corresponding outputs


	//MUX Layer 1
    mux2x1 layer00(lOut[0][0],data1[0],1'b0,data2[0]);
    mux2x1 layer01(lOut[0][1],data1[1],data1[0],data2[0]);
    mux2x1 layer02(lOut[0][2],data1[2],data1[1],data2[0]);
    mux2x1 layer03(lOut[0][3],data1[3],data1[2],data2[0]);
    mux2x1 layer04(lOut[0][4],data1[4],data1[3],data2[0]);
    mux2x1 layer05(lOut[0][5],data1[5],data1[4],data2[0]);
    mux2x1 layer06(lOut[0][6],data1[6],data1[5],data2[0]);
    mux2x1 layer07(lOut[0][7],data1[7],data1[6],data2[0]);
  
	//MUX Layer 2
    mux2x1 layer10(lOut[1][0],lOut[0][0],1'b0,data2[1]);    
    mux2x1 layer11(lOut[1][1],lOut[0][1],1'b0,data2[1]);
    mux2x1 layer12(lOut[1][2],lOut[0][2],lOut[0][0],data2[1]);
    mux2x1 layer13(lOut[1][3],lOut[0][3],lOut[0][1],data2[1]);
    mux2x1 layer14(lOut[1][4],lOut[0][4],lOut[0][2],data2[1]);
    mux2x1 layer15(lOut[1][5],lOut[0][5],lOut[0][3],data2[1]);
    mux2x1 layer16(lOut[1][6],lOut[0][6],lOut[0][4],data2[1]);
    mux2x1 layer17(lOut[1][7],lOut[0][7],lOut[0][5],data2[1]);
  
	//MUX Layer 3
    mux2x1 layer20(lOut[2][0],lOut[1][0],1'b0,data2[2]);    
    mux2x1 layer21(lOut[2][1],lOut[1][1],1'b0,data2[2]);
    mux2x1 layer22(lOut[2][2],lOut[1][2],1'b0,data2[2]);
    mux2x1 layer23(lOut[2][3],lOut[1][3],1'b0,data2[2]);
    mux2x1 layer24(lOut[2][4],lOut[1][4],lOut[1][0],data2[2]);
    mux2x1 layer25(lOut[2][5],lOut[1][5],lOut[1][1],data2[2]);
    mux2x1 layer26(lOut[2][6],lOut[1][6],lOut[1][2],data2[2]);
    mux2x1 layer27(lOut[2][7],lOut[1][7],lOut[1][3],data2[2]);

	//Assigning final output after 2 time unit delay
	//If shift amount is 0x08 output is all zeros
    assign #2 OutPut= (data2==8'd8)? 8'd0:lOut[2];
	
endmodule



//Functional unit to perform Right Shift operations
// Right logical, arithmetic shift , rotate
// data2  [7:6] --> 00  logical       
//              --> 01  arithmetic
//              --> 10  rotate
// data1 is the value to be shifted
module RIGHT_SHIFT (data1 , data2 , OutPut);

	//Declaration of input and output ports
    //The module has two input ports: data1 and data2, both 8 bits wide.
    input [7:0] data1 ,data2 ;
    //output port called OutPut, also 8 bits wide.
    output reg  [7:0] OutPut ;


	//Connections between layers
    wire [7:0] lOut [2:0];
    //wire s[7:0] ;
	
	//Connections for selecting between logical shift, arithmetic shift and rotate operations
    wire m07;
    wire m17, m16;
    wire m27, m26, m25, m24;


	//MUX Layer 1
    mux2x1 layer00(lOut[0][0],data1[0],data1[1],data2[0]);
    mux2x1 layer01(lOut[0][1],data1[1],data1[2],data2[0]);
    mux2x1 layer02(lOut[0][2],data1[2],data1[3],data2[0]);
    mux2x1 layer03(lOut[0][3],data1[3],data1[4],data2[0]);
    mux2x1 layer04(lOut[0][4],data1[4],data1[5],data2[0]);
    mux2x1 layer05(lOut[0][5],data1[5],data1[6],data2[0]);
    mux2x1 layer06(lOut[0][6],data1[6],data1[7],data2[0]);
    mux2x1 layer07(lOut[0][7],data1[7],m07,data2[0]);
    mux3x1 M07(m07,data1[0],data1[7],1'b0,data2[7:6]);
  
	//MUX Layer 2
    mux2x1 layer10(lOut[1][0],lOut[0][0],lOut[0][2],data2[1]);    
    mux2x1 layer11(lOut[1][1],lOut[0][1],lOut[0][3],data2[1]);
    mux2x1 layer12(lOut[1][2],lOut[0][2],lOut[0][4],data2[1]);
    mux2x1 layer13(lOut[1][3],lOut[0][3],lOut[0][5],data2[1]);
    mux2x1 layer14(lOut[1][4],lOut[0][4],lOut[0][6],data2[1]);
    mux2x1 layer15(lOut[1][5],lOut[0][5],lOut[0][7],data2[1]);
    mux2x1 layer16(lOut[1][6],lOut[0][6],m16,data2[1]);
    mux3x1 M16(m16,lOut[0][0],lOut[0][7],1'b0,data2[7:6]);
    mux2x1 layer17(lOut[1][7],lOut[0][7],m17,data2[1]);
    mux3x1 M17(m17,lOut[0][1],lOut[0][7],1'b0,data2[7:6]);
 
   //MUX Layer 3
  	mux2x1 layer20(lOut[2][0],lOut[1][0],lOut[1][4],data2[2]);    
    mux2x1 layer21(lOut[2][1],lOut[1][1],lOut[1][5],data2[2]);
    mux2x1 layer22(lOut[2][2],lOut[1][2],lOut[1][6],data2[2]);
    mux2x1 layer23(lOut[2][3],lOut[1][3],lOut[1][7],data2[2]);
    mux2x1 layer24(lOut[2][4],lOut[1][4],m24,data2[2]);
    mux3x1 M24(m24,lOut[1][0],lOut[1][7],1'b0,data2[7:6]);
    mux2x1 layer25(lOut[2][5],lOut[1][5],m25,data2[2]);
    mux3x1 M25(m25,lOut[1][1],lOut[1][7],1'b0,data2[7:6]);
    mux2x1 layer26(lOut[2][6],lOut[1][6],m26,data2[2]);
    mux3x1 M26(m26,lOut[1][2],lOut[1][7],1'b0,data2[7:6]);
    mux2x1 layer27(lOut[2][7],lOut[1][7],m27,data2[2]);
    mux3x1 M027(m27,lOut[1][3],lOut[1][7],1'b0,data2[7:6]);
    
	
	//Setting final output after 2 time unit delay
	always @ (data1, data2, lOut[2])
	begin
		if (data2[7:6] == 2'b10) #2 OutPut = lOut[2];		//If rotate, send output
		
		else if (data2[7:6] == 2'b01)
		begin
			if (data2[3:0] == 4'd8) #2 OutPut = {8{data1[7]}};	//If arithmetic and shift amount is 0x08, set all bits to sign bit
			else #2 OutPut = lOut[2];		//Else, send output
		end
		
		else if (data2[7:6] == 2'b00)
		begin
			if (data2[3:0] == 4'd8) #2 OutPut = 8'b0;	//If logical and shift amount is 0x08, set all bits to zero
			else #2 OutPut = lOut[2];		//Else, send output
		end
    end

endmodule




//2x1 MUX Module
module mux2x1(out, in0,in1,s);
	//Declaration of input and output ports
    input in0, in1,s;
    output out ;
    wire orIn0 ,orIn1;

	//MUX implementation
    and (orIn0,in0,!s);
    and (orIn1,in1,s);
    or (out , orIn0,orIn1);
	
endmodule


//3x1 MUX Module
module mux3x1 (out , in2 , in1 , in0 , s);
	//Declaration of input and output ports
    input in0,in1,in2;
    output out ; 
    input [1:0] s ;
    wire orIn [2:0] ;
    wire andOut[2:0];

	//MUX implementation
    or (out , orIn[0], orIn[1] , orIn[2]);

    and(andOut[0] , !s[0],!s[1]);
    and (orIn[0] , in0 , andOut[0]);


    and(andOut[1] , s[0],!s[1]);
    and (orIn[1] , in1 , andOut[1]);

    and(andOut[2] , !s[0],s[1]);
    and (orIn[2] , in2 , andOut[2]);

endmodule