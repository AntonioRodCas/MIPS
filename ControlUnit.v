 /******************************************************************* 
* Name:
*	ControlUnit.v
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
*	V1.0       18/11/2018
* 
*********************************************************************/
module ControlUnit
#(
	// Parameter Declarations
	parameter DATA_WIDTH=32
)

(
	// Input Ports
	input clk,
	input reset,
	input [5:0] Op,
	input [5:0] Funct, 
	
	// Output Ports
	output reg PCen,
	output reg IorD,
	output reg MemWrite,
	output reg IRWrite,
	output reg DRWrite,
	output reg RegWrite,
	output reg RegDst,
	output reg MemtoReg,
	output reg ALUSrcA,
	output reg [1:0] ALUSrcB,
	output reg [4:0] ALUControl,
	output reg ALU_en,
	output reg PCSrc,
	output reg Page,
	output reg SerialOutEn

);

//State machine states   ############FSM########
localparam IFetch = 0;
localparam IDecode = 1;
localparam IMemAccStore = 2;
localparam IMemAccLoad = 3;
localparam IWrBckR = 4;
localparam IWrBckI = 5;
localparam IWrBckL = 6;
localparam IWrBckS = 7;
localparam IWrBckU = 8;

localparam addi = 9;
localparam add = 10;
localparam sll = 11;
localparam Ior = 12;
localparam andi = 13;
localparam sw = 14;
localparam lw = 15;
localparam UART = 16;


reg [4:0]State /*synthesis keep*/ ;



always@(posedge clk or negedge reset) begin
	if (reset==0)
		State <= IFetch;
	else 
		case(State)
			IFetch:
				State <= IDecode;
				
			IDecode:
				case(Op)
				6'b000000: begin
									case(Funct)
										6'b000000: State <= sll;
										6'b010100: State <= UART;
										6'b100000: State <= add;
										6'b100101: State <= Ior;
										default: State <= IFetch;
									endcase
							  end
				6'b001000: State <= addi;
				6'b001100: State <= andi;
				6'b101011: State <= sw;
				6'b100011: State <= lw;
				default: State <= IFetch;
				endcase
	
			sll:
				State <= IWrBckR;
				
			UART:
				State <= IWrBckU;
			
			add:
				State <= IWrBckR;
			
			Ior:
				State <= IWrBckR;
			
			addi:
				State <= IWrBckI;
			
			andi:
				State <= IWrBckI;
			
			sw:
				State <= IMemAccStore;
				
			lw: 
				State <= IMemAccLoad;	
				
			IMemAccStore:
				State <= IWrBckS;
			
			IMemAccLoad:
				State <= IWrBckL;
			
			IWrBckR:
				State <= IFetch;
				
			IWrBckI:
				State <= IFetch;
				
			IWrBckL:
				State <= IFetch;
				
			IWrBckS:
				State <= IFetch;
				
			default:
				State <= IFetch;
	endcase
end


always@(State) begin
	PCen = 0;
	IorD = 0;
	MemWrite = 0;
	IRWrite = 0;
	DRWrite = 0;
	RegWrite = 0;
	RegDst = 0;
	MemtoReg = 0;
	ALUSrcA = 0;
	ALUSrcB = 2'b00;
	ALUControl = 5'b00000;
	ALU_en = 0;
	PCSrc = 0;
	Page = 0;
	SerialOutEn = 0;
		case(State)
			
			IFetch:
				begin
					IorD = 0;
					PCen = 1;
					IRWrite = 1;
					ALUSrcA = 0;
					ALUSrcB = 2'b01;
					ALUControl = 5'b00000;
					PCSrc = 0;
				end
			
			sll:
				begin
					ALUSrcA = 1;
					ALUSrcB = 2'b11;
					ALUControl = 5'b11000;
					ALU_en = 1;
				end
			
			add:
				begin
					ALUSrcA = 1;
					ALUSrcB = 2'b00;
					ALUControl = 5'b00000;
					ALU_en = 1;
				end
			
			Ior:
				begin
					ALUSrcA = 1;
					ALUSrcB = 2'b00;
					ALUControl = 5'b00110;
					ALU_en = 1;
				end
			
			addi:
				begin
					ALUSrcA = 1;
					ALUSrcB = 2'b10;
					ALUControl = 5'b00000;
					ALU_en = 1;
				end
			
			andi:
				begin
					ALUSrcA = 1;
					ALUSrcB = 2'b10;
					ALUControl = 5'b00101;
					ALU_en = 1;
				end
			
			sw:
				begin 
					ALUSrcA = 1;
					ALUSrcB = 2'b10;
					ALUControl = 5'b00000;
					ALU_en = 1;
				end
			
			lw:
				begin
					ALUSrcA = 1;
					ALUSrcB = 2'b10;
					ALUControl = 5'b00000;
					ALU_en = 1;
				end
			
			UART:
				begin
					ALUSrcA = 1;
					ALUControl = 5'b01111;
					ALU_en = 1;
				end
			
			IMemAccStore:
				begin
					IorD = 1;
					MemWrite = 1;
				end
		
			IMemAccLoad:
				begin
					IorD = 1;
					DRWrite = 1;
					Page = 1;
				end

	
			IWrBckR:
				begin
					RegDst = 1;
					MemtoReg = 0;
					RegWrite = 1;
				end
			
			IWrBckI:
				begin
					RegDst = 0;
					MemtoReg = 0;
					RegWrite = 1;
				end
			
			IWrBckL:
				begin
					RegDst = 0;
					MemtoReg = 1;
					RegWrite = 1;
				end
				
			IWrBckU:
				begin
					SerialOutEn = 1;
				end
			
			default:
				begin
					PCen = 0;
					IorD = 0;
					MemWrite = 0;
					IRWrite = 0;
					DRWrite = 0;
					RegWrite = 0;
					RegDst = 0;
					MemtoReg = 0;
					ALUSrcA = 0;
					ALUSrcB = 2'b00;
					ALUControl = 5'b00000;
					ALU_en = 0;
					PCSrc = 0;
					Page = 0;
				end
		endcase
end







endmodule