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
// CREATED		"Tue Apr 09 16:46:04 2019"

module MAIN_CPU(
	RES,
	CLK_C,
	CLK_B,
	write_data1,
	BUSY_line_SLAVE,
	EN,
	REQUEST_OK,
	INT0,
	INT1,
	INT2,
	INT3,
	INT4,
	INT5,
	INT6,
	INT7,
	INT8,
	INT9,
	INT10,
	INT11,
	INT12,
	INT13,
	INT14,
	INT15,
	INT_PU1,
	INT_PU2,
	INT_PU3,
	INT_PU4,
	INT_PU5,
	INT_PU6,
	INT_PU7,
	ADDR1,
	WRITEFD,
	READFD,
	ADDRFD,
	REQUEST,
	PU_SA,
	PU_SB,
	PU_SC,
	PU_IP,
	START_PU1,
	START_PU2,
	START_PU3,
	START_PU4,
	START_PU5,
	START_PU6,
	START_PU7,
	EN_PU1,
	EN_PU2,
	EN_PU3,
	EN_PU4,
	EN_PU5,
	EN_PU6,
	EN_PU7,
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
input wire	INT0;
input wire	INT1;
input wire	INT2;
input wire	INT3;
input wire	INT4;
input wire	INT5;
input wire	INT6;
input wire	INT7;
input wire	INT8;
input wire	INT9;
input wire	INT10;
input wire	INT11;
input wire	INT12;
input wire	INT13;
input wire	INT14;
input wire	INT15;
input wire	INT_PU1;
input wire	INT_PU2;
input wire	INT_PU3;
input wire	INT_PU4;
input wire	INT_PU5;
input wire	INT_PU6;
input wire	INT_PU7;
input wire	[7:0] ADDR1;
output wire	WRITEFD;
output wire	READFD;
output wire	ADDRFD;
output wire	REQUEST;
output wire	PU_SA;
output wire	PU_SB;
output wire	PU_SC;
output wire	PU_IP;
output wire	START_PU1;
output wire	START_PU2;
output wire	START_PU3;
output wire	START_PU4;
output wire	START_PU5;
output wire	START_PU6;
output wire	START_PU7;
output wire	EN_PU1;
output wire	EN_PU2;
output wire	EN_PU3;
output wire	EN_PU4;
output wire	EN_PU5;
output wire	EN_PU6;
output wire	EN_PU7;
inout wire	BUSY_line_MASTER;
inout wire	[7:0] DATA1;
inout wire	[7:0] IP_D0;
inout wire	[7:0] LD1;
output wire	[3:0] NUMBER_UNIT;
inout wire	[7:0] SA_D3;
inout wire	[7:0] SB_D2;
inout wire	[7:0] SC_D1;

wire	callcore1;
wire	CLK_C_g;
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
wire	st2loadercore1dr;
wire	st2loadercore1dw;
wire	store_busy;
wire	writecore1;
wire	[7:0] SYNTHESIZED_WIRE_0;
wire	[7:0] SYNTHESIZED_WIRE_1;





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
	.SC(SYNTHESIZED_WIRE_0),
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


MicroCPU	b2v_inst2(
	.CLK(CLK_C_g),
	.RES(RES),
	.store_busy(store_busy),
	.L1WR(l1wr),
	.L1RD(l1rd),
	.INT0(INT0),
	.INT1(INT1),
	.INT2(INT2),
	.INT3(INT3),
	.INT4(INT4),
	.INT5(INT5),
	.INT6(INT6),
	.INT7(INT7),
	.INT8(INT8),
	.INT9(INT9),
	.INT10(INT10),
	.INT11(INT11),
	.INT12(INT12),
	.INT13(INT13),
	.INT14(INT14),
	.INT15(INT15),
	.INT_PU1(INT_PU1),
	.INT_PU2(INT_PU2),
	.INT_PU3(INT_PU3),
	.INT_PU4(INT_PU4),
	.INT_PU5(INT_PU5),
	.INT_PU6(INT_PU6),
	.INT_PU7(INT_PU7),
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
	.PU_SA(PU_SA),
	.PU_SB(PU_SB),
	.PU_SC(PU_SC),
	.PU_IP(PU_IP),
	.START_PU1(START_PU1),
	.START_PU2(START_PU2),
	.START_PU3(START_PU3),
	.START_PU4(START_PU4),
	.START_PU5(START_PU5),
	.START_PU6(START_PU6),
	.START_PU7(START_PU7),
	.EN_PU1(EN_PU1),
	.EN_PU2(EN_PU2),
	.EN_PU3(EN_PU3),
	.EN_PU4(EN_PU4),
	.EN_PU5(EN_PU5),
	.EN_PU6(EN_PU6),
	.EN_PU7(EN_PU7),
	.ADDR(SYNTHESIZED_WIRE_1),
	.IP(IP),
	
	
	
	.SA(SA),
	.SB(SB),
	.SC(SYNTHESIZED_WIRE_0));


L3_MEM_DUO	b2v_ix_l3_DUO(
	.CLK(CLK_C),
	.RES(RES),
	.read_data(readcore1),
	.write_data0(writecore1),
	.write_data1(write_data1),
	.ADDR0(SYNTHESIZED_WIRE_1),
	.ADDR1(ADDR1),
	.DATA0(DATA2CORE1),
	.DATA1(DATA1)
	
	);


endmodule
