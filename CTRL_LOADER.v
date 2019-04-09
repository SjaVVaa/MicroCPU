`include "INIT_VARIABLE.v"

module CTRL_LOADER
	(
	input CLK, RESET,
	
	//CTRL_BUS
	input 	REQUEST_1, 		REQUEST_2, 		REQUEST_3, 		REQUEST_4, 		REQUEST_5, 		REQUEST_6, 		REQUEST_7, 		REQUEST_8,
output reg  EN_1, 			EN_2, 			EN_3, 			EN_4, 			EN_5, 			EN_6, 			EN_7,				EN_8,
output reg 	REQUEST_OK_1,	REQUEST_OK_2, 	REQUEST_OK_3, 	REQUEST_OK_4, 	REQUEST_OK_5, 	REQUEST_OK_6, 	REQUEST_OK_7, 	REQUEST_OK_8,
	input		BUSY_1,			BUSY_2,			BUSY_3,			BUSY_4,			BUSY_5,			BUSY_6,			BUSY_7,			BUSY_8
	);

//TURN
reg [3:0] TURN [0:15];
reg [3:0] POINT, POINT_WR;
reg MUX_BUSY;
reg fall_reg;

always@(posedge CLK or negedge RESET)
	begin
		if(!RESET)
			fall_reg <= 'h0;
		else
			fall_reg <= MUX_BUSY;
	end
wire fall_busy = ({fall_reg,MUX_BUSY} == 2'b10)?1'b1:1'b0;

always@(posedge CLK or negedge RESET)
	begin
		if(!RESET)
			begin
				TURN[0] <= 'h0;
				TURN[1] <= 'h0;
				TURN[2] <= 'h0;
				TURN[3] <= 'h0;
				TURN[4] <= 'h0;
				TURN[5] <= 'h0;
				TURN[6] <= 'h0;
				TURN[7] <= 'h0;
				TURN[8] <= 'h0;
				TURN[9] <= 'h0;
				TURN[10] <= 'h0;
				TURN[11] <= 'h0;
				TURN[12] <= 'h0;
				TURN[13] <= 'h0;
				TURN[14] <= 'h0;
				TURN[15] <= 'h0;
			end
		else
			begin
				if(REQUEST_1) begin
					TURN[POINT_WR] <= 4'd1;
					REQUEST_OK_1	<= 1'b1;
					end
				else if(REQUEST_2) begin
					TURN[POINT_WR] <= 4'd2;
					REQUEST_OK_2	<= 1'b1;
					end
				else if(REQUEST_3) begin
					TURN[POINT_WR] <= 4'd3;
					REQUEST_OK_3	<= 1'b1;
					end
				else if(REQUEST_4) begin
					TURN[POINT_WR] <= 4'd4;
					REQUEST_OK_4	<= 1'b1;
					end
				else if(REQUEST_5) begin
					TURN[POINT_WR] <= 4'd5;
					REQUEST_OK_5	<= 1'b1;
					end
				else if(REQUEST_6) begin
					TURN[POINT_WR] <= 4'd6;
					REQUEST_OK_6	<= 1'b1;
					end
				else if(REQUEST_7) begin
					TURN[POINT_WR] <= 4'd7;
					REQUEST_OK_7	<= 1'b1;
					end
				else if(REQUEST_8) begin
					TURN[POINT_WR] <= 4'd8;
					REQUEST_OK_8	<= 1'b1;
					end
					
					
				if(fall_busy)
					begin
						TURN[POINT] <= 4'd0;
						case(TURN[POINT])
						1:REQUEST_OK_1	<= 1'b0;
						2:REQUEST_OK_2	<= 1'b0;
						3:REQUEST_OK_3	<= 1'b0;
						4:REQUEST_OK_4	<= 1'b0;
						5:REQUEST_OK_5	<= 1'b0;
						6:REQUEST_OK_6	<= 1'b0;
						7:REQUEST_OK_7	<= 1'b0;
						8:REQUEST_OK_8	<= 1'b0;
						default:REQUEST_OK_1 <= REQUEST_OK_1;
						endcase
					end
				
					
			end
	end

always@(posedge CLK or negedge RESET)
	begin
		if(!RESET)
			MUX_BUSY = 'h0;
		else
			begin
				case(TURN[POINT])
				1:MUX_BUSY = BUSY_1;
				2:MUX_BUSY = BUSY_2;
				3:MUX_BUSY = BUSY_3;
				4:MUX_BUSY = BUSY_4;
				5:MUX_BUSY = BUSY_5;
				5:MUX_BUSY = BUSY_6;
				7:MUX_BUSY = BUSY_7;
				8:MUX_BUSY = BUSY_8;
				default:MUX_BUSY = 'h0;
				endcase
			end
	end

always@(posedge CLK or negedge RESET)
	begin
		if(!RESET)
			POINT <= 'h0;
		else
			if(TURN[POINT] == 'h0)
				POINT <= POINT + 1'b1;
			else
				POINT <= POINT;
	end
	
always@(posedge CLK or negedge RESET)
	begin
		if(!RESET)
			POINT_WR <= 'h0;
		else
			if(REQUEST_1||REQUEST_2||REQUEST_3||REQUEST_4||REQUEST_5||REQUEST_6||REQUEST_7||REQUEST_8)
				POINT <= POINT + 1'b1;
			else
				POINT_WR <= POINT_WR;
	end
	
always@(posedge CLK or negedge RESET)
	begin
		if(!RESET)
			begin
				EN_1 <= 'h0; 			
				EN_2 <= 'h0;			
				EN_3 <= 'h0; 			
				EN_4 <= 'h0; 			
				EN_5 <= 'h0; 			
				EN_6 <= 'h0; 			
				EN_7 <= 'h0;				
				EN_8 <= 'h0;
			end
		else
			begin
				case(TURN[POINT])
				1:{EN_1,EN_2,EN_3,EN_4,EN_5,EN_6,EN_7,EN_8} <= 8'h80;
				2:{EN_1,EN_2,EN_3,EN_4,EN_5,EN_6,EN_7,EN_8} <= 8'h40;
				3:{EN_1,EN_2,EN_3,EN_4,EN_5,EN_6,EN_7,EN_8} <= 8'h20;
				4:{EN_1,EN_2,EN_3,EN_4,EN_5,EN_6,EN_7,EN_8} <= 8'h10;
				5:{EN_1,EN_2,EN_3,EN_4,EN_5,EN_6,EN_7,EN_8} <= 8'h08;
				6:{EN_1,EN_2,EN_3,EN_4,EN_5,EN_6,EN_7,EN_8} <= 8'h04;
				7:{EN_1,EN_2,EN_3,EN_4,EN_5,EN_6,EN_7,EN_8} <= 8'h02;
				8:{EN_1,EN_2,EN_3,EN_4,EN_5,EN_6,EN_7,EN_8} <= 8'h01;
				default:{EN_1,EN_2,EN_3,EN_4,EN_5,EN_6,EN_7,EN_8} <= 8'h0;
				endcase						
			end
	end
endmodule
