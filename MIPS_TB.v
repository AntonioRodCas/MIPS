/*********************************************************
* Description:
* This module is test bench file for testing the MRC module
*
*
*	Author:  Antonio Rodríguez    md193781   ITESO 
*	Date:    14/10/18
*
**********************************************************/ 
 
 
 
module MIPS_TB;

parameter WORD_LENGTH = 32;
parameter NBITS = 8;


reg clk_tb = 0;
reg reset_tb;
reg TX_flag_tb;
reg start_tb;



wire SerialOutEn_tb;
wire [WORD_LENGTH-1:0] SerialData_tb;


MIPS
#(
	.WORD_LENGTH(WORD_LENGTH),
	.NBITS(NBITS)
)
MIPS_1
(
	.clk(clk_tb),
	.reset(reset_tb),
	.TX_flag(TX_flag_tb),
	.start(start_tb),
	
	
	.SerialOutEn(SerialOutEn_tb),
	.SerialData(SerialData_tb)

);

/*********************************************************/
initial // Clock generator
  begin
    forever #2 clk_tb = !clk_tb;
  end
/*********************************************************/
initial begin // reset generator
   #0 reset_tb = 0;
   #5 reset_tb = 1;
end

initial begin // reset generator
   #0 TX_flag_tb = 0;
   #300 TX_flag_tb = 1;
	#5 TX_flag_tb = 0;
	#100 TX_flag_tb = 1;
	#5 TX_flag_tb = 0;
	#25 TX_flag_tb = 1;
	#5 TX_flag_tb = 0;
end

initial begin // reset generator
   #0 start_tb = 0;
   #10 start_tb = 1;
end

endmodule