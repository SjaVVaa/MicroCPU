`include "INIT_VARIABLE.v"

module CODELOADER
	(	
		// TO CORE
		input CLK_C, CLK_B, RESET, WRITE, READ,CALL,
		output [`COMMAND_LEN_WIRE-1: 0] COMMAND,
		input [`LEN_SEGMENT-1:0] SA, SB, SC, IP,
		output reg store_busy, L1WR, L1RD,
		output reg [1:0] L1ADR,
		inout [`NUMBER_WIDTH_DATA_WIRE - 1: 0] L1DAT,
		
		// TO FABRICK DATA
		inout [`LEN_SEGMENT-1:0] SA_D3, SB_D2, SC_D1, IP_D0,
		output WRITEFD, READFD, ADDRFD,
		inout BUSY_line_MASTER, //tri1
		input BUSY_line_SLAVE,	//tri1
		
		// TO FABRICK CONTROLL
		output [3:0] NUMBER_UNIT,
		output REQUEST,
		input EN, REQUEST_OK	
	);
// PARAM
parameter N = 1;
// CLK_C - 50	MHz
// CLK_B - 200	MHz
assign  NUMBER_UNIT = N;
reg COUNT_COM;
reg front_CLK_C_buff;
reg front_SLAVE_buff;
reg [`COMMAND_LEN_WIRE-1: 0] COM_DAT [0:(2**(`NUMBER_WIDTH_DATA_WIRE + 1'd1))-1];
reg [`NUMBER_WIDTH_DATA_WIRE - 1: 0] L1BUFF [0:3];
reg [3:0] STATE;
reg L1_WR, L1_RD, COMM_LOAD;
reg end_L1_reload;
reg end_L1_block;

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

// front BUSY_line_SLAVE
always@(posedge CLK_B or negedge RESET)
	begin
		if(!RESET)
			front_SLAVE_buff <= 1'b0;
		else
			front_SLAVE_buff <= BUSY_line_SLAVE;
	end
wire front_line_SLAVE = ({front_SLAVE_buff,BUSY_line_SLAVE} == 2'b01)?1'b1:1'b0;

// COUNTER COMMANDS
always@(posedge CLK_B or negedge RESET)
	begin
		if(!RESET)
			COUNT_COM <= 'h0;
		else
			begin
				if(front_CLK_C && !COUNT_COM && (&IP))
					COUNT_COM <= 1'b1;
				else if(front_CLK_C && COUNT_COM && (&IP))
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
				L1_RD <= 1'b0;
				COMM_LOAD <= 1'b0;
				store_busy <= 1'b0;
			end
		else
			begin
				case(STATE)
`LOADER_SLEEP	:begin
					L1_WR <= (WRITE)?1'b1:1'b0;
					L1_RD <= (READ)?1'b1:1'b0;
					COMM_LOAD <= (front_CLK_C && COUNT_COM && (&IP))?1'b1:1'b0;
					store_busy <= 1'b0;
					STATE <= ((front_CLK_C && COUNT_COM && (&IP)) || WRITE || READ)?`LOADER_CHECK:STATE;
				end
`LOADER_CHECK	:begin
					STATE <= (end_L1_reload)?`LOADER_TURN:STATE;
					store_busy <= 1'b1;
				end
`LOADER_TURN	:begin
					STATE <= (EN && REQUEST_OK)?`LOADER_ADDR:STATE;
				end
`LOADER_ADDR	:begin
					if(front_line_SLAVE && L1_WR)
						STATE <= `LOADER_WRITEL;
					else if(front_line_SLAVE && L1_RD)
						STATE <= `LOADER_READL;
					else if(front_line_SLAVE && COMM_LOAD)
						STATE <= `LOADER_LOAD;
					else
						STATE <= STATE;
				end
`LOADER_WRITEL	:begin
					STATE <= `LOADER_SLEEP;
				end
`LOADER_READL	:begin
					STATE <= (end_L1_reload)?`LOADER_SLEEP:STATE;
				end
`LOADER_LOAD	:begin
					
				end
				default:STATE <= `LOADER_SLEEP;
				endcase
			end
	end
	
assign REQUEST = (!REQUEST_OK && STATE == `LOADER_TURN)?1'b1:1'b0;
assign SA_D3 = (STATE == `LOADER_ADDR)?SA:(STATE == `LOADER_WRITEL)?L1BUFF[0]:'hZ;
assign SB_D2 = (STATE == `LOADER_ADDR)?SB:(STATE == `LOADER_WRITEL)?L1BUFF[1]:'hZ;
assign SC_D1 = (STATE == `LOADER_ADDR)?SC:(STATE == `LOADER_WRITEL)?L1BUFF[2]:'hZ;
assign IP_D0 = (STATE == `LOADER_ADDR)?IP:(STATE == `LOADER_WRITEL)?L1BUFF[3]:'hZ;
assign ADDRFD = (STATE == `LOADER_ADDR)?1'b1:1'hz;
assign WRITEFD = (STATE == `LOADER_WRITEL || 1'b0)?1'b1:1'hz;
assign READFD = (STATE == `LOADER_READL)?1'b1:1'hz;
assign BUSY_line_MASTER = ((STATE == `LOADER_ADDR) || (STATE == `LOADER_WRITEL) /*|| (STATE == `LOADER_READL)*/ || (STATE == `LOADER_LOAD))?1'h0:1'hz;

//L1 cache MASHINE
always@(negedge	CLK_B or negedge RESET)
	begin

				case(STATE)
`LOADER_SLEEP	:begin
					L1ADR <='h0;
					end_L1_reload <= 'h0;
					end_L1_block <= 'h0;
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
							L1ADR <='h0;
						end
				end
`LOADER_TURN	:begin
					end_L1_reload <= 'h0;
				end
`LOADER_ADDR	:begin
					end_L1_reload <= 'h0;
				end
`LOADER_WRITEL	:begin
					end_L1_reload <= 'h0;
				end
`LOADER_READL	:begin
					L1BUFF[0] <= (!end_L1_block)?SA_D3:L1BUFF[0];
					L1BUFF[1] <= (!end_L1_block)?SB_D2:L1BUFF[1];
					L1BUFF[2] <= (!end_L1_block)?SC_D1:L1BUFF[2];
					L1BUFF[3] <= (!end_L1_block)?IP_D0:L1BUFF[3];
					end_L1_block <= 'h1;
					if(L1ADR<'d4)
						begin
							L1ADR <= L1ADR + 1'b1;
							L1RD <= 1'b1;
						end
					else
						begin
							L1RD <= 1'b0;
							end_L1_reload <= 'h1;
							L1ADR <='h0;
						end
				end
`LOADER_LOAD	:begin

				end
				default:STATE <= `LOADER_SLEEP;
				endcase
			
	end	
assign L1DAT = (L1RD)?L1BUFF[L1ADR]:'hz;
endmodule