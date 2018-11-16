/******************************************************************* 
* Name:
*	simple_dual_port_ram_single_clock.v
* Description:
* 	This module is a parameterized RAM blocks
*  data: Parallel input data 
*	read_addr: Read Address input 
*  write_addr: Write Address input
*  we: Write Enable input line
*	clk: Input Clock signal
* Outputs:
* 	q: Output parallel data
* Versión:  
*	1.0
* Author: 
*	José Antonio Rodríguez Castañeda  md193781
* Date :
*	V1.0       01/11/2018
* 
*********************************************************************/
module single_port_ram
#
(parameter DATA_WIDTH=32, parameter ADDR_WIDTH=32, parameter DEPTH=50)
(
	input [(DATA_WIDTH-1):0] data,
	input [(ADDR_WIDTH-1):0] addr, 
	input we, 
	input clk,
	
	output [(DATA_WIDTH-1):0] q
);


reg [DATA_WIDTH-1:0] ram [DEPTH-1:0];

always @(posedge clk)
begin
	if (we)
		ram[addr] <= data;
	//q <= ram[read_addr]; 
end


assign q = ram[addr];

endmodule
