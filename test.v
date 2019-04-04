`timescale 1ns/100ps

module test
	();
	
reg CLK;
reg	RES;
reg	store_busy;
reg	L1WR;
reg	L1RD;
reg	[15:0] BUF2CPU;
reg	[1:0] L1ADDR;
wire ST_WR;
wire	ST_RD;
wire	READ;
wire	WRITE;
wire	ST_CALL;
wire	[7:0] ADDR;
wire	[7:0] IP;
wire	[7:0] L2DAT;
wire	[7:0] LD0;
wire	[7:0] LD1;
wire	[7:0] SA;
wire	[7:0] SB;
wire	[7:0] SC;
	
MicroCPU ix_CP(
.CLK(CLK),
.RES(RES),
.store_busy(store_busy),
.L1WR(L1WR),
.L1RD(L1RD),
.BUF2CPU(BUF2CPU),
.L1ADDR(L1ADDR),
.ST_WR(ST_WR),
.ST_RD(ST_RD),
.READ(READ),
.WRITE(WRITE),
.ST_CALL(ST_CALL),
.ADDR(ADDR),
.IP(IP),
.L2DAT(L2DAT),
.LD0(LD0),
.LD1(LD1),
.SA(SA),
.SB(SB),
.SC(SC)
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

	end

initial
	begin
		#0;
		store_busy = 'h0;
		L1WR = 'h0;
		L1RD = 'h0;
		BUF2CPU = 'h0;
		L1ADDR = 'h0;
		wait (IP ==8'hFF);
		@(posedge CLK);
		@(posedge CLK);
		wait (IP ==8'hFF);
		@(posedge CLK) store_busy = 1;
		#1000;
		$stop;
		
		
	end
endmodule




