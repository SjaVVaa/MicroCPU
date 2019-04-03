`include "INIT_VARIABLE.v"

module CODELOADER
	(	
		// TO CORE
		input CLK_C, CLK_B, RESET, WRITE, READ,
		output [`COMMAND_LEN_WIRE-1: 0] COMMAND,
		input [`LEN_SEGMENT-1:0] SA, SB, SC, IP,
		output store_busy, L1WR, L1RD,
		output [1:0] L1ADR,
		inout [`NUMBER_WIDTH_DATA_WIRE - 1: 0] L1DAT,
		
		// TO FABRICK DATA
		inout [`LEN_SEGMENT-1:0] SA_D3, SB_D2, SC_D1, IP_D0,
		output WRITEFD, READFD, ADDRFD,
		inout BUSY_line_MASTER,
		input BUSY_line_SLAVE,
		
		// TO FABRICK CONTROLL
		output [3:0] NUMBER_UNIT,
		output REQUEST,
		input EN	
	);
// PARAM
parameter N = 1;
// CLK_C - 50	MHz
// CLK_B - 200	MHz
assign  NUMBER_UNIT = N;
reg COUNT_COM;
reg front_CLK_C_buff;
reg [`COMMAND_LEN_WIRE-1: 0] COM_DAT [0:(2**(`NUMBER_WIDTH_DATA_WIRE + 1'd1))-1];
reg [`NUMBER_WIDTH_DATA_WIRE - 1: 0] L1BUFF [0:3];
reg [3:0] STATE;
reg L1_WR;
reg end_L1_reload;
`define LOADER_SLEEP	4'd0	//sleep module
`define LOADER_CHECK	4'd1	//module has make request for L1 cache
`define	LOADER_TURN		4'd2	//module  standing on a turn
`define	LOADER_ADDR		4'd3	//module set new address
`define LOADER_WRITEL	4'd4	//module has send data from cache in memory unit 
`define	LOADER_READL	4'd5	//module has get data from memory unit in cache
`define LOADER_LOAD		4'd6	//module will loading a new command list 

// SYNC TRIGGER CLK_C and CLK_B
always@(posedge CLK_B or negedge RESET)
	begin
		if(!RESET)
			front_CLK_C_buff <= 1'b0;
		else
			front_CLK_C_buff <= CLK_C;
	end
wire front_CLK_C = ({front_CLK_C_buff,CLK_C} == 2'b01)?1'b1:1'b0;

// COUNTER COMMANDS
always@(posedge CLK_B or negedge RESET)
	begin
		if(!RESET)
			COUNT_COM <= 'h0;
		else
			begin
				if(front_CLK_C && !COUNT_COM && (&IP))
					COUNT_COM <= 1'b1;
				else if(front_CLK_C && !COUNT_COM && (&IP))
					COUNT_COM <= 1'b0;
				else
					COUNT_COM <= COUNT_COM;
			end
	end

//LOADER MASHINE
always@(posedge	CLK_B or negedge RESET)
	begin
		if(!RESET)
			begin
				STATE <= `LOADER_SLEEP;
				L1_WR <= 1'b0;
			end
		else
			begin
				case(STATE)
`LOADER_SLEEP	:begin
					L1_WR <= (WRITE)?1'b1:L1_WR;
					STATE <= ((front_CLK_C && !COUNT_COM && (&IP)) || WRITE || READ)?`LOADER_CHECK:STATE;
				end
`LOADER_CHECK	:begin
					
				end
`LOADER_TURN	:begin

				end
`LOADER_ADDR	:begin

				end
`LOADER_WRITEL	:begin

				end
`LOADER_READL	:begin

				end
`LOADER_LOAD	:begin

				end
				default:STATE <= `LOADER_SLEEP;
				endcase
			end
	end

//L1 cache MASHINE
always@(posedge	CLK_B or negedge RESET)
	begin

				case(STATE)
`LOADER_SLEEP	:begin
					L1ADR <='h0;
					end_L1_reload <= 'h0;
					L1WR <='h0; 
					L1RD <='h0;
				end
`LOADER_CHECK	:begin
					if(L1ADR<'d4)
						begin
							L1ADR <= L1ADR + 1'b1;
							L1WR <= 1'b1;
							L1BUFF[L1ADR] <= L1DAT[L1ADR];
						end
					else
						begin
							L1WR <= 1'b0;
							end_L1_reload <= 'h1;
						end
				end
`LOADER_TURN	:begin

				end
`LOADER_ADDR	:begin

				end
`LOADER_WRITEL	:begin

				end
`LOADER_READL	:begin

				end
`LOADER_LOAD	:begin

				end
				default:STATE <= `LOADER_SLEEP;
				endcase
			
	end	

endmodule