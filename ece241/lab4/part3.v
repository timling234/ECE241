module part3(clock, reset, ParallelLoadn, RotateRight, ASRight, Data_IN, Q);
	input clock;
	input reset;
	input ParallelLoadn;
	input RotateRight;
	input ASRight;
	input [3:0]Data_IN;
	output [3:0]Q;
	
	wire [3:0] connectionCalculate_register;
	
	calculate C1(.ParallelLoadn(ParallelLoadn), .RotateRight(RotateRight), .ASRight(ASRight), .Data_IN(Data_IN), .Out(connectionCalculate_register), .result_Register(Q));
		
	eightBitRegister e1(.clk(clock), .reset_b(reset), .d(connectionCalculate_register), .q(Q));
endmodule



module calculate(ParallelLoadn, RotateRight, ASRight, Data_IN, Out, result_Register);
	input ParallelLoadn;
	input RotateRight;
	input ASRight;
	input [3:0] Data_IN;
	output reg [3:0] Out;
	input [3:0] result_Register;
	

	always@(*)
		begin 
			if (ParallelLoadn==1) 
				///case 1
				Out=result_Register;
				
				if (RotateRight==0)
					Out= {result_Register[2:0], result_Register[3]};
					
				
				if (RotateRight==1)
					Out= {result_Register[0], result_Register[3:1]};	
					
					
			
			if (ParallelLoadn==0)
				Out=Data_IN;
				
				
			
//			

//			else if(ParallelLoadn==1 & RotateRight==1 & ASRight==0)
//				///case 2
//				Out = Data_IN >> 1;
//				
//			else if(ParallelLoadn==1 & RotateRight==1 & ASRight==1)
//				///case 3
//				Out <= {Data_IN[7], Data_IN[7:1]};
//			
//			
//			else if(ParallelLoadn==1 & RotateRight==0)
//				///case 4
//				Out= Data_IN << 1;
//			
//			else if(ParallelLoadn==0 & RotateRight==1 & ASRight==0)
//				///case 5
//				Out= Data_IN;
				
		end
endmodule


module eightBitRegister(clk,reset_b,d,q);
	input wire clk;
	input wire reset_b;
	input wire [3:0]d;
	output reg [3:0]q;
	
	
	always@ (posedge clk)
		begin
			if (reset_b) q <= 1'b 0 ;
			else q <= d ;
		end
endmodule

