`include "INIT_VARIABLE.v"


module FLAG
	(
		input CLK, RESET, read_data, write_data, set_flag_alu,
		input fl_zf_in, fl_cf_in,
		output fl_zf_out, fl_cf_out,
		inout [`FLAG_LEN-1 : 0] flag		
	);
	
reg [`FLAG_LEN-1 : 0] buff_flag;

always@(posedge CLK or negedge RESET)
	begin
		if(!RESET)
			buff_flag <= 'h0;
		else
			begin
				if(read_data)
					buff_flag <= flag;
				else if(set_flag_alu)
					buff_flag <= {buff_flag [`FLAG_LEN-1 : 2],fl_zf_in, fl_cf_in};
				else
					buff_flag <= buff_flag;
			end
	end
	
assign flag = (write_data)?buff_flag:'hZ;
assign fl_zf_out = buff_flag[1];
assign fl_cf_out = buff_flag[0];
endmodule
