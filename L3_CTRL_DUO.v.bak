`include "INIT_VARIABLE.v"

module L3_CTRL_DUO
	(
		input CLK, RESET, read_data, write_data, set_addr, set_core,
		inout [`NUMBER_WIDTH_DATA_WIRE - 1 : 0] DATA,
		
		output reg [`NUMBER_WIDTH_DATA_WIRE - 1 : 0] ADDR,
		output READ, WRITE,
		inout [`NUMBER_WIDTH_DATA_WIRE - 1 : 0] L3D0,L3D1
	);

reg [1:0] CORE;
	
always@(posedge CLK or negedge RESET)
	begin
		if(!RESET)
			CORE <= 'h0;
		else
			begin
				if(set_core)
					CORE <= DATA[1:0];
				else
					CORE <= CORE;
			end
	end	

always@(posedge CLK or negedge RESET)
		begin
			if(!RESET)
				ADDR <= 'h0;
			else
				begin
					if(set_addr)
						ADDR <= DATA;
					else
						CORE <= CORE;
				end
		end
		
assign READ = read_data;
assign WRITE = write_data;
assign DATA = (CORE[0])?L3D0:L3D1;
endmodule
