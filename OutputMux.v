/******************************************************************* 
* Name:
*	OutputMux.v
* Description:
* 	This module is Multiplexer 32 to 1 bus lines.
* Inputs:
*	Selector: 5 bits selector 
*  RegWrite: Write enable signal
* Outputs:
* 	Enable: Enable selection
* Versión:  
*	1.1
* Author: 
*	José Antonio Rodríguez Castañeda  md193781
* Date :
*	V1.0       04/10/2018
* 
*********************************************************************/
module OutputMux
#(
	parameter N = 32,
	parameter WORD_LENGTH = 32
)
(
	// Input Ports
	input [4:0] Selector,
	input [(WORD_LENGTH*N) - 1 : 0] DataIN,
	/*
	input [WORD_LENGTH-1:0] DataIN0,
	input [WORD_LENGTH-1:0] DataIN1,
	input [WORD_LENGTH-1:0] DataIN2,
	input [WORD_LENGTH-1:0] DataIN3,
	input [WORD_LENGTH-1:0] DataIN4,
	input [WORD_LENGTH-1:0] DataIN5,
	input [WORD_LENGTH-1:0] DataIN6,
	input [WORD_LENGTH-1:0] DataIN7,
	input [WORD_LENGTH-1:0] DataIN8,
	input [WORD_LENGTH-1:0] DataIN9,
	input [WORD_LENGTH-1:0] DataIN10,
	input [WORD_LENGTH-1:0] DataIN11,
	input [WORD_LENGTH-1:0] DataIN12,
	input [WORD_LENGTH-1:0] DataIN13,
	input [WORD_LENGTH-1:0] DataIN14,
	input [WORD_LENGTH-1:0] DataIN15,
	input [WORD_LENGTH-1:0] DataIN16,
	input [WORD_LENGTH-1:0] DataIN17,
	input [WORD_LENGTH-1:0] DataIN18,
	input [WORD_LENGTH-1:0] DataIN19,
	input [WORD_LENGTH-1:0] DataIN20,
	input [WORD_LENGTH-1:0] DataIN21,
	input [WORD_LENGTH-1:0] DataIN22,
	input [WORD_LENGTH-1:0] DataIN23,
	input [WORD_LENGTH-1:0] DataIN24,
	input [WORD_LENGTH-1:0] DataIN25,
	input [WORD_LENGTH-1:0] DataIN26,
	input [WORD_LENGTH-1:0] DataIN27,
	input [WORD_LENGTH-1:0] DataIN28,
	input [WORD_LENGTH-1:0] DataIN29,
	input [WORD_LENGTH-1:0] DataIN30,
	input [WORD_LENGTH-1:0] DataIN31,
	*/
	
	// Output Ports
	output [WORD_LENGTH-1:0] Mux_Output

);

reg [WORD_LENGTH-1:0] Mux_logic;

always@(Selector, DataIN) begin
	case(Selector)
		0 : Mux_logic = DataIN[WORD_LENGTH-1:0];
		1 : Mux_logic = DataIN[(WORD_LENGTH*2)-1:WORD_LENGTH];
		2 : Mux_logic = DataIN[(WORD_LENGTH*3)-1:(WORD_LENGTH*2)]; 
		3 : Mux_logic = DataIN[(WORD_LENGTH*4)-1:(WORD_LENGTH*3)]; 
		4 : Mux_logic = DataIN[(WORD_LENGTH*5)-1:(WORD_LENGTH*4)]; 
		5 : Mux_logic = DataIN[(WORD_LENGTH*6)-1:(WORD_LENGTH*5)]; 
		6 : Mux_logic = DataIN[(WORD_LENGTH*7)-1:(WORD_LENGTH*6)]; 
		7 : Mux_logic = DataIN[(WORD_LENGTH*8)-1:(WORD_LENGTH*7)]; 
		8 : Mux_logic = DataIN[(WORD_LENGTH*9)-1:(WORD_LENGTH*8)]; 
		9 : Mux_logic = DataIN[(WORD_LENGTH*10)-1:(WORD_LENGTH*9)]; 
		10 : Mux_logic = DataIN[(WORD_LENGTH*11)-1:(WORD_LENGTH*10)]; 
		11 : Mux_logic = DataIN[(WORD_LENGTH*12)-1:(WORD_LENGTH*11)]; 
		12 : Mux_logic = DataIN[(WORD_LENGTH*13)-1:(WORD_LENGTH*12)]; 
		13 : Mux_logic = DataIN[(WORD_LENGTH*14)-1:(WORD_LENGTH*13)]; 
		14 : Mux_logic = DataIN[(WORD_LENGTH*15)-1:(WORD_LENGTH*14)]; 
		15 : Mux_logic = DataIN[(WORD_LENGTH*16)-1:(WORD_LENGTH*15)]; 
		16 : Mux_logic = DataIN[(WORD_LENGTH*17)-1:(WORD_LENGTH*16)]; 
		17 : Mux_logic = DataIN[(WORD_LENGTH*18)-1:(WORD_LENGTH*17)]; 
		18 : Mux_logic = DataIN[(WORD_LENGTH*19)-1:(WORD_LENGTH*18)]; 
		19 : Mux_logic = DataIN[(WORD_LENGTH*20)-1:(WORD_LENGTH*19)]; 
		20 : Mux_logic = DataIN[(WORD_LENGTH*21)-1:(WORD_LENGTH*20)]; 
		21 : Mux_logic = DataIN[(WORD_LENGTH*22)-1:(WORD_LENGTH*21)]; 
		22 : Mux_logic = DataIN[(WORD_LENGTH*23)-1:(WORD_LENGTH*22)]; 
		23 : Mux_logic = DataIN[(WORD_LENGTH*24)-1:(WORD_LENGTH*23)]; 
		24 : Mux_logic = DataIN[(WORD_LENGTH*25)-1:(WORD_LENGTH*24)]; 
		25 : Mux_logic = DataIN[(WORD_LENGTH*26)-1:(WORD_LENGTH*25)]; 
		26 : Mux_logic = DataIN[(WORD_LENGTH*27)-1:(WORD_LENGTH*26)]; 
		27 : Mux_logic = DataIN[(WORD_LENGTH*28)-1:(WORD_LENGTH*27)]; 
		28 : Mux_logic = DataIN[(WORD_LENGTH*29)-1:(WORD_LENGTH*28)]; 
		29 : Mux_logic = DataIN[(WORD_LENGTH*30)-1:(WORD_LENGTH*29)]; 
		30 : Mux_logic = DataIN[(WORD_LENGTH*31)-1:(WORD_LENGTH*30)]; 
		31 : Mux_logic = DataIN[(WORD_LENGTH*32)-1:(WORD_LENGTH*31)]; 
		default : Mux_logic = DataIN[WORD_LENGTH-1:0];
	
	endcase
		
end

assign Mux_Output = Mux_logic;

endmodule