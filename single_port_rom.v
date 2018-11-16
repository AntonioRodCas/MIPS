 /******************************************************************* 
* Name:
*	single_port_rom.v
* Description:
* 	This module is parameterizable rom 
* Inputs:
*	addr: Address input signal  
*  clk: Clock signal
* Outputs:
* 	q: Data[@addr] output from the rom
* Versión:  
*	1.0
* Author: 
*	José Antonio Rodríguez Castañeda  md193781
* Date :
*	V1.0       15/11/2018
* 
*********************************************************************/
module single_port_rom
#(
	//Parameter Declarations
	parameter DATA_WIDTH=32, 
	parameter ADDR_WIDTH=32,
	parameter DEPTH=50
)
(
	//Input ports
	input [(ADDR_WIDTH-1):0] addr,
	input clk,
	
	output reg [(DATA_WIDTH-1):0] q
);

reg [DATA_WIDTH-1:0] rom[DEPTH-1:0];

initial
begin
	$readmemh("tex.dat", rom);
end

always @(posedge clk)
begin
	q <= rom[addr];
end


endmodule