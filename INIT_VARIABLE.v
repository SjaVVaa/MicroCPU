//sysyem parameters
`define NUMBER_WIDTH_DATA_WIRE 8
`define ALU_NUM_COMMANDS 8
`define COMMAND_LEN_WIRE	16

`define 	OPER1 	COMMAND_INPUT[7:4]
`define	OPER2		COMMAND_INPUT[3:0]
`define	COMMIMP	COMMAND_INPUT[15:8]
`define	COMMDAT	COMMAND_INPUT[7:0]

//			--- CORE ---
// COMMANDs SYSTEM					OP1	OP2	ALU	IP			flag	stack	
`define	COM_NOP		8'd0		//	x		x		x		+			x		x
`define	COM_ADD		8'd1		//	x		x		0		+			x		x
`define	COM_SUB		8'd2		//	x		x		1		+			x		x
`define	COM_EOR		8'd3		//	x		x		2		+			x		x
`define	COM_EAND		8'd4		//	x		x		3		+			x		x
`define	COM_OR		8'd5		//	x		x		4		+			x		x
`define	COM_AND		8'd6		//	x		x		5		+			x		x
`define	COM_NOT		8'd7		//	x		x		6		+			x		x
`define	COM_XOR		8'd8		//	x		x		7		+			x		x
`define	COM_LSH		8'd9		//	x		x		8		+			x		x
`define	COM_RSH		8'd10		//	x		x		9		+			x		x
`define	COM_CP		8'd11		//	x		x		10		+			x		x
`define	COM_MOV		8'd12		//	A<----B		x		+			x		x
`define	COM_LDI		8'd13		//	DX<----		x		+			x		x
`define	COM_BREQ		8'd14		//	{const}		x		new ip/+	x		x
`define	COM_BRNE		8'd15		//	{const}		x		new ip/+	x		x
`define	COM_BRCS		8'd16		//	{const}		x		new ip/+	x		x
`define	COM_BRCC		8'd17		//	{const}		x		new ip/+	x		x
`define	COM_L2MEM	8'd18		//	{const}		x		+			x		x
`define	COM_JMP		8'd19		//	{const}		x		new ip	x		x
`define	COM_PUSH		8'd20		//	stk<--A		x		+			x		+
`define 	COM_POP		8'd21		//	A<--stk		x		+			x		-
`define	COM_CALL		8'd22		//	stk<{fl,ip}	x		+			x		+
`define	COM_RET		8'd23		//	{fl,ip}<stk	x		+			x		-	
`define	COM_INT		8'd24		//			
`define	COM_INTON	8'd25		//	
`define	COM_INTOFF	8'd26		//
`define	COM_SET		8'd27		//
`define	COM_GET		8'd28		//
`define	COM_CORE		8'd29		//
`define	COM_SET_SA	
`define	COM_SET_SB
`define	COM_SET_SC
`define	COM_GET_SA	
`define	COM_GET_SB
`define	COM_GET_SC
`define	COM_STORE
`


//ADDRES SYSTEM
`define	ADR_AX		4'd0
`define	ADR_BX		4'd1
`define	ADR_CX		4'd2
`define	ADR_DX		4'd3
`define	ADR_ACC		4'd4
`define	ADR_L2MEM	4'd5


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