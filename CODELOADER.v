`include "INIT_VARIABLE.v"

module CODELOADER
	(
		// TO CORE
		input CLK, RESET, WRITE, READ,
		output [`COMMAND_LEN_WIRE-1: 0] COMMAND,
		input [`LEN_SEGMENT-1:0] SA, SB, SC, IP,
		
		// TO FABRICK DATA
		
	);
	
	
endmodule