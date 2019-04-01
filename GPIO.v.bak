`include "INIT_VARIABLE.v"


module GPIO_PORT
	(
	input CLK, RESET, data_read, data_write, set_mask,
	inout [`NUMBER_WIDTH_DATA_WIRE - 1: 0] DATA_io, PORT
	);

reg [`NUMBER_WIDTH_DATA_WIRE - 1: 0] buff_out, mask;	

always@(posedge CLK or negedge RESET)
	begin
		if(!RESET)
			mask <= 'h0;
		else
			begin
				if(set_mask)
					mask <= DATA_io;
				else
					mask <= mask;
			end
	end
	
always@(posedge CLK or negedge RESET)
	begin
		if(!RESET)
			buff_out <= 'h0;
		else
			begin
				if(data_read)
					buff_out <= DATA_io;
				else
					buff_out <= buff_out;			
			end
	
	end

assign DATA_io = (data_write)?(mask & PORT):'hZ;

genvar i;
generate//
	for (i = 0; i<`NUMBER_WIDTH_DATA_WIRE; i = i+1)
		begin:autogen_port
			assign PORT[i] = (!mask[i])?buff_out[i]:'hZ;
		end
endgenerate	


endmodule
