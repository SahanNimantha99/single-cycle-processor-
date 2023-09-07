// Group 32
// E/19/205
// E/19/210

/* The reg_file module is a simple 8x8 register file. It is capable of reading and storing eight 8-bit values one at a time
and outputting stored 8-bit values two at a time. Writing to the register is synchronous at the rising edge of the CLK signal.
Reading from the register is asynchronous.
The WRITE signal needs to be set to HIGH for inputs to be written to registers.
The RESET signal, when HIGH, will set all registers in the file to zero. */
module reg_file(IN,OUT1,OUT2,INADDRESS,OUT1ADDRESS,OUT2ADDRESS, WRITE, CLK, RESET);

	//Declaration of data input IN and the three address inputs for IN, OUT1 and OUT2 respectively.
	input [7:0] IN;
	input [2:0] INADDRESS, OUT1ADDRESS, OUT2ADDRESS;
	
	//Inputs for write-enable, clock and reset signals
	input WRITE, CLK, RESET;
	
	//Output port declaration
	output [7:0] OUT1, OUT2;
	
	
	
	//Array of 8 8-bit registers
	reg [7:0] REGISTER [7:0];

	//Iterator variable used in for loop
	integer i;
	
	
	//Reads data from registers asynchronously
	//Contains delay of 2 time units
	assign #2 OUT1 = REGISTER[OUT1ADDRESS];		//Assigning value of relevant register address to the OUT1 terminal
	assign #2 OUT2 = REGISTER[OUT2ADDRESS];		//Assigning value of relevant register address to the OUT2 terminal
	
	
	//Synchronous register operations (Write and Reset)
	//Both operations contain a delay of 1 time unit each
	always @ (posedge CLK)
	begin
		if (RESET == 1'b1)		//If the RESET signal is HIGH, registers must be cleared
		begin
		
			#1 for (i = 0; i < 8; i = i + 1)			//For loop to iterate over all 8 register addresses after 1 time unit delay
			begin
				REGISTER[i] = 8'b00000000;		//Setting each element of the REGISTER array to 0
			end
			
		end
		else if (WRITE == 1'b1)			//If the RESET signal is LOW, write to the registers if WRITE signal is HIGH
		begin
		
			#1 REGISTER[INADDRESS] = IN;		//Assigns the input value IN to relevant register address after a delay of 1
			
		end
		
	end
	
	
	//Logging register file contents
	initial
	begin
		#5
		$display("\t\t TIME \t R0 \t R1 \t R2 \t R3 \t R4 \t R5 \t R6 \t R7");
		$monitor($time, "\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d", REGISTER[0], REGISTER[1], REGISTER[2], REGISTER[3], REGISTER[4], REGISTER[5], REGISTER[6], REGISTER[7]);
	end

endmodule