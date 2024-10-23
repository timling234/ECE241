		

module part3(A, B, Function, ALUout);
	parameter N = 4;

	input [N-1:0]B;
	input [N-1:0]A;
	input [1:0]Function;
	
	output reg [N+N-1:0]ALUout;

	wire or_bridge =|{A,B};
	wire and_bridge =&{A,B};


	always@ (*)
	begin
		case ( Function )
			2'b 00:ALUout = {{(N-1){1'b0}},A+B};
			2'b 01:ALUout = {{(N+N-1){1'b0}},or_bridge};
			2'b 10:ALUout = {{(N+N-1){1'b0}},and_bridge};
			2'b 11:ALUout = {A,B};
				
			default: ALUout = {(N+N){1'b0}};
		endcase
	end
	
endmodule


	


	
