/******************************************************************* 
* Name:
*	PC.v
* Description:
* 	This module is parameterizable Program Counter
* Inputs:
*	clk: Clock signal 
*  reset: Reset signal
*	SerialDatain: Dummy RX line
* 	start: Start input line
* Outputs:
* 	SerialDataOut: UART TX output line
*	SerialOutEn_test: Test signal for Signal Tap
* Versión:  
*	1.0
* Author: 
*	José Antonio Rodríguez Castañeda  md193781
* Date :
*	V1.0       15/11/2018
* 
*********************************************************************/
module MIPS_FPGA
#(
	// Parameter Declarations
	parameter WORD_LENGTH = 32,
	parameter NBITS = 8         //Program counter bits
)

(
	// Input Ports
	input clk,
	input reset,
	input SerialDataIn,
	input start,
	
	// Output Ports
	output SerialDataOut,
	output SerialOutEn_test
	//output [7:0] TX_D_test

);

//Internal Connections

wire clk_int;
wire SerialOutEn;
wire [WORD_LENGTH-1:0] SerialData;
wire TX_flag;

wire Clear_RX_Flag;
wire [7:0] DATARX;
wire RX_FLAG;
wire ParityError;

wire start_int;
wire start_neg;


One_Shot
 ShotModule
(
	// Input Ports
	.clk(clk_int),
	.reset(reset),
	.Start(start_neg),

	// Output Ports
	.Shot(start_int)
);


//------------------Assign Process

assign SerialOutEn_test = SerialOutEn;
assign start_neg = ~start;
//assign TX_D_test = SerialData[7:0];


//Modules instance---------------------------------------

clk_gen
clock_gen			   	//Clock Divider with PLL to generate 153.846kHz
(
	.clk(clk),
	.reset(reset),
	
	.clk_out(clk_int)

);


MIPS
#(
	.WORD_LENGTH(WORD_LENGTH),
	.NBITS(NBITS)
) 
PC_Register			            	//MIPS instance
(
	.clk(clk_int),
	.reset(reset),
	.TX_flag(TX_flag),
	.start(start_int),
	
	.SerialOutEn(SerialOutEn),
	.SerialData(SerialData)

);


UART
#(
	.WORD_LENGTH(8)
) 
UART_inst			  					 	//UART instance
(
	.SerialDataIn(SerialDataIn),
	.clk (clk_int),
	.reset(reset),
	.Clear_RX_Flag(Clear_RX_Flag),
	.DATATX(SerialData[7:0]),
	.Transmit(SerialOutEn),
	
	.DATARX(DATARX),
	.RX_FLAG(RX_FLAG),
	.SerialDataOut(SerialDataOut),
	.ParityError(ParityError),
	.TX_flag(TX_flag)

);




endmodule

