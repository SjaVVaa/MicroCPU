`include "INIT_VARIABLE.v"


module CORE
	(
		input CLK, RESET,
		//inout [`NUMBER_WIDTH_DATA_WIRE - 1: 0] BUS_out, <--- UPGRADE!
		//output [`NUMBER_WIDTH_DATA_WIRE - 1: 0] ADDRESS_BUS, <--- UPGRADE!
		//output write_data_bus, read_data_bus, reset_data_bus, <--- UPGRADE!
		input [`COMMAND_LEN_WIRE-1: 0] COMMAND_INPUT,
		output reg [`NUMBER_WIDTH_DATA_WIRE - 1: 0] IP,
		output	[`NUMBER_WIDTH_DATA_WIRE - 1: 0] CONST_out,
		
		//registers
		output AX_data_read, BX_data_read, CX_data_read, DX_data_read,
		output AX_data_write, BX_data_write, CX_data_write, DX_data_write,
		
		//ALU
		output [`NUMBER_WIDTH_DATA_WIRE - 1: 0] ALU_COMM,
		output ALU_data_read,
		output ALU_data_write,

		
		//L2MEM
		output L2_data_read,
		output L2_data_write,
		output L2_set_addr,
		
		//STACK
		output stack_read_data, 
		output stack_write_data,
		
		//FLAG
		output read_data, write_data, set_flag_alu,
		input fl_zf, fl_cf,

		//L3_CTRL
		output read_data, write_data, set_addr, set_core,
		
		//INTERRUPT
		output read_data, write_data,
		input [3:0] NUM_INT,
		input INT2COR
	);
	
//IP MASHINE
always@(posedge CLK or negedge RESET)
	begin
		if(!RESET)
			IP <= 'h0;
		else
			begin
				case(`COMMIMP)
					`COM_BREQ:IP <= (fl_zf)?`COMMDAT:IP + 1'b1;
					`COM_BRNE:IP <= (!fl_zf)?`COMMDAT:IP + 1'b1;
					`COM_BRCS:IP <= (fl_cf)?`COMMDAT:IP + 1'b1;
					`COM_BRCC:IP <= (!fl_cf)?`COMMDAT:IP + 1'b1;
					`COM_JMP:IP <= `COMMDAT;
					default:IP <= IP + 1'b1;
				endcase
			end
	end
	
//const
assign CONST_out	= (`COMMIMP == `COM_LDI 	||`COMMIMP == `COM_PORT 	||`COMMIMP == `COM_L2MEM)?`COMMDAT:'hZ;

//registrs
assign AX_data_read = (`COMMIMP == `COM_MOV && `OPER1 == `ADR_AX)?1'b1:1'b0;
assign BX_data_read = (`COMMIMP == `COM_MOV && `OPER1 == `ADR_BX)?1'b1:1'b0; 
assign CX_data_read = (`COMMIMP == `COM_MOV && `OPER1 == `ADR_CX)?1'b1:1'b0; 
assign DX_data_read = ((`COMMIMP == `COM_MOV && `OPER1 == `ADR_DX) || `COMMIMP == `COM_LDI )?1'b1:1'b0;
assign AX_data_write = (`COMMIMP == `COM_MOV && `OPER2 == `ADR_AX)?1'b1:1'b0; 
assign BX_data_write = (`COMMIMP == `COM_MOV && `OPER2 == `ADR_BX)?1'b1:1'b0; 
assign CX_data_write = (`COMMIMP == `COM_MOV && `OPER2 == `ADR_CX)?1'b1:1'b0; 
assign DX_data_write = (`COMMIMP == `COM_MOV && `OPER2 == `ADR_DX)?1'b1:1'b0;

//ALU
assign ALU_COMM = `COMMIMP - 1'b1;
assign ALU_data_read = (`COMMIMP>= `COM_ADD && `COMMIMP<=`COM_CP)?1'b1:1'b0;
assign ALU_data_write = (`COMMIMP == `COM_MOV && `OPER2 == `ADR_ACC)?1'b1:1'b0;	

//L2MEM
assign L2_data_read = (`COMMIMP == `COM_MOV && `OPER1 == `ADR_L2MEM)?1'b1:1'b0;
assign L2_data_write = (`COMMIMP == `COM_MOV && `OPER2 == `ADR_L2MEM)?1'b1:1'b0;
assign L2_set_addr = (`COMMIMP == `COM_L2MEM)?1'b1:1'b0;

//STACK
assign stack_read_data;
assign stack_write_data;
		
//FLAG
assign read_data; 
assign write_data; 
assign set_flag_alu;

//L3_CTRL
assign read_data; 
assign write_data; 
assign set_addr;
assign set_core;
		
//INTERRUPT
assign read_data; 
assign write_data;

endmodule
	