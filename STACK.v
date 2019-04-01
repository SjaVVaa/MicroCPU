`include "INIT_VARIABLE.v"

module STACK
	(
		input CLK, RESET, read_data, write_data,
		inout [`NUMBER_WIDTH_DATA_WIRE - 1 : 0] DATA,
		inout [`FLAG_LEN-1 : 0] flag

	);

reg [`FLAG_LEN + `NUMBER_WIDTH_DATA_WIRE - 1 : 0] MEM [0:`STACK_LEN-1];
reg [`STACK_ADDR_LEN-1 : 0] addr_stack;
wire [`FLAG_LEN + `NUMBER_WIDTH_DATA_WIRE - 1 : 0] mem_wire;
always@(posedge CLK or negedge RESET)
	begin
		if(!RESET)
			addr_stack <= 'h0;
		else
			begin
				if(read_data)
					addr_stack <= (addr_stack != `STACK_LEN-1)? addr_stack + 1'b1 : addr_stack;
				else if(write_data)
					addr_stack <= (addr_stack != 0)? addr_stack - 1'b1 : addr_stack;
				else
					addr_stack <= addr_stack;
			end
	end

always@(posedge CLK)
	begin
		if(read_data)
			MEM[addr_stack] <= {flag,DATA};
		else
			MEM[addr_stack] <= MEM[addr_stack];
	end
	
assign mem_wire = MEM[addr_stack];
assign DATA = (write_data)?mem_wire[`NUMBER_WIDTH_DATA_WIRE-1 : 0]:'hZ;
assign flag = (write_data)?mem_wire[`FLAG_LEN + `NUMBER_WIDTH_DATA_WIRE - 1 :`NUMBER_WIDTH_DATA_WIRE]:'hZ;
	
endmodule
