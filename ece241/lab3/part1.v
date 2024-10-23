module part1(a, b, c_in, s, c_out);
	input [7:4] a;
	input [3:0] b;
	input c_in;
	
	output [3:0] s;
	output [9:6] c_out;
	
//	always@(b[0], c_in, ~(a[4]+b[0]))
//	begin
//		if (~(a[4]+b[0]) == 0)
//		      c_out[6]=b[0];
//		else 
//		      c_out[6]=c_in;
//	end

	//FA1
	FA f1(a[4], b[0], c_in, s[0], c_out[6]);
	
	//FA2
	FA f2(a[5], b[1], c_out[6], s[1], c_out[7]);
	
	//FA3
	FA f3(a[6], b[2], c_out[7], s[2], c_out[8]);
	
	//FA4
	FA f4(a[7], b[3], c_out[8], s[3], c_out[9]);
	
endmodule

module FA(a, b, c_in, s, c_out);
	input a;
	input b;
	input c_in;
	
	output s;
	output c_out;
	
	assign s = a ^ b ^ c_in;
	assign c_out = (a & b)|(a & c_in)|(b & c_in);
	
endmodule
	
	
	