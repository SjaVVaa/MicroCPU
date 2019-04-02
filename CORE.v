`include "INIT_VARIABLE.v"


module CORE
	(
		input CLK, RESET,
		//inout [`NUMBER_WIDTH_DATA_WIRE - 1: 0] BUS_out, <--- UPGRADE!
		//output [`NUMBER_WIDTH_DATA_WIRE - 1: 0] ADDRESS_BUS, <--- UPGRADE!
		//output write_data_bus, read_data_bus, reset_data_bus, <--- UPGRADE!
		input [`COMMAND_LEN_WIRE-1: 0] COMMAND_INPUT,
		output reg [`NUMBER_WIDTH_DATA_WIRE - 1: 0] IP,
		inout	[`NUMBER_WIDTH_DATA_WIRE - 1: 0] CONST_out,
		
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
		input	store_busy,
		output reg [`LEN_SEGMENT-1:0] SEGMENT, // to stack
		
		//L1
		input L1_write, L1_read,
		input [1:0] L1_ADDR,
		inout [`NUMBER_WIDTH_DATA_WIRE - 1: 0] L12loader, L1_wire
	);
	
// CASE L1
reg [`NUMBER_WIDTH_DATA_WIRE - 1: 0] L1_MEM [0:3];
reg [`NUMBER_WIDTH_DATA_WIRE - 1: 0] ADDR_CORE;
always@(posedge CLK or negedge RESET)
	begin
		if(!RESET)
			ADDR_CORE <= 'h0;
		else
			begin
				if((`COMMIMP == `COM_L1MEM) || ((`COMMIMP == `COM_SET)  && (`OPER1 == `ADR_L1MEM )))
					ADDR_CORE <= L1_wire;
				else
					ADDR_CORE <= ADDR_CORE;
			end
	end
	
always@(posedge CLK or negedge RESET)
	begin
		if(!RESET)
			begin
				L1_MEM[0] <= 'h0;
				L1_MEM[1] <= 'h0;
				L1_MEM[2] <= 'h0;
				L1_MEM[3] <= 'h0;
			end
		else
			begin
				if(L1_read)
					L1_MEM[L1_ADDR] <= L12loader;
				if(`COMMIMP == `COM_MOV && `OPER1 == `ADR_L1MEM)
					L1_MEM[ADDR_CORE] <= L1_wire;
				else
					L1_MEM[L1_ADDR] <= L1_MEM[L1_ADDR];
			end
	end
assign 	L12loader = (L1_write)?L1_MEM[L1_ADDR]:'hZ;
assign	L1_wire = (`COMMIMP == `COM_MOV && `OPER2 == `ADR_L1MEM)?L1_MEM[ADDR_CORE]:'hZ;


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

// SA MASHINE
always@(posedge CLK or negedge RESET)
	begin
		if(!RESET)
			SA <= 'h0;
		else
			begin
				if(`COMMIMP == `COM_SA)
					SA <= `COMMDAT;
				else if(`COMMIMP == `COM_SET_SA)
					SA <= CONST_out;
				else
					SA <= SA;
			end
	end
	
// SB MASHINE
always@(posedge CLK or negedge RESET)
	begin
		if(!RESET)
			SB <= 'h0;
		else
			begin
				if(`COMMIMP == `COM_SB)
					SB <= `COMMDAT;
				else if(`COMMIMP == `COM_SET_SB)
					SB <= CONST_out;
				else
					SB <= SB;
			end
	end
	
// SC MASHINE
always@(posedge CLK or negedge RESET)
	begin
		if(!RESET)
			SC <= 'h0;
		else
			begin
				if(`COMMIMP == `COM_SC)
					SC <= `COMMDAT;
				else if(`COMMIMP == `COM_SET_SC)
					SC <= CONST_out;
				else
					SC <= SC;
			end
	end

// AS/CS OUTPUT
always@(posedge CLK or negedge RESET)
	begin
		if(!RESET)
			SEGMENT = 'hZ;
		else
			begin
				case(`COMMIMP)
				`COM_GET_SA:SEGMENT = SA;
				`COM_GET_SB:SEGMENT = SB;
				`COM_GET_SC:SEGMENT = SC;
				default:SEGMENT = 'hZ;
				endcase
			end
	end
	
//const
assign CONST_out	= (
`COMMIMP == `COM_LDI 	||
`COMMIMP == `COM_SA 	|| 
`COMMIMP == `COM_SB 	|| 
`COMMIMP == `COM_SC		|| 
`COMMIMP == `COM_L3MEM 	|| 
`COMMIMP == `COM_CORE 	|| 
`COMMIMP == `COM_L2MEM 	||
`COMMIMP == `COM_L1MEM 
)?`COMMDAT:'hZ;

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
assign L2_set_addr = (`COMMIMP == `COM_L2MEM || (`COMMIMP == `COM_SET && `OPER1 == `ADR_L2MEM ))?1'b1:1'b0;

//STACK
assign stack_read_data = (`COMMIMP == `COM_PUSH || `COMMIMP == `COM_CALL || `COMMIMP ==`COM_GET_SA || `COMMIMP ==`COM_GET_SB || `COMMIMP ==`COM_GET_SC)? 1'b1:1'b0;
assign stack_write_data= (`COMMIMP == `COM_POP || `COMMIMP == `COM_RET || `COMMIMP ==`COM_SET_SA || `COMMIMP ==`COM_SET_SB || `COMMIMP ==`COM_SET_SC)? 1'b1:1'b0;
assign stack_IP = (`COMMIMP == `COM_CALL)?IP:'hZ;
		
//FLAG
assign FLAG_read_data = (`COMMIMP == `COM_CALL)?1'b1: 1'b0;
assign FLAG_write_data = (`COMMIMP == `COM_RET)?1'b1: 1'b0;
assign set_flag_alu = (`COMMIMP>= `COM_ADD && `COMMIMP<=`COM_CP)?1'b1:1'b0;

//L3_CTRL
assign L3_read_data= (`COMMIMP == `COM_MOV && `OPER1 == `ADR_L3MEM)?1'b1:1'b0;
assign L3_write_data= (`COMMIMP == `COM_MOV && `OPER2 == `ADR_L2MEM)?1'b1:1'b0; 
assign L3_set_addr= (`COMMIMP == `COM_L3MEM || (`COMMIMP == `COM_SET && `OPER1 == `ADR_L3MEM ))?1'b1:1'b0;
assign L3_set_core= (`COMMIMP == `COM_CORE || (`COMMIMP == `COM_SET && `OPER1 == `ADR_L3MEM ))?1'b1:1'b0;
		
//INTERRUPT
assign INT_read_data= 'h0; 
assign INT_write_data= 'h0;

//STORE
assign store_write = (`COMMIMP == `COM_SAVE)?1'b1:1'b0; 
assign store_read = (`COMMIMP == `COM_LOAD)?1'b1:1'b0;

//L1

endmodule
	