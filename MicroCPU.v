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
// CREATED		"Thu Mar 28 16:11:41 2019"

module MicroCPU(
	CLK,
	RES,
	BUF2CPU,
	IP,
	PORTA
);


input wire	CLK;
input wire	RES;
input wire	[15:0] BUF2CPU;
output wire	[7:0] IP;
inout wire	[7:0] PORTA;

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
wire	dadw;
wire	[7:0] DATA_WIRE;
wire	ddr;
wire	ddw;
wire	[7:0] FLAG;
wire	l2dr;
wire	l2ds;
wire	l2dw;
wire	padr;
wire	pads;
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
	.COMMAND_INPUT(BUF2CPU),
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
	.PORTA_data_read(padr),
	.PORTA_data_write(dadw),
	.PORTA_set_mask(pads),
	.ALU_COMM(ALU_COM),
	.CONST_out(DATA_WIRE),
	.IP(IP));


FLAG	b2v_ix_flag(
	.CLK(CLK),
	.RESET(RES),
	
	
	
	.fl_zf_in(zf_in),
	.fl_cf_in(cf_in),
	.flag(FLAG),
	.fl_zf_out(zf_out),
	.fl_cf_out(cf_out)
	);


L2_MEMORY	b2v_ix_l2(
	.CLK(CLK),
	.RESET(RES),
	.data_read(l2dr),
	.data_write(l2dw),
	.set_addr(l2ds),
	.DATA_in(DATA_WIRE),
	.DATA_out(DATA_WIRE));


GPIO_PORT	b2v_ix_porta(
	.CLK(CLK),
	.RESET(RES),
	.data_read(padr),
	.data_write(dadw),
	.set_mask(pads),
	.DATA_io(DATA_WIRE),
	.PORT(PORTA)
	
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


SDRAM_CTRL	b2v_ix_SDRAM(
	.CLK(CLK),
	.RESET(RES),
	
	
	
	
	.DATA(ALU_COM)
	
	
	
	
	
	
	
	
	
	
	
	
	);


STACK	b2v_ix_stack(
	.CLK(CLK),
	.RESET(RES),
	
	
	.DATA(DATA_WIRE),
	.flag(FLAG)
	
	);


endmodule
