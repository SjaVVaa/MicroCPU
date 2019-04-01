`include "INIT_VARIABLE.v"

module L3_MEM_DUO
	(
	input CLK, RES,  read_data,
	input write_data0, write_data1,
	input [`NUMBER_WIDTH_DATA_WIRE - 1 : 0] ADDR0,ADDR1,
	inout [`NUMBER_WIDTH_DATA_WIRE - 1 : 0] DATA0,DATA1
	);
	
reg [`NUMBER_WIDTH_DATA_WIRE - 1: 0] L3_MEM [0:(2**(`NUMBER_WIDTH_DATA_WIRE))-1];

always@(posedge CLK)
	begin
		if(read_data)
			L3_MEM[ADDR0] <= DATA0;
		else
			L3_MEM[ADDR0] <= L3_MEM[ADDR0];			
	end
	
assign DATA0 = (write_data0)?L3_MEM[ADDR0]:'hZ;
assign DATA1 = (write_data1)?L3_MEM[ADDR1]:'hZ;
	
endmodule