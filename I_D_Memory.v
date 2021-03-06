 /******************************************************************* 
* Name:
*	PC.v
* Description:
* 	This module is parameterizable Program Counter
* Inputs:
*	WD: Write Data port
*	Addr: Address port
*	we: Write Enable
*	clk: Clock input signal
*	Page: Page selector ROM/RAM
* Outputs:
* 	q: Data Output
* Versión:  
*	1.0
* Author: 
*	José Antonio Rodríguez Castañeda  md193781
* Date :
*	V1.0       15/11/2018
* 
*********************************************************************/
module I_D_Memory
#(
	// Parameter Declarations
	parameter DATA_WIDTH=32, 
	parameter ADDR_WIDTH=32,
	parameter DEPTH=50
)

(
	// Input Ports
	input [(DATA_WIDTH-1):0] WD,
	input [(ADDR_WIDTH-1):0] Addr, 
	input we, 
	input clk,
	input Page,
	
	// Output Ports
	output [(DATA_WIDTH-1):0] q

);

// Internal wiring
wire [(DATA_WIDTH-1):0] ROM_out;
wire [(DATA_WIDTH-1):0] RAM_out;


//-----------------------ROM instance-----------------------------------
single_port_rom
#(
	.DATA_WIDTH(DATA_WIDTH), 
	.ADDR_WIDTH(ADDR_WIDTH),
	.DEPTH(DEPTH)
) 
ROM_inst			   	//ROM memory instance
(
	.addr(Addr),
	.clk(clk),
	
	.q(ROM_out)

);


//-----------------------RAM instance-----------------------------------
single_port_ram
#(
	.DATA_WIDTH(DATA_WIDTH), 
	.ADDR_WIDTH(ADDR_WIDTH),
	.DEPTH(DEPTH)
) 
RAM_inst			   	//RAM memory instance
(
	.data(WD),
	.addr(Addr),
	.we(we),
	.clk(clk),
	
	.q(RAM_out)

);

//----------------------------------------------------
assign q = (Page==1) ? RAM_out : ROM_out;  //Output MUX
//----------------------------------------------------

endmodule