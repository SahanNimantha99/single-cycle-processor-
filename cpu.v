// Group 32
// E/19/205
// E/19/210

`include "alu.v"
`include "reg_file.v"
`include "secondary.v"


//The CPU module contains all the necessary components of the CPU
//The various sub-modules of the CPU are instantiated within the module
//The control logic for the operation of the CPU exists within this top module
module cpu(PC, INSTRUCTION, CLK, RESET);

	//Input Port Declaration
	input [31:0] INSTRUCTION;
	input CLK, RESET;

	//Output Port Declaration
	output reg [31:0] PC;

	//Connections for Register File
	wire [2:0] READREG1, READREG2, WRITEREG;
	wire [7:0] REGOUT1, REGOUT2;
	reg WRITEENABLE;

	//Connections for ALU
	wire [7:0] OPERAND1, OPERAND2, ALURESULT;
	reg [2:0] ALUOP;
	wire ZERO;

	//Connections for negation MUX
	wire [7:0] negatedOp;
	wire [7:0] registerOp;
	reg signSelect;

	//Connections for immediate value MUX
	wire [7:0] IMMEDIATE;
	reg immSelect;

	//PC+4 value and PC value to be updated stored inside CPU
	wire [31:0] PCplus4;
	wire [31:0] PCout;

	//Connections for Jump/Branch Adder
	wire [31:0] TARGET;
	wire [7:0] OFFSET;
	
	//Connections for flow control combinational unit
	reg [1:0] BJSelect;

	//Connections for flow control MUX
	wire flowSelect;

	//Current OPCODE stored in CPU
	reg [7:0] OPCODE;


	//Instantiation of CPU modules
	reg_file my_reg(ALURESULT, REGOUT1, REGOUT2, WRITEREG, READREG1, READREG2, WRITEENABLE, CLK, RESET);
	
	alu my_alu(REGOUT1, OPERAND2, ALURESULT, ZERO, ALUOP);
	
	twosComp my_twosComp(REGOUT2, negatedOp);
	
	mux negationMUX(REGOUT2, negatedOp, signSelect, registerOp);
	
	mux immediateMUX(registerOp, IMMEDIATE, immSelect, OPERAND2);

	pcAdder my_pcAdder(PC, PCplus4);
	
	jumpbranchAdder my_jumpbranchAdder(PCplus4, OFFSET, TARGET);
	
	flowControl my_flowControl(BJSelect, ZERO, flowSelect);
	
	mux32 flowctrlmux(PCplus4, TARGET, flowSelect, PCout);
	

	//PC Update
	always @ ( posedge CLK)
	begin
		if (RESET == 1'b1) 
		begin
			#1
			PC = 0;		//If RESET signal is HIGH, set PC to zero
		end
		else #1 PC = PCout;		//Else, write new PC value
	end
	
	
	
	//Relevant portions of INSTRUCTION are mapped to the respective units
	assign READREG1 = INSTRUCTION[15:8];
	assign IMMEDIATE = INSTRUCTION[7:0];
	assign READREG2 = INSTRUCTION[7:0];
	assign WRITEREG = INSTRUCTION[23:16];
	assign OFFSET = INSTRUCTION[23:16];
	
	
	
	//Decoding the instruction
	always @ (INSTRUCTION)
	begin
		
		OPCODE = INSTRUCTION[31:24];	//Mapping the OP-CODE section of the instruction to OPCODE
		
		#1			//1 Time Unit Delay for Decoding process
		
		case (OPCODE)
		
			//loadi instruction
			8'b00000000:	begin
								ALUOP = 3'b000;			//Set ALU to forward
								immSelect = 1'b1;		//Set MUX to select immediate value
								signSelect = 1'b0;		//Set sign select MUX to positive sign
								BJSelect = 2'b00;		//Set flow control signal to normal flow
								WRITEENABLE = 1'b1;		//Enable writing to register
							end
		
			//mov instruction
			8'b00000001:	begin
								ALUOP = 3'b000;			//Set ALU to FORWARD
								immSelect = 1'b0;		//Set MUX to select register input
								signSelect = 1'b0;		//Set sign select MUX to positive sign
								BJSelect = 2'b00;		//Set flow control signal to normal flow
								WRITEENABLE = 1'b1;		//Enable writing to register
							end
			
			//add instruction
			8'b00000010:	begin
								ALUOP = 3'b001;			//Set ALU to ADD
								immSelect = 1'b0;		//Set MUX to select register input
								signSelect = 1'b0;		//Set sign select MUX to positive sign
								BJSelect = 2'b00;		//Set flow control signal to normal flow
								WRITEENABLE = 1'b1;		//Enable writing to register
							end	
		
			//sub instruction
			8'b00000011:	begin
								ALUOP = 3'b001;			//Set ALU to ADD
								immSelect = 1'b0;		//Set MUX to select register input
								signSelect = 1'b1;		//Set sign select MUX to negative sign
								BJSelect = 2'b00;		//Set flow control signal to normal flow
								WRITEENABLE = 1'b1;		//Enable writing to register
							end

			//and instruction
			8'b00000100:	begin
								ALUOP = 3'b010;			//Set ALU to AND
								immSelect = 1'b0;		//Set MUX to select register input
								signSelect = 1'b0;		//Set sign select MUX to positive sign
								BJSelect = 2'b00;		//Set flow control signal to normal flow
								WRITEENABLE = 1'b1;		//Enable writing to register
							end
							
			//or instruction
			8'b00000101:	begin
								ALUOP = 3'b011;			//Set ALU to OR
								immSelect = 1'b0;		//Set MUX to select register input
								signSelect = 1'b0;		//Set sign select MUX to positive sign
								BJSelect = 2'b00;		//Set flow control signal to normal flow
								WRITEENABLE = 1'b1;		//Enable writing to register
							end
			
			//j instruction
			8'b00000110:	begin
								BJSelect = 2'b01;		//Set flow control signal to JUMP
								WRITEENABLE = 1'b0;		//Disable writing to register
							end
			
			//beq instruction
			8'b00000111:	begin
								ALUOP = 3'b001;			//Set ALU to ADD
								immSelect = 1'b0;		//Set MUX to select register input
								signSelect = 1'b1;		//Set sign select MUX to negative sign
								BJSelect = 2'b10;		//Set flow control signal to BEQ
								WRITEENABLE = 1'b0;		//Disable writing to register
							end
							
			//bne instruction
			8'b00001000:	begin
								ALUOP = 3'b001;			//Set ALU to ADD
								immSelect = 1'b0;		//Set MUX to select register input
								signSelect = 1'b1;		//Set sign select MUX to negative sign
								BJSelect = 2'b11;		//Set flow control signal to BNE
								WRITEENABLE = 1'b0;		//Disable writing to register
							end
							
			//mult instruction
			8'b00001001:	begin
								ALUOP = 3'b110;			//Set ALU to MULT
								immSelect = 1'b0;		//Set MUX to select register input
								signSelect = 1'b0;		//Set sign select MUX to positive sign
								BJSelect = 2'b00;		//Set flow control signal to normal flow
								WRITEENABLE = 1'b1;		//Enable writing to register
							end
			
			
			//sll instruction
			8'b00001010:	begin
								ALUOP = 3'b100;			//Set ALU to LEFT_SHIFT
								immSelect = 1'b1;		//Set MUX to select immediate value
								signSelect = 1'b0;		//Set sign select MUX to positive sign
								BJSelect = 2'b00;		//Set flow control signal to normal flow
								WRITEENABLE = 1'b1;		//Enable writing to register
							end
			
			
			//srl instruction
			8'b00001011:	begin
								ALUOP = 3'b101;			//Set ALU to RIGHT_SHIFT
								immSelect = 1'b1;		//Set MUX to select immediate value
								signSelect = 1'b0;		//Set sign select MUX to positive sign
								BJSelect = 2'b00;		//Set flow control signal to normal flow
								WRITEENABLE = 1'b1;		//Enable writing to register
							end
			
			
			//sra instruction
			8'b00001100:	begin
								ALUOP = 3'b101;			//Set ALU to RIGHT_SHIFT
								immSelect = 1'b1;		//Set MUX to select immediate value
								signSelect = 1'b0;		//Set sign select MUX to positive sign
								BJSelect = 2'b00;		//Set flow control signal to normal flow
								WRITEENABLE = 1'b1;		//Enable writing to register
							end
			
			
			//ror instruction
			8'b00001101:	begin
								ALUOP = 3'b101;			//Set ALU to RIGHT_SHIFT
								immSelect = 1'b1;		//Set MUX to select immediate value
								signSelect = 1'b0;		//Set sign select MUX to positive sign
								BJSelect = 2'b00;		//Set flow control signal to normal flow
								WRITEENABLE = 1'b1;		//Enable writing to register
							end

							
		endcase
		
	end
	
endmodule


