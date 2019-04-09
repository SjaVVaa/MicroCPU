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
// CREATED		"Tue Apr 09 15:17:47 2019"

module MicroCPU(
	CLK,
	RES,
	store_busy,
	L1WR,
	L1RD,
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
	BUF2CPU,
	L1ADDR,
	ST_WR,
	ST_RD,
	READ,
	WRITE,
	ST_CALL,
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
	ADDR,
	IP,
	L2DAT,
	LD0,
	LD1,
	SA,
	SB,
	SC
);


input wire	CLK;
input wire	RES;
input wire	store_busy;
input wire	L1WR;
input wire	L1RD;
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
input wire	[15:0] BUF2CPU;
input wire	[1:0] L1ADDR;
output wire	ST_WR;
output wire	ST_RD;
output wire	READ;
output wire	WRITE;
output wire	ST_CALL;
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
output wire	[7:0] ADDR;
output wire	[7:0] IP;
inout wire	[7:0] L2DAT;
inout wire	[7:0] LD0;
inout wire	[7:0] LD1;
output wire	[7:0] SA;
output wire	[7:0] SB;
output wire	[7:0] SC;

wire	[7:0] A2ALU;
wire	adr;
wire	adw;
wire	[7:0] ALU_COM;
wire	aludr;
wire	aludw;
wire	[7:0] B2ALU;
wire	bdr;
wire	bdw;
wire	cdr;
wire	cdw;
wire	cf_in;
wire	cf_out;
wire	[7:0] DATA_WIRE;
wire	ddr;
wire	ddw;
wire	[7:0] FLAG;
wire	flagdr;
wire	flagds;
wire	flagdw;
wire	int2cor;
wire	inted;
wire	intwd;
wire	l2dr;
wire	l2ds;
wire	l2dw;
wire	l3rd;
wire	l3sa;
wire	l3sc;
wire	l3wd;
wire	[3:0] num;
wire	stackdr;
wire	stackdw;
wire	zf_in;
wire	zf_out;





ALU	b2v_ix_alu(
	.CLK(CLK),
	.RESET(RES),
	.read_data(aludr),
	.write_data(aludw),
	.ALU_COMM(ALU_COM),
	.DATA_A(A2ALU),
	.DATA_B(B2ALU),
	.fl_zf(zf_in),
	.fl_cf(cf_in),
	.RESULT(DATA_WIRE));


CORE	b2v_ix_core(
	.CLK(CLK),
	.RESET(RES),
	.fl_zf(zf_out),
	.fl_cf(cf_out),
	.INT2COR(int2cor),
	.store_busy(store_busy),
	.L1_write(L1WR),
	.L1_read(L1RD),
	.INT_PU1(INT_PU1),
	.INT_PU2(INT_PU2),
	.INT_PU3(INT_PU3),
	.INT_PU4(INT_PU4),
	.INT_PU5(INT_PU5),
	.INT_PU6(INT_PU6),
	.INT_PU7(INT_PU7),
	.COMMAND_INPUT(BUF2CPU),
	.CONST_out(DATA_WIRE),
	.L12loader(L2DAT),
	.L1_ADDR(L1ADDR),
	.L1_wire(DATA_WIRE),
	.NUM_INT(num),
	.stack_IP(DATA_WIRE),
	.AX_data_read(adr),
	.BX_data_read(bdr),
	.CX_data_read(cdr),
	.DX_data_read(ddr),
	.AX_data_write(adw),
	.BX_data_write(bdw),
	.CX_data_write(cdw),
	.DX_data_write(ddw),
	.ALU_data_read(aludr),
	.ALU_data_write(aludw),
	.L2_data_read(l2dr),
	.L2_data_write(l2dw),
	.L2_set_addr(l2ds),
	.stack_read_data(stackdr),
	.stack_write_data(stackdw),
	.FLAG_read_data(flagdr),
	.FLAG_write_data(flagdw),
	.set_flag_alu(flagds),
	.L3_read_data(l3rd),
	.L3_write_data(l3wd),
	.L3_set_addr(l3sa),
	.L3_set_core(l3sc),
	.INT_read_data(inted),
	.INT_write_data(intwd),
	.store_write(ST_WR),
	.store_read(ST_RD),
	.store_call(ST_CALL),
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
	.ALU_COMM(ALU_COM),
	
	.IP(IP),
	
	
	.SA(SA),
	.SB(SB),
	.SC(SC),
	.SEGMENT(DATA_WIRE)
	);


FLAG	b2v_ix_flag(
	.CLK(CLK),
	.RESET(RES),
	.read_data(flagdr),
	.write_data(flagdw),
	.set_flag_alu(flagds),
	.fl_zf_in(zf_in),
	.fl_cf_in(cf_in),
	.flag(FLAG),
	.fl_zf_out(zf_out),
	.fl_cf_out(cf_out)
	);


INTERRUPT	b2v_ix_int(
	.CLK(CLK),
	.RESET(RES),
	.read_data(inted),
	.write_data(intwd),
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
	.DATA(DATA_WIRE),
	.INT2COR(int2cor),
	
	.NUM_INT(num));


L2_MEMORY	b2v_ix_l2(
	.CLK(CLK),
	.RESET(RES),
	.data_read(l2dr),
	.data_write(l2dw),
	.set_addr(l2ds),
	.DATA_in(DATA_WIRE),
	.DATA_out(DATA_WIRE));


L3_CTRL_DUO	b2v_ix_l3(
	.CLK(CLK),
	.RESET(RES),
	.read_data(l3rd),
	.write_data(l3wd),
	.set_addr(l3sa),
	.set_core(l3sc),
	.DATA(DATA_WIRE),
	.L3D0(LD0),
	.L3D1(LD1),
	.READ(READ),
	.WRITE(WRITE),
	.ADDR(ADDR)
	
	
	);


SPECIAL_REG	b2v_ix_reg_A(
	.CLK(CLK),
	.RESET(RES),
	.data_read(adr),
	.data_write(adw),
	.DATA(DATA_WIRE),
	
	.DATA_ALU(A2ALU));


SPECIAL_REG	b2v_ix_reg_B(
	.CLK(CLK),
	.RESET(RES),
	.data_read(bdr),
	.data_write(bdw),
	.DATA(DATA_WIRE),
	
	.DATA_ALU(B2ALU));


OPERATION_REG	b2v_ix_reg_C(
	.CLK(CLK),
	.RESET(RES),
	.data_read(cdr),
	.data_write(cdw),
	.DATA(DATA_WIRE)
	);


OPERATION_REG	b2v_ix_reg_D(
	.CLK(CLK),
	.RESET(RES),
	.data_read(ddr),
	.data_write(ddw),
	.DATA(DATA_WIRE)
	);


STACK	b2v_ix_stack(
	.CLK(CLK),
	.RESET(RES),
	.read_data(stackdr),
	.write_data(stackdw),
	.DATA(DATA_WIRE),
	.flag(FLAG)
	
	);


endmodule
