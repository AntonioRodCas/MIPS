/******************************************************************* 
* Name:
*	RX_SR.v
* Description:
* 	This module is a shift register with parameter for RX of the UART.
* Inputs:
*  SerialDataIn: Serial Data Input 
*	clk: Clock signal 
*  reset: Reset signal
*  shift: Shift enable input
* Outputs:
* 	DataRX: Parallel Data Output
*  parity: parity bit received 
*  parity_int: calculated parity bit over RX data
* Versión:  
*	1.0
* Author: 
*	José Antonio Rodríguez Castañeda  md193781
* Date :
*	V1.0       24/10/2018
* 
*********************************************************************/

module RX_SR
#(
	parameter WORD_LENGTH = 8
)

(
	input SerialDataIn,
	input clk,
	input reset,
	input shift,
	
	output [WORD_LENGTH - 1 : 0] DataRX,
	
	output parity,
	output parity_int

);

reg [WORD_LENGTH : 0] DataRX_reg;

always @(posedge clk or negedge reset) 
begin
	if(reset==1'b0) 
	begin
		DataRX_reg<= {(WORD_LENGTH) {1'b0}};
	end
	
	else 
		if (shift)
			DataRX_reg<={SerialDataIn , DataRX_reg[WORD_LENGTH:1]};
	
		else
			DataRX_reg<=DataRX_reg;

end

assign DataRX = DataRX_reg [WORD_LENGTH-1:0];
assign parity = DataRX_reg [WORD_LENGTH];

assign parity_int  = DataRX[7] ^ DataRX[6] ^ DataRX[5] ^ DataRX[4] ^ DataRX[3] ^ DataRX[2] ^ DataRX[1] ^ DataRX[0];

endmodule