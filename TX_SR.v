 /******************************************************************* 
* Name:
*	TX_SR.v
* Description:
* 	This module is a shift register with parameter for RX of the UART.
* Inputs:
*  SerialDataIn: Serial Data Input 
*	clk: Clock signal 
*  reset: Reset signal
*  shift: Shift enable input
*  load:  Load signal
*	DATATX: 8 bit input data to be transmited
*  transmit_int: Internal transmit trigger signal
* Outputs:
* 	SerialDataOut: Serial DAta Out signal
* Versión:  
*	1.0
* Author: 
*	José Antonio Rodríguez Castañeda  md193781
* Date :
*	V1.0       01/11/2018
* 
*********************************************************************/

module TX_SR
#(
	parameter WORD_LENGTH = 8
)

(

	input clk,
	input reset,
	input shift,
	input load,
	input [WORD_LENGTH - 1 : 0] DataTX,
	input transmit_int,
	
	output SerialDataOut

);

reg [WORD_LENGTH+2 : 0] DataTX_reg;
wire parity_wir;

always @(posedge clk or negedge reset) 
begin
	if(reset==1'b0) 
	begin
		DataTX_reg <= {(WORD_LENGTH+1) {1'b0}};
	end
	
	else 
		if (load)
			DataTX_reg <= {1'b1, parity_wir ,DataTX , 1'b0};
		else
			if (shift)
				DataTX_reg <= {1'b0 , DataTX_reg[WORD_LENGTH+2:1]};
			else
				DataTX_reg <= DataTX_reg;

end

assign parity_wir = DataTX[7] ^ DataTX[6] ^ DataTX[5] ^ DataTX[4] ^ DataTX[3] ^ DataTX[2] ^ DataTX[1] ^ DataTX[0];
assign SerialDataOut = (transmit_int == 1) ?  DataTX_reg[0] : 1'b1;


endmodule