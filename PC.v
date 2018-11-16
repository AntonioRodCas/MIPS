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
module PC
#(
	// Parameter Declarations
	parameter NBITS = 8
)

(
	// Input Ports
	input clk,
	input reset,
	input enable,
	
	// Output Ports
	output [NBITS-1 : 0] PC

);


reg [NBITS-1 : 0] counter_reg;

	always@(posedge clk or negedge reset) begin
		if (reset == 1'b0)
			counter_reg <= {NBITS{1'b0}};
		else
			if(enable == 1'b1)
				counter_reg <= counter_reg + 1'b1;
			else
				counter_reg <= counter_reg;
	end

//----------------------------------------------------
assign PC = counter_reg;
//----------------------------------------------------

endmodule