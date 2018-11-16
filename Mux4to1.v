/******************************************************************
* Description
*	This is a  an 2to1 multiplexer that can be parameterized in its bit-width.
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	01/03/2014
******************************************************************/

module Mux4to1
#(
	parameter WORD_LENGTH = 8
)
(
	input [1 : 0] Selector,
	input [WORD_LENGTH - 1 : 0] MUX_Data0,
	input [WORD_LENGTH - 1 : 0] MUX_Data1,
	input [WORD_LENGTH - 1 : 0] MUX_Data2,
	input [WORD_LENGTH - 1 : 0] MUX_Data3,
	
	output [WORD_LENGTH - 1 : 0] MUX_Output

);


wire [WORD_LENGTH - 1 : 0] Mux1_to_Mux3;
wire [WORD_LENGTH - 1 : 0] Mux2_to_Mux3;


Mux2to1
#(
	.WORD_LENGTH(WORD_LENGTH)
)
Multiplexer_1
(
	.Selector(Selector[0]),
	.MUX_Data0(MUX_Data0),
	.MUX_Data1(MUX_Data1),
	
	.MUX_Output(Mux1_to_Mux3)

);




Mux2to1
#(
	.WORD_LENGTH(WORD_LENGTH)
)
Multiplexer_2
(
	.Selector(Selector[0]),
	.MUX_Data0(MUX_Data2),
	.MUX_Data1(MUX_Data3),
	
	.MUX_Output(Mux2_to_Mux3)

);




Mux2to1
#(
	.WORD_LENGTH(WORD_LENGTH)
)
Multiplexer_3
(
	.Selector(Selector[1]),
	.MUX_Data0(Mux1_to_Mux3),
	.MUX_Data1(Mux2_to_Mux3),
	
	.MUX_Output(MUX_Output)

);



endmodule