/******************************************************************* 
* Name:
*	InputMux.v
* Description:
* 	This module is Multiplexer with selection parameter and enable.
* Inputs:
*	WriteRegister: Register to be selected
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
module InputMux
#(
	parameter WORD_LENGTH = 32,
	parameter MUX_ID = 1
)
(
	// Input Ports
	input [4:0] WriteRegister,
	input RegWrite,

	// Output Ports
	output Enable

);

reg En_logic;

always@(WriteRegister,RegWrite) begin
	if(RegWrite == 1'b0)
		En_logic = 1'b0;
	else begin
		if(WriteRegister == MUX_ID)
			En_logic = 1'b1;
		else
			En_logic = 1'b0;
	end
		
end

assign Enable = En_logic;

endmodule