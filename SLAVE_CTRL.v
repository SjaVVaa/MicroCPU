`include "INIT_VARIABLE.v"

module SLAVE_CTRL
	(
	input CLK, RESET, 
	//FROM CORE
	output CLK_gate,
	input CALL_C,
	input [`LEN_SEGMENT-1:0] SA_C, SB_C, SC_C, IP_C,
	output store_busy_C,
	
	//TO LOADER
	output CALL_L,
	output [`LEN_SEGMENT-1:0] SA_L, SB_L, SC_L, IP_L,
	input store_busy_L,
	input [`COMMAND_LEN_WIRE-1: 0] COMMAND,
	
	//FROM MASTER
	input [`LEN_SEGMENT-1:0] SA_M, SB_M, SC_M, IP_M,
	input EN, START_NEW_FLOW,
	output INT	
	);
reg trigger;	
always@(posedge CLK or negedge RESET)
	begin
		if(!RESET)
			trigger <= 1'b0;
		else
			begin
				if(START_NEW_FLOW)
					trigger <= 1'b1;
				else if(COMMAND[13:8] == `COM_INTFLOW)
					trigger <= 1'b0;
				else
					trigger <= trigger;
			end
	end

assign CLK_gate = (EN)?CLK:1'b1;
assign INT = !trigger;
assign CALL_L = CALL_C || START_NEW_FLOW;
assign SA_L = (START_NEW_FLOW)?SA_M:SA_C;
assign SB_L = (START_NEW_FLOW)?SB_M:SB_C;
assign SC_L = (START_NEW_FLOW)?SC_M:SC_C;
assign IP_L = (START_NEW_FLOW)?IP_M:IP_C;
assign store_busy_C = (trigger)?store_busy_L:1'b1;
endmodule
