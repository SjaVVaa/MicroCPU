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
// CREATED		"Wed Apr 10 14:05:31 2019"

module CPU(
	RES,
	CLK_C,
	CLK_B,
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
	EN4,
	START_NEW_FLOW,
	IP_M,
	SA_M,
	SB_M,
	SC_M,
	WRITEFD,
	READFD,
	ADDRFD,
	REQUEST,
	INT,
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
	READ,
	WRITE,
	BUSY_line_MASTER,
	ADDR,
	IP_D0,
	LD0,
	LD1,
	NUMBER_UNIT,
	PU_IP,
	PU_SA,
	PU_SB,
	PU_SC,
	SA_D3,
	SB_D2,
	SC_D1
);


input wire	RES;
input wire	CLK_C;
input wire	CLK_B;
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
input wire	EN4;
input wire	START_NEW_FLOW;
input wire	[7:0] IP_M;
input wire	[7:0] SA_M;
input wire	[7:0] SB_M;
input wire	[7:0] SC_M;
output wire	WRITEFD;
output wire	READFD;
output wire	ADDRFD;
output wire	REQUEST;
output wire	INT;
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
output wire	READ;
output wire	WRITE;
inout wire	BUSY_line_MASTER;
output wire	[7:0] ADDR;
inout wire	[7:0] IP_D0;
inout wire	[7:0] LD0;
inout wire	[7:0] LD1;
output wire	[3:0] NUMBER_UNIT;
output wire	[7:0] PU_IP;
output wire	[7:0] PU_SA;
output wire	[7:0] PU_SB;
output wire	[7:0] PU_SC;
inout wire	[7:0] SA_D3;
inout wire	[7:0] SB_D2;
inout wire	[7:0] SC_D1;

wire	callcore1;
wire	CLK_C_g;
wire	[15:0] COMWIRE;
wire	[1:0] l1adrwire;
wire	l1rd;
wire	l1wr;
wire	[7:0] LDAT;
wire	[7:0] SA;
wire	[7:0] SB;
wire	st2loadercore1dr;
wire	st2loadercore1dw;
wire	store_busy;
wire	store_busy1;
wire	SYNTHESIZED_WIRE_0;
wire	[7:0] SYNTHESIZED_WIRE_1;
wire	[7:0] SYNTHESIZED_WIRE_2;
wire	[7:0] SYNTHESIZED_WIRE_3;
wire	[7:0] SYNTHESIZED_WIRE_4;
wire	[7:0] SYNTHESIZED_WIRE_5;
wire	[7:0] SYNTHESIZED_WIRE_6;





CODELOADER	b2v_inst(
	.CLK_C(CLK_C),
	.CLK_B(CLK_B),
	.RESET(RES),
	.WRITE(st2loadercore1dw),
	.READ(st2loadercore1dr),
	.CALL(SYNTHESIZED_WIRE_0),
	.BUSY_line_SLAVE(BUSY_line_SLAVE),
	.EN(EN),
	.REQUEST_OK(REQUEST_OK),
	.BUSY_line_MASTER(BUSY_line_MASTER),
	.IP(SYNTHESIZED_WIRE_1),
	.IP_D0(IP_D0),
	.L1DAT(LDAT),
	.SA(SYNTHESIZED_WIRE_2),
	.SA_D3(SA_D3),
	.SB(SYNTHESIZED_WIRE_3),
	.SB_D2(SB_D2),
	.SC(SYNTHESIZED_WIRE_4),
	.SC_D1(SC_D1),
	.store_busy(store_busy1),
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
	.LD0(LD0),
	.LD1(LD1),
	.ST_WR(st2loadercore1dw),
	.ST_RD(st2loadercore1dr),
	.READ(READ),
	.WRITE(WRITE),
	.ST_CALL(callcore1),
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
	.ADDR(ADDR),
	.IP(SYNTHESIZED_WIRE_5),
	
	
	
	.PU_IP(PU_IP),
	.PU_SA(PU_SA),
	.PU_SB(PU_SB),
	.PU_SC(PU_SC),
	.SA(SA),
	.SB(SB),
	.SC(SYNTHESIZED_WIRE_6));


SLAVE_CTRL	b2v_inst3(
	.CLK(CLK_C),
	.RESET(RES),
	.CALL_C(callcore1),
	.store_busy_L(store_busy1),
	.EN(EN4),
	.START_NEW_FLOW(START_NEW_FLOW),
	.COMMAND(COMWIRE),
	.IP_C(SYNTHESIZED_WIRE_5),
	.IP_M(IP_M),
	.SA_C(SA),
	.SA_M(SA_M),
	.SB_C(SB),
	.SB_M(SB_M),
	.SC_C(SYNTHESIZED_WIRE_6),
	.SC_M(SC_M),
	.CLK_gate(store_busy),
	.store_busy_C(CLK_C_g),
	.CALL_L(SYNTHESIZED_WIRE_0),
	.INT(INT),
	.IP_L(SYNTHESIZED_WIRE_1),
	.SA_L(SYNTHESIZED_WIRE_2),
	.SB_L(SYNTHESIZED_WIRE_3),
	.SC_L(SYNTHESIZED_WIRE_4));


endmodule
