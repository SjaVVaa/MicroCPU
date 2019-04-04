`include "INIT_VARIABLE.v"

module SDRAM_CTRL
	(
		input CLK, RESET, read_data, write_data, set_adr,
		inout [`NUMBER_WIDTH_DATA_WIRE - 1 : 0] DATA3, DATA2, DATA1, DATA0,
		
		output reg  SDCKE,  SDRAS, SDCAS, SDWE, BUSY, 
		output SDCLK,
		output reg SDLDQM, SDUDQM,SDCS,
		output reg [`SDRAM_ADDRES -1 : 0] SDADDR,
		inout [`SDRAM_DATA -1: 0] SDDQ
	);
	

	//adr:
reg [`BANK_ADDR-1:0] BANK; 		//0
reg [`ROW_ADDR-1:0] ROW;			//1-2
reg [`COLUMN_ADDR-1:0] COLUMN;	//3-4
reg [`BURST_LEN-1:0] BURST;		//5
reg BURS_TYPE;						//6
reg [`CAS_LEN-1:0] CAS;			//7
reg OPCODE;							//8
//reg SDLDQM;							//9
//reg SDUDQM;							//10
//reg WRITE/read data					//11							
reg [`SDRAM_DATA-1:0] IO_BUFFER [0:7] ;//12-27
//reg SDCS;							//28
reg AP;
reg [4:0] adr;						
reg [3:0] STATE;
reg [4:0] COUNT;
reg [1:0] front_start, front_read;
reg [`NUMBER_WIDTH_DATA_WIRE - 1 : 0] dataout;
reg set, rd, wr;
reg [4:0] len_wort;
reg en_wr;
reg act_fl;	
reg end_read;
reg end_write;
reg set_read;
reg set_write;	

wire [`SDRAM_DATA-1:0] IO_BUFF_WIRE = IO_BUFFER[(adr-5'd12)>>1'b1];
wire start_pl = (adr==5'd11 && (write_data||read_data))? 1'b1:1'b0;
wire read = (adr==5'd11 && read_data)?1'b1:1'b0;
wire write = (adr==5'd11 && write_data)?1'b1:1'b0;
wire set_param = (adr==5'd11 && (write_data&&read_data))? 1'b1:1'b0;
wire start_dly = ({front_start,start_pl} == 2'b01)?1'b1:1'b0;
wire read_dly = ({front_read,read_data} == 2'b01)?1'b1:1'b0;
assign SDDQ = 	(en_wr)?IO_BUFFER[COUNT]:'hZ;
assign SDCLK = CLK;

assign DATA = (write_data)?dataout:'hz;

`define 	SDRAM_SLEEP 4'd0
`define 	SDRAM_NOP	4'd1
`define	SDRAM_SET	4'd2
`define	SDRAM_READ	4'd3
`define	SDRAM_WRITE	4'd4
`define 	SDRAM_ACTIVE 4'd5

always@(negedge CLK_SDRAM or negedge RESET)
	if(!RESET)
		front_start <= 'h0;
	else
		front_start <= {front_start,start_pl};
		
always@(negedge CLK_SDRAM or negedge RESET)
	if(!RESET)
		front_read <= 'h0;
	else
		front_read <= {front_read,read_data};		
	
always@(posedge CLK or negedge RESET)
	begin
		if(!RESET)
			adr <= 'h0;
		else
			begin
				if(set_adr)
					adr <= DATA;
				else
					adr <= adr;
			end
	end

always@(posedge CLK or negedge RESET)
	begin
		if(!RESET)
			begin
				BANK <= 'h0;
				ROW <= 'h0;
				COLUMN <= 'h0;
				BURST <= 'h0;
				BURS_TYPE <= 'h0;
				CAS <= 'h2;
				OPCODE <= 'h0;
				SDLDQM <= 'h1;
				SDUDQM <= 'h1;
				SDCS <= 'h1;
				AP <= 'h0;
			end
		else
			begin
				if(read_data)
					begin
						case(adr)
							5'd0:BANK <= DATA;
							5'd1:ROW[`ROW_ADDR-1:8] <= DATA;
							5'd2:ROW[7:0] <= DATA;
							5'd3:COLUMN[`COLUMN_ADDR-1:8] <= DATA;
							5'd4:COLUMN[7:0] <= DATA;
							5'd5:BURST <= (DATA >'d3)?'h0:DATA;
							5'd6:BURS_TYPE <= DATA;
							5'd7:CAS <= (DATA != 'h2 || DATA != 'h3)?'h2:DATA;
							5'd8:OPCODE <= DATA;
							5'd9:SDLDQM <= DATA;
							5'd10:SDUDQM <= DATA;
							/*
							5'd12:IO_BUFF_WIRE[15:8] <= DATA;
							5'd13:IO_BUFF_WIRE[7:0] <= DATA;
							5'd14:IO_BUFF_WIRE[15:8] <= DATA;
							5'd15:IO_BUFF_WIRE[7:0] <= DATA;
							5'd16:IO_BUFF_WIRE[15:8] <= DATA;
							5'd17:IO_BUFF_WIRE[7:0] <= DATA;
							5'd18:IO_BUFF_WIRE[15:8] <= DATA;
							5'd19:IO_BUFF_WIRE[7:0] <= DATA;
							5'd20:IO_BUFF_WIRE[15:8] <= DATA;
							5'd21:IO_BUFF_WIRE[7:0] <= DATA;
							5'd22:IO_BUFF_WIRE[15:8] <= DATA;
							5'd23:IO_BUFF_WIRE[7:0] <= DATA;
							5'd24:IO_BUFF_WIRE[15:8] <= DATA;
							5'd25:IO_BUFF_WIRE[7:0] <= DATA;
							5'd26:IO_BUFF_WIRE[15:8] <= DATA;
							5'd27:IO_BUFF_WIRE[7:0] <= DATA;
							*/
							5'd28:SDCS <= DATA;
							5'd29:AP <= DATA;
							default:AP <= AP;
						endcase
					end
			end
	end

always@(posedge CLK)
	begin
		case(adr)
			5'd0:dataout = {8'h0,BANK};
			5'd1:dataout = {8'h0,ROW[`ROW_ADDR-1:8]};
			5'd2:dataout = {8'h0,ROW[7:0]};
			5'd3:dataout = {8'h0,COLUMN[`COLUMN_ADDR-1:8]};
			5'd4:dataout = {8'h0,COLUMN[7:0]};
			5'd5:dataout = {8'h0,BURST};
			5'd6:dataout = {8'h0,BURS_TYPE};
			5'd7:dataout = {8'h0,CAS};
			5'd8:dataout = {8'h0,OPCODE};
			5'd9:dataout = {8'h0,SDLDQM};
			5'd10:dataout = {8'h0,SDUDQM};
			5'd12:dataout = {8'h0,IO_BUFF_WIRE[15:8]};
			5'd13:dataout = {8'h0,IO_BUFF_WIRE[7:0]};
			5'd14:dataout = {8'h0,IO_BUFF_WIRE[15:8]};
			5'd15:dataout = {8'h0,IO_BUFF_WIRE[7:0]};
			5'd16:dataout = {8'h0,IO_BUFF_WIRE[15:8]};
			5'd17:dataout = {8'h0,IO_BUFF_WIRE[7:0]};
			5'd18:dataout = {8'h0,IO_BUFF_WIRE[15:8]};
			5'd19:dataout = {8'h0,IO_BUFF_WIRE[7:0]};
			5'd20:dataout = {8'h0,IO_BUFF_WIRE[15:8]};
			5'd21:dataout = {8'h0,IO_BUFF_WIRE[7:0]};
			5'd22:dataout = {8'h0,IO_BUFF_WIRE[15:8]};
			5'd23:dataout = {8'h0,IO_BUFF_WIRE[7:0]};
			5'd24:dataout = {8'h0,IO_BUFF_WIRE[15:8]};
			5'd25:dataout = {8'h0,IO_BUFF_WIRE[7:0]};
			5'd26:dataout = {8'h0,IO_BUFF_WIRE[15:8]};
			5'd27:dataout = {8'h0,IO_BUFF_WIRE[7:0]};
			5'd28:dataout = {8'h0,SDCS};
			5'd29:dataout = {8'h0,AP};
			default:dataout = 'h0;
		endcase
	end
	


always@(negedge CLK_SDRAM or negedge RESET)
	begin
		if(!RESET)
			begin
				SDCKE <= 1'b1;  
				SDRAS <= 1'b0; 
				SDCAS <= 1'b0;
				SDWE <= 1'b0;
				SDADDR <= 'h0;
				BUSY <= 1'b0;
				en_wr <= 1'b0;
			end
		else
			begin
				case(STATE)
				`SDRAM_SLEEP:
					begin
						{SDCKE,SDRAS,SDCAS,SDWE} <= 4'b1000;
						SDADDR <= 'h0;
						BUSY <= 1'b0;
						en_wr <= 1'b0;
					end
				`SDRAM_NOP:
					begin
						{SDCKE,SDRAS,SDCAS,SDWE} <= 4'b1111;
						SDADDR <= 'h0;
						BUSY <= 1'b1;
						en_wr <= (set_write)?1'b1:1'b0;
					end
				`SDRAM_SET:
					begin
						{SDCKE,SDRAS,SDCAS,SDWE} <= 4'b1000;
						SDADDR <= {BANK,3'h0,OPCODE,2'h0,CAS,BURS_TYPE,BURST};
						BUSY <= 1'b1;
						en_wr <= 1'b1;
					end
				`SDRAM_READ:				
					begin
						{SDCKE,SDRAS,SDCAS,SDWE} <= 4'b1101;
						SDADDR <= {BANK,2'h0,AP,1'h0,COLUMN};
						BUSY <= 1'b1;
						en_wr <= 1'b0;
					end
				`SDRAM_WRITE:
					begin
						{SDCKE,SDRAS,SDCAS,SDWE} <= 4'b1100;
						SDADDR <= {BANK,2'h0,AP,1'h0,COLUMN};
						BUSY <= 1'b1;
						en_wr <= 1'b1;
					end
				`SDRAM_ACTIVE:
					begin
						{SDCKE,SDRAS,SDCAS,SDWE} <= 4'b1011;
						SDADDR <= {BANK,ROW};
						BUSY <= 1'b1;
						en_wr <= 1'b1;
					end
				endcase
			end
	end
	


always@(negedge CLK_SDRAM)
	begin
		case(BURST)
		0:len_wort <= 'd1;
		1:len_wort <= 'd2;
		2:len_wort <= 'd4;
		3:len_wort <= 'd8;
		endcase
	end
	

always@(negedge CLK_SDRAM or negedge RESET)
	begin
		if(!RESET)
			begin
				STATE <= `SDRAM_SLEEP;
				set <= 'h0; 
				rd <= 'h0;
				wr <= 'h0;
				act_fl <= 1'b0;
				set_read <= 1'b0;
				set_write <= 1'b0;
			end
		else
			begin
				case(STATE)
				`SDRAM_SLEEP:
					begin
						set <= set_param; 
						rd <= read;
						wr <= write;
						act_fl <= 1'b0;
						set_read <= 1'b0;
						set_write <= 1'b0;
						STATE <= (start_dly)?`SDRAM_NOP:STATE;
					end
				`SDRAM_NOP:
					begin
						if (act_fl &  set_read & end_read)
							STATE <= `SDRAM_SLEEP;
						else if(act_fl & set_write & end_write)
							STATE <= `SDRAM_SLEEP;
						else if(act_fl & rd & !set_read)
							STATE <= `SDRAM_READ;
						else if(act_fl & wr & !set_write)
							STATE <= `SDRAM_WRITE;
						else if(set)
							STATE <= `SDRAM_SET;
						else if((wr || rd) && !act_fl)
							STATE <= `SDRAM_ACTIVE;
						else
							STATE <= `SDRAM_NOP;
					end
				`SDRAM_SET:
					begin
						STATE <= `SDRAM_SLEEP;
					end
				`SDRAM_READ:				
					begin
						set_read <= 1'b1;
						STATE <= `SDRAM_NOP;
					end
				`SDRAM_WRITE:
					begin
						set_write <= 1'b1;
						STATE <= `SDRAM_NOP;
					end
				`SDRAM_ACTIVE:
					begin
						act_fl <= 1'b1;
						STATE <= `SDRAM_NOP;
					end
				default:STATE <= `SDRAM_SLEEP;
				endcase
			end
	end

always@(posedge CLK_SDRAM or negedge RESET)
	begin
		if(!RESET)
			begin
				COUNT <= 'h0;
				end_read <= 'h0;
				end_write <= 'h0;
			end
		else
			begin
				case(STATE)
				`SDRAM_SLEEP:
					begin
						COUNT <= 'h0;
						end_read <= 'h0;
						end_write <= 'h0;
						if(read_dly)
							begin
								case(adr)
									5'd12:IO_BUFFER[(adr-5'd12)>>1'b1] <= {DATA,IO_BUFF_WIRE[7:0]};
									5'd13:IO_BUFFER[(adr-5'd12)>>1'b1] <= {IO_BUFF_WIRE[15:8],DATA};
									5'd14:IO_BUFFER[(adr-5'd12)>>1'b1] <= {DATA,IO_BUFF_WIRE[7:0]};
									5'd15:IO_BUFFER[(adr-5'd12)>>1'b1] <= {IO_BUFF_WIRE[15:8],DATA};
									5'd16:IO_BUFFER[(adr-5'd12)>>1'b1] <= {DATA,IO_BUFF_WIRE[7:0]};
									5'd17:IO_BUFFER[(adr-5'd12)>>1'b1] <= {IO_BUFF_WIRE[15:8],DATA};
									5'd18:IO_BUFFER[(adr-5'd12)>>1'b1] <= {DATA,IO_BUFF_WIRE[7:0]};
									5'd19:IO_BUFFER[(adr-5'd12)>>1'b1] <= {IO_BUFF_WIRE[15:8],DATA};
									5'd20:IO_BUFFER[(adr-5'd12)>>1'b1] <= {DATA,IO_BUFF_WIRE[7:0]};
									5'd21:IO_BUFFER[(adr-5'd12)>>1'b1] <= {IO_BUFF_WIRE[15:8],DATA};
									5'd22:IO_BUFFER[(adr-5'd12)>>1'b1] <= {DATA,IO_BUFF_WIRE[7:0]};
									5'd23:IO_BUFFER[(adr-5'd12)>>1'b1] <= {IO_BUFF_WIRE[15:8],DATA};
									5'd24:IO_BUFFER[(adr-5'd12)>>1'b1] <= {DATA,IO_BUFF_WIRE[7:0]};
									5'd25:IO_BUFFER[(adr-5'd12)>>1'b1] <= {IO_BUFF_WIRE[15:8],DATA};
									5'd26:IO_BUFFER[(adr-5'd12)>>1'b1] <= {DATA,IO_BUFF_WIRE[7:0]};
									5'd27:IO_BUFFER[(adr-5'd12)>>1'b1] <= {IO_BUFF_WIRE[15:8],DATA};
									default:IO_BUFFER[(adr-5'd12)>>1'b1] <= IO_BUFFER[(adr-5'd12)>>1'b1];
								endcase
							end
					end
				`SDRAM_NOP:
					begin
						if(set_read)
							begin
								if(COUNT < (len_wort + CAS -1'b1))
									begin
										COUNT <= COUNT + 1'b1;
										if(COUNT>=CAS-1)
											IO_BUFFER[COUNT-CAS-1] <= SDDQ;
										else
											IO_BUFFER[COUNT-CAS-1] <= IO_BUFFER[COUNT-CAS-1];
									end
								else
									begin
										end_read <= 'h1;
									end
							end
							
						else if(set_write)
							begin
								if(COUNT < len_wort -1'b1 )
									COUNT <= COUNT + 1'b1;
								else
									end_write <= 'h1;
							end
						else
							begin
								end_read <= 'h0;
								end_write <= 'h0;							
							end
							
							
					end
				`SDRAM_SET:
					begin

					end
				`SDRAM_READ:				
					begin

					end
				`SDRAM_WRITE:
					begin

					end
				`SDRAM_ACTIVE:
					begin

					end
				endcase
			end
	end
	
endmodule
