module part2#(parameter CLOCK_FREQUENCY = 50000000)(ClockIn, Reset, Speed, CounterValue);
	input ClockIn;
	input Reset;
	input [1:0] Speed;
	output [3:0] CounterValue;
	
	wire [3:0]Devider_toDisplay0;
	wire [3:0]Devider_toDisplay1;
	reg [3:0]Final_Devider_toDisplay;
	
	RateDivider0 a2(ClockIn, Reset, Devider_toDisplay0);
	RateDivider1# (.CLOCK_FREQUENCY(CLOCK_FREQUENCY))a3(ClockIn, Reset, Speed, Devider_toDisplay1);
	
	always @(*)
	begin
		if (Speed == 0)
			Final_Devider_toDisplay <= Devider_toDisplay0;
		else 
			Final_Devider_toDisplay <= Devider_toDisplay1;
	end
		
	DisplayCounter b1(ClockIn, Reset, Final_Devider_toDisplay, CounterValue);	
	
endmodule

module RateDivider0(ClockIn, Reset, Enable);
	input ClockIn;
	input Reset;
	output reg Enable;
	reg [26:0] downCount0;
	
	always @(ClockIn)
	begin
		
		if((Reset == 1) || (downCount0 == 0))
			begin
				Enable <= ClockIn; 
			end
		else
			begin
				downCount0 <= downCount0 - 1;
			end
		
	end

endmodule

module RateDivider1#(parameter CLOCK_FREQUENCY = 50000000) (ClockIn, Reset, Speed, Enable);
	input ClockIn;
	input Reset;
	input [1:0] Speed;
	output reg Enable;
	reg [26:0] downCount1;
	
	always @(posedge ClockIn)
	begin
		
		if((Reset == 1) || (downCount1 == 0))
			begin
				if (Speed == 2'b00)
					downCount1 <= 1;
				if (Speed == 2'b01)
					downCount1 <= CLOCK_FREQUENCY;
				if (Speed == 2'b10)
					downCount1 <= (2*CLOCK_FREQUENCY);
				if (Speed == 2'b11)
					downCount1 <= (4*CLOCK_FREQUENCY);
			end
		else
			begin
				downCount1 <= downCount1 - 1;
			end
	end
	
	always @(*)
	begin
		if (downCount1 == 0)
			begin
				Enable <= 1;
			end
		else 
			begin 
				Enable <= 0;
			end
	end
endmodule 

module DisplayCounter(Clock, Reset, EnableDC, CounterValue);
	input Clock;
	input Reset;
	input EnableDC;
	output reg [3:0] CounterValue;
	
	always@ (posedge Clock)		
		begin
			if (Reset) 
				CounterValue  <= 1'b0;
			if (EnableDC==1'b1) 
				CounterValue <= CounterValue+1;
		end
endmodule



	