module part1 (Clock, Enable, Reset, CounterValue);
	input Clock;
	input Enable;
	input Reset;
	output [7:0] CounterValue;
	
	wire [6:0]huangshengya;
	
	
	TFlipFlop a0(Enable, Clock, Reset, CounterValue[0]);
	assign huangshengya[0] = CounterValue[0] & Enable;
	
	TFlipFlop a1(huangshengya[0], Clock, Reset, CounterValue[1]);
	assign huangshengya[1] = CounterValue[1] & huangshengya[0];
	
	TFlipFlop a2(huangshengya[1], Clock, Reset, CounterValue[2]);
	assign huangshengya[2] = CounterValue[2] & huangshengya[1];
	
	TFlipFlop a3(huangshengya[2], Clock, Reset, CounterValue[3]);
	assign huangshengya[3] = CounterValue[3] & huangshengya[2];
	
	TFlipFlop a4(huangshengya[3], Clock, Reset, CounterValue[4]);
	assign huangshengya[4] = CounterValue[4] & huangshengya[3];
	
	TFlipFlop a5(huangshengya[4], Clock, Reset, CounterValue[5]);
	assign huangshengya[5] = CounterValue[5] & huangshengya[4];
	
	TFlipFlop a6(huangshengya[5], Clock, Reset, CounterValue[6]);
	assign huangshengya[6] = CounterValue[6] & huangshengya[5];
	
	TFlipFlop a7(huangshengya[6], Clock, Reset, CounterValue[7]);
	
endmodule

module TFlipFlop(data_in, clk,reset,Q);
	input clk;
	input reset; 
	input data_in;
	output reg Q;
	
	
	always@ (posedge clk)
		begin
			if (reset) Q <= 1'b 0 ;
			else Q <= Q^ data_in ;
		end
endmodule


//module TFlipFlop(T, clk, reset, Q);
//	input T;
//	input clk;
//	input reset;
//	output Q;
//	
//	DFlipFlop d(clk, reset, T ^ Q, Q);
//	
//endmodule
