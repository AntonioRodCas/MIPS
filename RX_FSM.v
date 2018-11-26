/******************************************************************* 
* Name:
*	RX_FSM.v
* Description:
* 	This is a Finite State Machine for RX module of the UART
* Inputs:
*  SerialDataIn: Serial Data Input 
*	clk: Clock signal 
*  reset: Reset signal
*	parity: parity bit from RX Shift Register
* Outputs:
*  shift: Shift enable input
*  ready: Ready flag signal
* Versión:  
*	1.0
* Author: 
*	José Antonio Rodríguez Castañeda  md193781
* Date :
*	V1.0       25/10/2018
* 
*********************************************************************/

module RX_FSM
#(
	parameter WORD_LENGTH = 8
)

(
	input SerialDataIn,
	input clk,
	input reset,
	input parity,
	
	output reg shift_RX,
	output reg ready

);

reg sampling_enable;
wire sampling_flag;
reg count_enable;
wire count_flag;
reg SB_enable;
wire SB_flag;



FlagCounter
#(
	.NBITS(8),
	.VALUE(13)
) 
FSM_sampling 		   	        //Counter for the FSM bit sampling 
(
	.clk(clk),
	.reset(reset),
	.enable(sampling_enable),
	
	.flag(sampling_flag)

);

FlagCounter
#(
	.NBITS(8),
	.VALUE(((WORD_LENGTH+1)*16)+9)
) 
FSM_counter 		   	        //Counter for the FSM bit counting
(
	.clk(clk),
	.reset(reset),
	.enable(count_enable),
	
	.flag(count_flag)

);

FlagCounter
#(
	.NBITS(8),
	.VALUE(9)
) 
FSM_startbit 		   	        //Counter for the FSM bit counting
(
	.clk(clk),
	.reset(reset),
	.enable(SB_enable),
	
	.flag(SB_flag)

);


//State machine states   ############TBD########
localparam IDLE = 0;
localparam STARTBIT = 1;
localparam SAMPLING = 2;
localparam SHIFT = 3;
localparam BIT = 4; 
localparam STOPBIT = 5;
localparam READY = 6;


reg [4:0]State /*synthesis keep*/ ;

always@(posedge clk or negedge reset) begin
	if (reset==0)
		State <= IDLE;
	else 
		case(State)
			IDLE:
				if(SerialDataIn == 0 )
					State <= STARTBIT;
				else 
					State <= IDLE;
					
			STARTBIT:
				if(SB_flag == 1 )
					State <= SAMPLING;
				else
					State <= STARTBIT;
			
			SAMPLING:
				if(sampling_flag == 1 )
						State <= SHIFT;
				else
						State <= SAMPLING;
				
			SHIFT:
				State <= BIT;
			
			BIT:
				if(count_flag == 1 )
					State <= STOPBIT;
				else
					State <= SAMPLING;
			
			STOPBIT:
				if(SB_flag == 1 )
					State <= READY;
				else
					State <= STOPBIT;
					
			READY:
				State <= IDLE;	
					
			default:
				State <= IDLE;
	endcase
end

always@(State) begin
	sampling_enable = 0;
	count_enable = 0;
	SB_enable = 0;
	shift_RX = 0;
	ready = 0;
		case(State)
				
			STARTBIT:
				begin
					SB_enable = 1;
					count_enable = 1;
				end
			
			SAMPLING:
				begin
					sampling_enable = 1;
					count_enable = 1;
				end
			
			SHIFT:
				begin
					shift_RX = 1;
					count_enable = 1;
				end
				
			BIT:
				begin
					count_enable = 1;
				end
			
			STOPBIT:
				begin
					SB_enable = 1;
					
				end
				
			READY:
			begin
				ready = 1;
			end
			
			default:
				begin
					sampling_enable = 0;
					count_enable = 0;
					SB_enable = 0;
					shift_RX = 0;
					ready = 0;
				end
		endcase
end





endmodule