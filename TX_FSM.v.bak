/******************************************************************* 
* Name:
*	TX_FSM.v
* Description:
* 	This is a Finite State Machine for TX module of the UART
* Inputs:
*  Transmit: Transmit trigger signal
*	clk: Clock signal 
*  reset: Reset signal
* Outputs:
*  shift: Shift enable input
*  load: load signal
*	transmit_int: Internal transmit signal
* Versión:  
*	1.0
* Author: 
*	José Antonio Rodríguez Castañeda  md193781
* Date :
*	V1.0       25/10/2018
* 
*********************************************************************/

module TX_FSM
#(
	parameter WORD_LENGTH = 8
)

(
	input clk,
	input reset,
	input transmit,
	
	output reg load,
	output reg transmit_int,
	output reg shift_TX

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
FSM_sampling 		   	        //Counter for the FSM bit with 153,846Hz 
(
	.clk(clk),
	.reset(reset),
	.enable(sampling_enable),
	
	.flag(sampling_flag)

);

FlagCounter
#(
	.NBITS(8),
	.VALUE((WORD_LENGTH+1)*16)
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
	.VALUE(14)
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
localparam LOAD = 1;
localparam STARTBIT = 2;
localparam SAMPLING = 3;
localparam SHIFT = 4;
localparam BIT = 5; 
localparam STOPBIT = 6;



reg [4:0]State /*synthesis keep*/ ;

always@(posedge clk or negedge reset) begin
	if (reset==0)
		State <= IDLE;
	else 
		case(State)
			IDLE:
				if(transmit == 1 )
					State <= LOAD;
				else 
					State <= IDLE;
			
			LOAD:
				State <= STARTBIT;
				
			STARTBIT:
				if(SB_flag == 1 )
						State <= SHIFT;
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
					State <= IDLE;
				else
					State <= STOPBIT;
					
			default:
				State <= IDLE;
	endcase
end

always@(State) begin
	sampling_enable = 0;
	count_enable = 0;
	SB_enable = 0;
	load = 0;
	transmit_int = 0;
	shift_TX = 0;
		case(State)
			
			LOAD:
				begin
					load = 1;
				end
			
			STARTBIT:
				begin
					SB_enable = 1;
					transmit_int = 1;
				end
			
			SAMPLING:
				begin
					sampling_enable = 1;
					count_enable = 1;
					transmit_int = 1;
				end
			
			SHIFT:
				begin
					shift_TX = 1;
					count_enable = 1;
					transmit_int = 1;
				end
				
			BIT:
				begin
					count_enable = 1;
					transmit_int = 1;
				end
			
			STOPBIT:
				begin
					SB_enable = 1;
				end
				
			
			default:
				begin
					sampling_enable = 0;
					count_enable = 0;
					SB_enable = 0;
					load = 0;
					transmit_int = 0;
					shift_TX = 0;
				end
		endcase
end





endmodule