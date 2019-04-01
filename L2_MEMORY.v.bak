`include "INIT_VARIABLE.v"


module L2_MEMORY
	(
		input CLK, RESET, data_read, data_write, set_addr,
		input [`NUMBER_WIDTH_DATA_WIRE - 1: 0] DATA_in, 		
		output [`NUMBER_WIDTH_DATA_WIRE - 1: 0] DATA_out
	);

reg [`NUMBER_WIDTH_DATA_WIRE - 1: 0] L2_MEM [0:(2**(`NUMBER_WIDTH_DATA_WIRE))-1];
reg [`NUMBER_WIDTH_DATA_WIRE - 1: 0] buff, addr;

always@(posedge CLK or negedge RESET)
	begin
		if(!RESET)
			addr <= 'h0;
		else
			begin
				if(set_addr)
					addr <= DATA_in;
				else
					addr <= addr;
			end
	end
	
always@(posedge CLK or negedge RESET)
	begin
		if(!RESET)
			buff <= 'h0;
		else
			begin
				if (data_read)
					L2_MEM[addr] <= DATA_in;
				else
					L2_MEM[addr] <= L2_MEM[addr];
			end
	end
	
assign DATA_out = (data_write)?L2_MEM[addr]:'hZ;	

endmodule
