// Copyright (C) 2018  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel FPGA IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Intel and sold by Intel or its authorized distributors.  Please
// refer to the applicable agreement for further details.

// PROGRAM		"Quartus Prime"
// VERSION		"Version 18.1.0 Build 625 09/12/2018 SJ Lite Edition"
// CREATED		"Tue Apr 09 12:11:43 2019"

module CPU_master(
	RES,
	CLK_C,
	CLK_B,
	write_data1,
	BUSY_line_SLAVE,
	EN,
	REQUEST_OK,
	ADDR1,
	WRITEFD,
	READFD,
	ADDRFD,
	REQUEST,
	BUSY_line_MASTER,
	DATA1,
	IP_D0,
	LD1,
	NUMBER_UNIT,
	SA_D3,
	SB_D2,
	SC_D1
);


input wire	RES;
input wire	CLK_C;
input wire	CLK_B;
input wire	write_data1;
input wire	BUSY_line_SLAVE;
input wire	EN;
input wire	REQUEST_OK;
input wire	[7:0] ADDR1;
output wire	WRITEFD;
output wire	READFD;
output wire	ADDRFD;
output wire	REQUEST;
inout wire	BUSY_line_MASTER;
inout wire	[7:0] DATA1;
inout wire	[7:0] IP_D0;
inout wire	[7:0] LD1;
output wire	[3:0] NUMBER_UNIT;
inout wire	[7:0] SA_D3;
inout wire	[7:0] SB_D2;
inout wire	[7:0] SC_D1;

wire	[7:0] ADDR2CORE1;
wire	callcore1;
wire	[15:0] COMWIRE;
wire	[7:0] DATA2CORE1;
wire	[7:0] IP;
wire	[1:0] l1adrwire;
wire	l1rd;
wire	l1wr;
wire	[7:0] LDAT;
wire	readcore1;
wire	[7:0] SA;
wire	[7:0] SB;
wire	[7:0] SC;
wire	st2loadercore1dr;
wire	st2loadercore1dw;
wire	store_busy;
wire	writecore1;





CODELOADER	b2v_inst(
	.CLK_C(CLK_C),
	.CLK_B(CLK_B),
	.RESET(RES),
	.WRITE(st2loadercore1dw),
	.READ(st2loadercore1dr),
	.CALL(callcore1),
	.BUSY_line_SLAVE(BUSY_line_SLAVE),
	.EN(EN),
	.REQUEST_OK(REQUEST_OK),
	.BUSY_line_MASTER(BUSY_line_MASTER),
	.IP(IP),
	.IP_D0(IP_D0),
	.L1DAT(LDAT),
	.SA(SA),
	.SA_D3(SA_D3),
	.SB(SB),
	.SB_D2(SB_D2),
	.SC(SC),
	.SC_D1(SC_D1),
	.store_busy(store_busy),
	.L1WR(l1wr),
	.L1RD(l1rd),
	.WRITEFD(WRITEFD),
	.READFD(READFD),
	.ADDRFD(ADDRFD),
	.REQUEST(REQUEST),
	
	.COMMAND(COMWIRE),
	
	.L1ADR(l1adrwire),
	
	.NUMBER_UNIT(NUMBER_UNIT)
	
	
	);
	defparam	b2v_inst.N = 1;


MicroCPU	b2v_ix_core(
	.CLK(CLK_C),
	.RES(RES),
	.store_busy(store_busy),
	.L1WR(l1wr),
	.L1RD(l1rd),
	.BUF2CPU(COMWIRE),
	.L1ADDR(l1adrwire),
	.L2DAT(LDAT),
	.LD0(DATA2CORE1),
	.LD1(LD1),
	.ST_WR(st2loadercore1dw),
	.ST_RD(st2loadercore1dr),
	.READ(readcore1),
	.WRITE(writecore1),
	.ST_CALL(callcore1),
	.ADDR(ADDR2CORE1),
	.IP(IP),
	
	
	
	.SA(SA),
	.SB(SB),
	.SC(SC));


L3_MEM_DUO	b2v_ix_l3_DUO(
	.CLK(CLK_C),
	.RES(RES),
	.read_data(readcore1),
	.write_data0(writecore1),
	.write_data1(write_data1),
	.ADDR0(ADDR2CORE1),
	.ADDR1(ADDR1),
	.DATA0(DATA2CORE1),
	.DATA1(DATA1)
	
	);


endmodule
