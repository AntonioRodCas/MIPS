/******************************************************************* 
* Name:
*	clk_gen.v
* Description:
* 	This module is a register with parameter.
*   -Modified to have enable signal. (01/09/18)
* Inputs:
*	clk: Clock signal 
*  reset: Reset signal
*	Data_Input: Data to register 
*	enable: Enable input
* Outputs:
* 	Data_Output: Data to provide lached data
* Versión:  
*	1.1
* Author: 
*	José Antonio Rodríguez Castañeda   md193781
* Date: 
*	V1.0       22/11/2018
* 
*********************************************************************/

 module clk_gen
 (
	// Input Ports
	input clk,
	input reset,

	output clk_out
);

wire int_clk;
wire int_reset;

assign int_reset = ~reset;

PLL	PLL_inst (
	.areset ( int_reset ),
	.inclk0 ( clk),
	.c0 ( int_clk )
	);

	

ClkDiv
#(
	.FREQUENCY(153_846),
	.REFERENCE_CLOCK (16_000_000),
	.NBITS(32)
) 
clk_div			   	//Multiplier shift register
(
	.clk_in(int_clk),
	.reset(reset),
	
	.clk_out(clk_out)

);

endmodule
