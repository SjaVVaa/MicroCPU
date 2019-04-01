`include "INIT_VARIABLE.v"

module INTERRUPT
	(
		input CLK, RESET, read_data, write_data,
		inout [`NUMBER_WIDTH_DATA_WIRE - 1 : 0] DATA,
		output reg [3:0] NUM_INT,
		output reg INT2COR,
		
		input INT0, INT1, INT2, INT3, INT4, INT5, INT6, INT7, INT8, INT9, INT10, INT11, INT12, INT13, INT14, INT15
	);
	
always@(posedge CLK or negedge RESET)
	begin
		if(!RESET)
			begin
				NUM_INT <= 'h0;
				INT2COR <= 1'b0;
			end
		else
			begin
				if(INT0)
					NUM_INT <= 'd0;
				else if(INT1)
					NUM_INT <= 'd1;
				else if(INT2)
					NUM_INT <= 'd2;
				else if(INT3)
					NUM_INT <= 'd3;
				else if(INT4)
					NUM_INT <= 'd4;
				else if(INT5)
					NUM_INT <= 'd5;
				else if(INT6)
					NUM_INT <= 'd6;
				else if(INT7)
					NUM_INT <= 'd7;
				else if(INT8)
					NUM_INT <= 'd8;
				else if(INT9)
					NUM_INT <= 'd9;
				else if(INT10)
					NUM_INT <= 'd10;
				else if(INT11)
					NUM_INT <= 'd11;
				else if(INT12)
					NUM_INT <= 'd12;
				else if(INT13)
					NUM_INT <= 'd13;
				else if(INT14)
					NUM_INT <= 'd14;
				else if(INT15)
					NUM_INT <= 'd15;
				else
					NUM_INT <= 'd0;
					
				INT2COR <= (INT0 || INT1 || INT2 || INT3 || INT4 || INT5 || INT6 || INT7 || INT8 || INT9 || INT10 || INT11 || INT12 || INT13 || INT14 || INT15)?1'b1:1'b0;
			end
	end
	
endmodule
