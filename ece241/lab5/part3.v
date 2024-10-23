module part3#(parameter CLOCK_FREQUENCY=2)(ClockIn, Reset, Start, Letter, DotDashOut, NewBitOut);
	input wire ClockIn;
	input wire Reset;
	input wire Start;
	input wire [2:0] Letter;
	output wire DotDashOut;
	output wire NewBitOut;
	
	wire [11:0] MorseCode;

	wire enable;
	wire hsy;

	
	letterDecoder a(Letter, MorseCode);
	RateDivider#(.CLOCK_FREQUENCY(CLOCK_FREQUENCY)) b (ClockIn, Reset, Start, enable);
	shiftRegister c(ClockIn, enable, Reset, Start, MorseCode, hsy);
	
	assign NewBitOut = (enable == 1)?1:0;
	assign DotDashOut = hsy;

endmodule


///Letter Decoder
module letterDecoder(Letter, MorseCode);
	input[2:0] Letter;
	output reg [11:0]MorseCode;
	
	always@(*)
		begin
			case(Letter)
			3'b 000: MorseCode = 12'b 101110000000;
			3'b 001: MorseCode = 12'b 111010101000;
			3'b 010: MorseCode = 12'b 111010111010;
			3'b 011: MorseCode = 12'b 111010100000;
			3'b 100: MorseCode = 12'b 100000000000;
			3'b 101: MorseCode = 12'b 101011101000;
			3'b 110: MorseCode = 12'b 111011101000;
			3'b 111: MorseCode = 12'b 101010100000;
			endcase
		end
endmodule



///Rate Divider
module RateDivider#(parameter CLOCK_FREQUENCY = 2) (ClockIn, Reset, Start, ClockOut);
	input ClockIn;
	input Start;
	input Reset;
	output ClockOut;
	reg [26:0] downCount;

	
	always @(posedge ClockIn)
	begin
		if (Reset)
			downCount <= 0;		
		if((Start == 1) || (downCount == 0))
			begin
					downCount <= (0.5*CLOCK_FREQUENCY);
			end
		else
			begin
				downCount <= downCount - 1;
			end
	end
	assign ClockOut = (downCount == 0) ? 1:0;
	
endmodule 



///Shift Register
module shiftRegister(ClockIn, NewBitIn, Reset, Start, data_in, out);
	input ClockIn;
	input Reset;
	input NewBitIn;
	input Start;
	input [11:0]data_in;
	output out;
	
	reg [11:0]temp;
	
	
	always@ (posedge ClockIn)		
		begin
			if (Reset == 1) 
				temp <= 12'b0;
				
			else if (Start == 1)
				temp <= data_in;
				
			else if (NewBitIn == 1) 
				
					///start shifting
				temp <= {temp[10:0], 1'b0};
					
		end
	assign out = temp[11];
endmodule