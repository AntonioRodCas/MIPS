/******************************************************************* 
* Name:
*	PC.v
* Description:
* 	This module is parameterizable Program Counter
* Inputs:
*	clk: Clock signal 
*  reset: Reset signal
*	enable: Enable input
* Outputs:
* 	PC: Program Counter
* Versión:  
*	1.0
* Author: 
*	José Antonio Rodríguez Castañeda  md193781
* Date :
*	V1.0       15/11/2018
* 
*********************************************************************/
module MIPS
#(
	// Parameter Declarations
	parameter WORD_LENGTH = 32,
	parameter NBITS = 8         //Program counter bits
)

(
	// Input Ports
	input clk,
	input reset,
	input TX_flag,
	input start,
	
	// Output Ports
	output SerialOutEn,
	output [WORD_LENGTH-1:0] SerialData

);

//Internal connections

wire PCen;												
wire [WORD_LENGTH-1:0] PC_out;					
wire [WORD_LENGTH-1:0] PC_R;

wire [WORD_LENGTH-1:0] Mem_addr_in;
wire IorD;												
wire IRWrite;											
wire [WORD_LENGTH-1:0] Instr;
wire DRWrite;											
wire [WORD_LENGTH-1:0] Data;

wire RegWrite;											
wire [4:0] A3_MUX_Out;
wire RegDst;											
wire MemtoReg;											
wire [WORD_LENGTH-1:0] WD3_MUX_Out;
wire [WORD_LENGTH-1:0] RD1;
wire [WORD_LENGTH-1:0] RD2;
wire [WORD_LENGTH-1:0] A;
wire [WORD_LENGTH-1:0] B;

wire [WORD_LENGTH-1:0] SignImm;

wire ALUSrcA;											
wire [WORD_LENGTH-1:0] SrcA;
wire [1:0] ALUSrcB;									
wire [WORD_LENGTH-1:0] SrcB;

wire [WORD_LENGTH-1:0] ALUResult;
wire ALU_en;											
wire [WORD_LENGTH-1:0] ALUout;
wire [WORD_LENGTH-1:0] carry;
wire [4:0] ALUControl;								

wire PCSrc;												


wire MemWrite;											
wire Page;												
wire [WORD_LENGTH-1:0] Memory_out;


//Assignations

assign SerialData = ALUout;


//MIPS instance

//-----------------------PC Register-----------------------------------
Register
#(
	.WORD_LENGTH(WORD_LENGTH)
) 
PC_Register			            	//PC Register instance
(
	.clk(clk),
	.reset(reset),
	.enable(PCen),
	.Data_Input(PC_R),
	
	.Data_Output(PC_out)

);



//-----------------------PC Mux-----------------------------------
Mux2to1
#(
	.WORD_LENGTH(WORD_LENGTH)
) 
PC_MUX			            	//Program Counter MUX instance
(
	.Selector(IorD),
	.MUX_Data0(PC_out),
	.MUX_Data1(ALUout),
	
	.MUX_Output(Mem_addr_in)

);

//-----------------------I_D_Memory-----------------------------------
I_D_Memory
#(
	.DATA_WIDTH(WORD_LENGTH), 
	.ADDR_WIDTH(WORD_LENGTH),
	.DEPTH(50)
) 
Main_Memory			            	//Intruction and Data Memory (ROM/RAM)
(
	.WD(B),
	.Addr(Mem_addr_in),
	.we(MemWrite),
	.clk(clk),
	.Page(Page),
	
	.q(Memory_out)

);

//-----------------------Instruction Register-----------------------------------
Register
#(
	.WORD_LENGTH(WORD_LENGTH)
) 
Ints_Register			            	//Instruction Register instance
(
	.clk(clk),
	.reset(reset),
	.enable(IRWrite),
	.Data_Input(Memory_out),
	
	.Data_Output(Instr)

);

//-----------------------Data Register-----------------------------------
Register
#(
	.WORD_LENGTH(WORD_LENGTH)
) 
Data_Register			            	//Data Register instance
(
	.clk(clk),
	.reset(reset),
	.enable(DRWrite),
	.Data_Input(Memory_out),
	
	.Data_Output(Data)

);

//-----------------------Register File-----------------------------------
RegisterFile
#(
	.WORD_LENGTH(WORD_LENGTH),
	.N(32)
) 
Reg_File			            	//Register File instance
(
	.clk(clk),
	.reset(reset),
	.RegWrite(RegWrite),
	.WriteRegister(A3_MUX_Out),
	.ReadRegister1(Instr[25:21]),
	.ReadRegister2(Instr[20:16]),
	.WriteData(WD3_MUX_Out),
	.ReadData1(RD1),
	.ReadData2(RD2)

);

//-----------------------A3 Mux-----------------------------------
Mux2to1
#(
	.WORD_LENGTH(WORD_LENGTH)
) 
A3_MUX			            	//A3 input of the Reg File MUX instance
(
	.Selector(RegDst),
	.MUX_Data0(Instr[20:16]),
	.MUX_Data1(Instr[15:11]),
	
	.MUX_Output(A3_MUX_Out)

);

//-----------------------WD Reg File Mux-----------------------------------
Mux2to1
#(
	.WORD_LENGTH(WORD_LENGTH)
) 
WD_RF_MUX			            	//WD3 input of the Reg File MUX instance
(
	.Selector(MemtoReg),
	.MUX_Data0(ALUout),
	.MUX_Data1(Data),
	
	.MUX_Output(WD3_MUX_Out)

);

//-----------------------A Register-----------------------------------
Register
#(
	.WORD_LENGTH(WORD_LENGTH)
) 
A_Register			            	//A Register instance
(
	.clk(clk),
	.reset(reset),
	.enable(1'b1),
	.Data_Input(RD1),
	
	.Data_Output(A)

);

//-----------------------B Register-----------------------------------
Register
#(
	.WORD_LENGTH(WORD_LENGTH)
) 
B_Register			            	//B Register instance
(
	.clk(clk),
	.reset(reset),
	.enable(1'b1),
	.Data_Input(RD2),
	
	.Data_Output(B)

);


//----------------------Sign Extend-----------------------------------
SignExtend
#(
	.WORD_LENGTH(WORD_LENGTH)
) 
SignExt			            	//Sign Extend module instance
(
	.Data(Instr[15:0]),
	.SignImm(SignImm)

);


//-----------------------ALU src A Mux-----------------------------------
Mux2to1
#(
	.WORD_LENGTH(WORD_LENGTH)
) 
ALU_A_MUX			            	//ALU A MUX instance
(
	.Selector(ALUSrcA),
	.MUX_Data0(PC_out),
	.MUX_Data1(A),
	
	.MUX_Output(SrcA)

);

//-----------------------ALU src B Mux-----------------------------------
Mux4to1
#(
	.WORD_LENGTH(WORD_LENGTH)
) 
ALU_B_MUX			            	//ALU B MUX instance
(
	.Selector(ALUSrcB),
	.MUX_Data0(B),
	.MUX_Data1(32'b1),
	.MUX_Data2(SignImm),
	.MUX_Data3({{(WORD_LENGTH-5) {1'b0}} ,Instr[10:6]}),
	
	.MUX_Output(SrcB)

);

//-----------------------ALU -----------------------------------
ALU
#(
	.WORD_LENGTH(WORD_LENGTH)
) 
ALU_ints			            	//ALU instance
(
	.A(SrcA),
	.B(SrcB),
	.control(ALUControl),
	
	.C(ALUResult),
	.carry(carry)

);

//-----------------------ALU Register-----------------------------------
Register
#(
	.WORD_LENGTH(WORD_LENGTH)
) 
ALU_Register			            	//ALU Register instance
(
	.clk(clk),
	.reset(reset),
	.enable(ALU_en),
	.Data_Input(ALUResult),
	
	.Data_Output(ALUout)

);

//-----------------------PC src  Mux-----------------------------------
Mux2to1
#(
	.WORD_LENGTH(WORD_LENGTH)
) 
PC_Src_MUX			            	//PC Src MUX instance
(
	.Selector(PCSrc),
	.MUX_Data0(ALUResult),
	.MUX_Data1(ALUout),
	
	.MUX_Output(PC_R)

);

//-----------------------Control Unit-----------------------------------
ControlUnit
#(
	.DATA_WIDTH(WORD_LENGTH)
) 
CU_Instance			            	//Control Unit instance
(
	.clk(clk),
	.reset(reset),
	.Op(Instr[31:26]),
	.Funct(Instr[5:0]), 
	.TX_flag(TX_flag),
	.start(start),
	
	// Output Ports
	.PCen(PCen),
	.IorD(IorD),
	.MemWrite(MemWrite),
	.IRWrite(IRWrite),
	.DRWrite(DRWrite),
	.RegWrite(RegWrite),
	.RegDst(RegDst),
	.MemtoReg(MemtoReg),
	.ALUSrcA(ALUSrcA),
	.ALUSrcB(ALUSrcB),
	.ALUControl(ALUControl),
	.ALU_en(ALU_en),
	.PCSrc(PCSrc),
	.Page(Page),
	.SerialOutEn(SerialOutEn)

);

endmodule