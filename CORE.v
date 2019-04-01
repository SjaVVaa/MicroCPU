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
		inout  [`NUMBER_WIDTH_DATA_WIRE - 1: 0] stack_IP, 
		
		//FLAG
		output FLAG_read_data, FLAG_write_data, set_flag_alu,
		input fl_zf, fl_cf,

		//L3_CTRL
		output L3_read_data, L3_write_data, L3_set_addr, L3_set_core,
		
		//INTERRUPT
		output INT_read_data, INT_write_data,
		input [3:0] NUM_INT,
		input INT2COR,
		
		//STORE
		output reg [`LEN_SEGMENT-1:0] SA, SB, SC,
		output	store_write, store_read,
		input	store_busy
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
					`COM_CALL:IP <= `COMMDAT;
					`COM_RET:IP <= stack_IP;
					`COM_JMP:IP <= `COMMDAT;
					default:IP <= (!store_busy)?IP + 1'b1:IP;
				endcase
			end
	end
	
//const
assign CONST_out	= (`COMMIMP == `COM_LDI 	||`COMMIMP == `COM_L2MEM)?`COMMDAT:'hZ;

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
assign L2_set_addr = ((`COMMIMP == `COM_L2MEM || `COMMIMP == `COM_SET) && `OPER1 == `ADR_L2MEM )?1'b1:1'b0;

//STACK
assign stack_read_data = (`COMMIMP == `COM_PUSH || `COMMIMP == `COM_CALL)? 1'b1:1'b0;
assign stack_write_data= (`COMMIMP == `COM_POP || `COMMIMP == `COM_RET)? 1'b1:1'b0;
assign stack_IP = (`COMMIMP == `COM_CALL)?IP:'hZ;
		
//FLAG
assign FLAG_read_data = (`COMMIMP == `COM_CALL)?1'b1: 1'b0;
assign FLAG_write_data = (`COMMIMP == `COM_RET)?1'b1: 1'b0;
assign set_flag_alu = (`COMMIMP>= `COM_ADD && `COMMIMP<=`COM_CP)?1'b1:1'b0;

//L3_CTRL
assign L3_read_data= (`COMMIMP == `COM_MOV && `OPER1 == `ADR_L3MEM)?1'b1:1'b0;
assign L3_write_data= (`COMMIMP == `COM_MOV && `OPER2 == `ADR_L2MEM)?1'b1:1'b0; 
assign L3_set_addr= ((`COMMIMP == `COM_L3MEM || `COMMIMP == `COM_SET) && `OPER1 == `ADR_L3MEM )?1'b1:1'b0;
assign L3_set_core= ((`COMMIMP == `COM_CORE || `COMMIMP == `COM_SET) && `OPER1 == `ADR_L3MEM )?1'b1:1'b0;
		
//INTERRUPT
assign INT_read_data= 'h0; 
assign INT_write_data= 'h0;

//STORE
assign store_write = (`COMMIMP == `COM_SAVE)?1'b1:1'b0; 
assign store_read = (`COMMIMP == `COM_LOAD)?1'b1:1'b0;
endmodule
	