 /******************************************************************* 
* Name:
*	SignExtend.v
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
module SignExtend
#(
	// Parameter Declarations
	parameter WORD_LENGTH = 32
)

(
	// Input Ports
	input [(WORD_LENGTH/2)-1:0] Data,
	
	// Output Ports
	output [WORD_LENGTH-1:0] SignImm

);


wire [WORD_LENGTH-1:0] SignImm_wir;

//----------------------------------------------------
assign SignImm_wir = (Data[(WORD_LENGTH/2)-1]==1) ? {{(WORD_LENGTH/2) {1'b1}} ,Data} : {{(WORD_LENGTH/2) {1'b0}} ,Data};  //Output Ext Signed data
assign SignImm = SignImm_wir;
//----------------------------------------------------

endmodule