//sysyem parameters
`define NUMBER_WIDTH_DATA_WIRE 8
`define ALU_NUM_COMMANDS 8
`define COMMAND_LEN_WIRE	16

`define 	OPER1 	COMMAND_INPUT[7:4]
`define	OPER2		COMMAND_INPUT[3:0]
`define	COMMIMP	COMMAND_INPUT[13:8]
`define	COMMDAT	COMMAND_INPUT[7:0]

//			--- CORE ---
// COMMANDs SYSTEM					OP1			OP2		ALU		IP			flag	stack	
//-------------------------------------------------------------------
//[HYPTR][INT][C5][C4][C3][C2][C1][C0][D7][D6][D5][D4][D3][D2][D1][D0]
//-------------------------------------------------------------------
`define	COM_NOP		8'd0		//	x			x		x		+			x		x
//------------------------------------------------------------------- ALU
`define	COM_ADD		8'd1		//	x			x		0		+			x		x		+
`define	COM_SUB		8'd2		//	x			x		1		+			x		x		-
`define	COM_EOR		8'd3		//	x			x		2		+			x		x		||
`define	COM_EAND	8'd4		//	x			x		3		+			x		x		&&
`define	COM_OR		8'd5		//	x			x		4		+			x		x		|
`define	COM_AND		8'd6		//	x			x		5		+			x		x		&
`define	COM_NOT		8'd7		//	x			x		6		+			x		x		!
`define	COM_XOR		8'd8		//	x			x		7		+			x		x		^
`define	COM_LSH		8'd9		//	x			x		8		+			x		x		<<
`define	COM_RSH		8'd10		//	x			x		9		+			x		x		>>
`define	COM_CP		8'd11		//	x			x		10		+			x		x		-
//------------------------------------------------------------------- REG
`define	COM_MOV		8'd12		//	A<----B		x		+			x		x		
`define	COM_LDI		8'd13		//	DX<----		x		+			x		x
//------------------------------------------------------------------- JMP
`define	COM_BREQ	8'd14		//	{const}		x		new ip/+	x		x		fZ				
`define	COM_BRNE	8'd15		//	{const}		x		new ip/+	x		x		!fZ
`define	COM_BRCS	8'd16		//	{const}		x		new ip/+	x		x		fC
`define	COM_BRCC	8'd17		//	{const}		x		new ip/+	x		x		!fC
`define	COM_JMP		8'd18		//	{const}		x		new ip	x		x	
//------------------------------------------------------------------- SET ADDR from REG for all
`define	COM_SET		8'd19		//	A<----B		x		+			x		x	
//------------------------------------------------------------------- L2
`define	COM_L2MEM	8'd20		//	{const}		x		+			x		x		set addr
//------------------------------------------------------------------- L3
`define	COM_CORE	8'd21		// {const}		x		+			x		x		set core
`define	COM_L3MEM	8'd22		//	{const}		x		+			x		x		set addr
//------------------------------------------------------------------- FLAG
// automate for ALU comands and stack
//------------------------------------------------------------------- STACK
`define	COM_PUSH	8'd23		//	stk<--A		x		+			x		+
`define COM_POP		8'd24		//	A<--stk		x		+			x		-
`define	COM_CALL	8'd25		//	stk<{fl,ip}	x		+			x		+
`define	COM_RET		8'd26		//	{fl,ip}<stk	x		+			x		-	
//------------------------------------------------------------------- INT <<==================not working now
`define	COM_INT		8'd27		//	{const}		x		+			x		x		init programm int	
`define	COM_INTON	8'd28		//	{const}		x		+			x		x		int
`define	COM_INTOFF	8'd29		//	{const}		x		+			x		x		int
//------------------------------------------------------------------- STORE 
`define	COM_SET_SA	8'd30		//	SA<---B		x		+			x		x		set segment [A,
`define	COM_SET_SB	8'd31		//	SB<---B		x		+			x		x		set segment ,B,
`define	COM_SET_SC	8'd32		//	SC<---B		x		+			x		x		set segment ,C,IP]
`define	COM_GET_SA	8'd33		//	B<---SA		x		+			x		x		get segment [A,
`define	COM_GET_SB	8'd34		//	B<---SB		x		+			x		x		get segment ,B,
`define	COM_GET_SC	8'd35		//	B<---SC		x		+			x		x		get segment ,C,IP]
`define	COM_SA		8'd36		//	{const}		x		+			x		x		set segment [A,
`define	COM_SB		8'd37		//	{const}		x		+			x		x		set segment ,B,
`define	COM_SC		8'd38		//	{const}		x		+			x		x		set segment ,C,IP]
`define	COM_SAVE	8'd39		//	x			x		+			x		x		save data from L4 to MEM
`define	COM_LOAD	8'd40		//	x			x		+			x		x		load data from MEM to L4
//------------------------------------------------------------------- L1
`define	COM_L1MEM	8'd41		//	{const}		x		+			x		x
//------------------------------------------------------------------- MEMORY STRUCT
//0x00_00_00_00	0x0F_FF_FF_FF	BUTLOADER
//0x10_00_00_00	0x1F_FF_FF_FF	SDRAM 32MB
//0x20_00_00_00	0xFF_FF_FF_FF	ALL MEMORY  

//ADDRES SYSTEM
`define	ADR_AX		4'd0
`define	ADR_BX		4'd1
`define	ADR_CX		4'd2
`define	ADR_DX		4'd3
`define	ADR_ACC		4'd4
`define	ADR_L2MEM	4'd5
`define	ADR_FLAG	4'd6
`define	ADR_STACK	4'd7
`define	ADR_L3MEM	4'd8
`define	ADR_INT		4'd9
`define	ADR_L1MEM	4'd10


//			--- ALU ---
//functions address
`define	AL_ADD	0
`define	AL_SUB	1
`define	AL_EOR	2
`define	AL_EAND	3
`define	AL_OR		4
`define	AL_AND	5
`define	AL_NOT	6
`define	AL_XOR	7
`define	AL_LSH	8
`define	AL_RSH	9
`define 	AL_CP		10

//			--- STACK ---
`define STACK_LEN	16  //glubina
`define STACK_ADDR_LEN 5

//			--- FLAGS ---
`define FLAG_LEN	8


//			--- SDRAM ---
`define SDRAM_ADDRES 15
`define SDRAM_DATA 16
`define ROW_ADDR 13
`define BANK_ADDR 2
`define COLUMN_ADDR 9
`define BURST_LEN 3
`define CAS_LEN 3

//STORE
`define	LEN_SEGMENT 8