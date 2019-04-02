`include "INIT_VARIABLE.v"

module CODELOADER
	(
		// TO CORE
		input CLK_C, CLK_B, RESET, WRITE, READ,
		output [`COMMAND_LEN_WIRE-1: 0] COMMAND,
		input [`LEN_SEGMENT-1:0] SA, SB, SC, IP,
		output store_busy,
		
		// TO FABRICK DATA
		inout [`LEN_SEGMENT-1:0] SA_D3, SB_D2, SC_D1, IP_D0,
		output WRITE, READ, ADDR,
		inout BUSY_line_MASTER,
		input BUSY_line_SLAVE,
		
		// TO FABRICK CONTROLL
		output [3:0] NUMBER_UNIT,
		output REQUEST,
		input EN	
	);

reg COUNT_COM;
reg front_CLK_C_buff;
reg [`COMMAND_LEN_WIRE-1: 0] COM_DAT [0:(2**(`NUMBER_WIDTH_DATA_WIRE + 1'd1))-1];

// SYNC TRIGGER CLK_C and CLK_B
always@(posedge CLK_B or negedge RESET)
	begin
		if(!RESET)
			front_CLK_C_buff <= 1'b0;
		else
			front_CLK_C_buff <= CLK_C;
	end
wire front_CLK_C = ({front_CLK_C_buff,CLK_C} == 2'b01)?1'b1:1'b0;

// COUNTER COMMANDS
always@(posedge CLK_B or negedge RESET)
	begin
		if(!RESET)
			COUNT_COM <= 'h0;
		else
			begin
				if(front_CLK_C && !COUNT_COM && (&IP))
					COUNT_COM <= 1'b1;
				else if(front_CLK_C && !COUNT_COM && (&IP))
					COUNT_COM <= 1'b0;
				else
					COUNT_COM <= COUNT_COM;
			end
	end
	

	

endmodule