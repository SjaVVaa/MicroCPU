`include "INIT_VARIABLE.v"

module OPERATION_REG 
	(
		input CLK, RESET, data_read, data_write,
		inout [`NUMBER_WIDTH_DATA_WIRE - 1: 0] DATA
	);
	
reg [`NUMBER_WIDTH_DATA_WIRE - 1 : 0] buff;

always@(posedge CLK or negedge RESET)
	begin
		if(!RESET)
			buff <= 'h0;
		else
			begin
				if(data_read)
					buff <= DATA;
				else
					buff <= buff;			
			end
	end
	
assign DATA = (data_write)?buff:'hZ;
	
endmodule
