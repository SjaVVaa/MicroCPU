`include "INIT_VARIABLE.v"

module test_sdram
	(
	
	);

reg CLK, RESET, read_data, write_data, set_adr, CLK_SDRAM;
wire [`NUMBER_WIDTH_DATA_WIRE - 1 : 0] DATA;
		
wire  SDCKE,  SDRAS, SDCAS, SDWE, BUSY; 
wire SDCLK;
wire SDLDQM, SDUDQM,SDCS;
wire [`SDRAM_ADDRES -1 : 0] SDADDR;
wire [`SDRAM_DATA -1: 0] SDDQ;

initial
	begin
		#0 CLK = 0;
		forever #10 CLK = !CLK;
	end
	
initial
	begin
		#0 CLK_SDRAM = 0;
		forever #3 CLK_SDRAM = !CLK_SDRAM;
	end
	
initial
	begin
		#0 RESET = 0;
		read_data = 0;
		write_data = 0; 
		set_adr = 0;
		force DATA = 0;
		#100 RESET = 1'b1;
		@(posedge CLK) force DATA = 'd11;
		set_adr = 1;
		@(posedge CLK) force DATA = 'd11;
		set_adr = 0;
		read_data = 1;
		write_data = 1;
		@(negedge BUSY);
		@(posedge CLK);
		read_data = 0;
		write_data = 0;
		@(posedge CLK) force DATA = 'd11;
		set_adr = 0;
		read_data = 0;
		write_data = 1;
		#1000;
		$stop;
	end

SDRAM_CTRL ix_SDRAM
	(
.CLK(CLK), 
.RESET(RESET), 
.read_data(read_data), 
.write_data(write_data), 
.set_adr(set_adr), 
.CLK_SDRAM(CLK_SDRAM),
.DATA(DATA),
		
.SDCKE(SDCKE),  
.SDRAS(SDRAS), 
.SDCAS(SDCAS), 
.SDWE(SDWE), 
.BUSY(BUSY), 
.SDCLK(SDCLK),
.SDLDQM(SDLDQM), 
.SDUDQM(SDUDQM),
.SDCS(SDCS),
.SDADDR(SDADDR),
.SDDQ(SDDQ)
	);
	
endmodule
