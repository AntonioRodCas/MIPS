module RegisterFile 
#(
	parameter WORD_LENGTH = 32,
	parameter N=32
)
(
	input clk,
	input reset,
	input RegWrite,
	input [4:0] WriteRegister,
	input [4:0] ReadRegister1,
	input [4:0] ReadRegister2,
	input [WORD_LENGTH-1:0] WriteData,
	output [WORD_LENGTH-1:0] ReadData1,
	output [WORD_LENGTH-1:0] ReadData2
);

wire [N - 1 : 0] Enable_logic;
wire [(WORD_LENGTH*N) - 1 : 0] Output_logic;

//*****************************************Input MUX instance generation
genvar i;
generate
	for(i=0;i<=N-1; i = i + 1) begin:InputMuxes

		InputMux
		#(
			.WORD_LENGTH(WORD_LENGTH),
			.MUX_ID(i)
		)
		IMUnit
		(
			// Input Ports
			.WriteRegister(WriteRegister),
			.RegWrite(RegWrite),
			
			// Output Ports
			.Enable(Enable_logic[i])

		);
	end
endgenerate

//*****************************************Register instance generation
genvar j;
generate
	for(j=0;j<=N-1; j = j + 1) begin:Registers

		Register
		#(
			.WORD_LENGTH(WORD_LENGTH)
		)
		RegUnit
		(
			// Input Ports
			.clk(clk),
			.reset(reset),
			.enable(Enable_logic[j]),
			.Data_Input(WriteData),
			
			// Output Ports
			.Data_Output(Output_logic[(((j+1)*WORD_LENGTH)-1):(j*WORD_LENGTH)])

		);
	end
endgenerate

//OutputMux 1
OutputMux
#(
	.N(N),
	.WORD_LENGTH(WORD_LENGTH)
)
OutputMux1
(
	// Input Ports
	.Selector(ReadRegister1),
	.DataIN(Output_logic),
			
	// Output Ports
	.Mux_Output(ReadData1)

);

//OutputMux 2
OutputMux
#(
	.N(N),
	.WORD_LENGTH(WORD_LENGTH)
)
OutputMux2
(
	// Input Ports
	.Selector(ReadRegister2),
	.DataIN(Output_logic),
			
	// Output Ports
	.Mux_Output(ReadData2)

);


endmodule