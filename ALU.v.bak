`include "INIT_VARIABLE.v"


module ALU
	(
		input CLK, RESET,
		input [`NUMBER_WIDTH_DATA_WIRE - 1 : 0] DATA_A, DATA_B,
		output [`NUMBER_WIDTH_DATA_WIRE - 1 : 0] RESULT,
		input [`ALU_NUM_COMMANDS-1:0] ALU_COMM,
		input read_data, write_data,
		output reg fl_zf, fl_cf
	);

reg [`NUMBER_WIDTH_DATA_WIRE - 1 : 0] BUFF_RESULT;

always@(posedge CLK or negedge RESET)
	begin
		if(!RESET)
			begin
				BUFF_RESULT <= 'h0;
				fl_zf <= 'h0;
				fl_cf <= 'h0; 
			end
		else
			begin
				if (read_data) begin
				case(ALU_COMM)
				`AL_ADD	:
				begin
					{fl_cf,BUFF_RESULT} <= DATA_A + DATA_B;
					fl_zf <= ~(|BUFF_RESULT);
					end
				`AL_CP,`AL_SUB	:
				begin
					{fl_cf,BUFF_RESULT} <= DATA_A - DATA_B;
					fl_zf <= ~(|BUFF_RESULT);
					end
				`AL_EOR	:
				begin
					BUFF_RESULT <= DATA_A || DATA_B;
					fl_zf <= ~(|BUFF_RESULT);
					end
				`AL_EAND	:
				begin
					BUFF_RESULT <= DATA_A && DATA_B;
					fl_zf <= ~(|BUFF_RESULT);
					end
				`AL_OR	:
				begin
					BUFF_RESULT <= DATA_A | DATA_B;
					fl_zf <= ~(|BUFF_RESULT);
					end
				`AL_AND	:
				begin
					BUFF_RESULT <= DATA_A & DATA_B;
					fl_zf <= ~(|BUFF_RESULT);
					end
				`AL_NOT	:
				begin
					BUFF_RESULT <= !DATA_A;
					fl_zf <= ~(|BUFF_RESULT);
					end
				`AL_LSH	:
				begin
					{fl_cf,BUFF_RESULT} <= DATA_A << DATA_B;
					fl_zf <= ~(|BUFF_RESULT);
					end
				`AL_RSH	:
				begin
					{BUFF_RESULT,fl_cf} <= DATA_A >> DATA_B;
					fl_zf <= ~(|BUFF_RESULT);
					end
				default:BUFF_RESULT <= BUFF_RESULT;
				endcase
				end
				else
				begin
					BUFF_RESULT <= BUFF_RESULT;
					fl_zf <= fl_zf;
					fl_cf <= fl_cf;
				end
			end
	end
	
assign RESULT = (write_data)?BUFF_RESULT:'hZ;

endmodule
