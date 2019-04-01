`timescale 1ns/100ps

module test
	();
	
reg CLK;
reg RES;
wire [15:0] BUF2CPU;
wire [7:0] IP;
wire [7:0] PORTA;
	
MicroCPU ix_CP(
.CLK(CLK),
.RES(RES),
.BUF2CPU(BUF2CPU),
.IP(IP),
.PORTA(PORTA)
);	

programmmem ix_MM(
.CLK(CLK),
.RESET(RES),
.DATA(BUF2CPU),
.IP(IP)
);

initial
	begin
		#0 CLK = 1'b0;
		forever #10 CLK = !CLK;
	end

initial
	begin
		#0 RES = 1'b0;
		#100 RES = 1'b1;
		
		#1000;
		$stop;
	end
	
endmodule


module programmmem
(
	input CLK, RESET,
	input [7:0] IP,
	output [15:0] DATA
);

reg [15:0] buff;

always@(posedge CLK or negedge RESET)
	begin
		if(!RESET)
			buff <= 'h0;
		else
			begin
				case(IP)
				1:buff <= 16'd0;
				2:buff <= {8'd13,8'd100};
				3:buff <= {8'd12,4'd0,4'd3};
				4:buff <= {8'd13,8'd25};
				5:buff <= {8'd12,4'd1,4'd3};
				6:buff <= {8'd02,4'd0,4'd0};
				7:buff <= {8'd12,4'd5,4'd4};
				8:buff <= {8'd13,8'd21};
				9:buff <= {8'd12,4'd1,4'd3};
				10:buff <= {8'd12,4'd0,4'd5};
				11:buff <= {8'd02,4'd0,4'd0};
				12:buff <= {8'd12,4'd6,4'd4};
				default:buff <= 'h0;
				endcase
			end
	end
	
assign DATA = buff;

endmodule
