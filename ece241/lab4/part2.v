module part2(Clock, Reset_b, Data, Function, ALUout);
	input Clock;
	input Reset_b;
	input [3:0]Data;
	input [1:0]Function;
	output [7:0]ALUout;
	
	

//	assign connectionB = 0;
	wire [7:0]connectionALU_Register;
	
	
	ALU a1(.A(Data), .B(ALUout[3:0]), .Function(Function), .ALUout(connectionALU_Register), .registerValue(ALUout));
	
	eightBitRegister e1(.clk(Clock), .reset_b(Reset_b), .d(connectionALU_Register), .q(ALUout));
	
	
endmodule
	
	


module eightBitRegister(clk,reset_b,d,q);
	input wire clk;
	input wire reset_b;
	input wire [7:0]d;
	output reg [7:0]q;
	
	
	always@ (posedge clk)
		begin
			if (reset_b) q <= 1'b 0 ;
			else q <= d ;
		end
endmodule




module ALU(A, B, Function, ALUout, registerValue);
	input [3:0]B;
	input [3:0]A;
	input [1:0]Function;
	output reg [7:0]ALUout;
	input [7:0]registerValue;
	
	///
//	wire connection;
//	eightBitRegister u0(.clk(0), .q(connection));
	
	///

	always@ (*)
		begin
		case ( Function )
			2'b 00: ALUout = A+B;
			2'b 01: ALUout = {A*B};
			2'b 10: ALUout = B<<A;
			2'b 11:  ALUout = registerValue;
	//		Hold current value in the Register, i.e.,the register value does not change.
			default : ALUout = 8'b0;
		endcase
	end
endmodule
