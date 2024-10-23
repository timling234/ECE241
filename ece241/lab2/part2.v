//`timescale 1ns / 1ns // `timescale time_unit/time_precision

//SW[2:0] data inputs
//SW[9] select signals

//LEDR[0] output display

//module mux(LEDR, SW);
//    input [9:0] SW;
//    output [9:0] LEDR;
////
//    mux2to1 u0(
//        .x(SW[0]),
//        .y(SW[1]),
//        .s(SW[9]),
//        .m(LEDR[0])
//        );
//
//
//endmodule

module v7404 (pin1, pin3, pin5, pin9, pin11, pin13, pin2, pin4, pin6, pin8, pin10, pin12);

	input pin1;
	input pin3;
	input pin5;
	input pin9;
	input pin11;
	input pin13;

	output pin2;
	output pin4;
	output pin6;
	output pin8;
	output pin10;
	output pin12;
	
	assign pin2 = ~pin1;
	assign pin4 = ~pin3;
	assign pin6 = ~pin5;
	assign pin8 = ~pin9;
	assign pin10 = ~pin11;
	assign pin12 = ~pin13;
	
endmodule

//


module v7408 (pin1, pin3, pin5, pin9, pin11, pin13, pin2, pin4, pin6, pin8, pin10, pin12);

	input pin1;
	input pin2;
	input pin4;
	input pin5;
	input pin12;
	input pin13;
	input pin9;
	input pin10;

	output pin3;
	output pin11;
	output pin6;
	output pin8;
	
	
	assign pin3 = pin1*pin2;
	assign pin6 = pin4*pin5;
	assign pin11 = pin13*pin12;
	assign pin8 = pin9*pin10;


endmodule
//



module v7432 (pin1, pin3, pin5, pin9, pin11, pin13, pin2, pin4, pin6, pin8, pin10, pin12);

	input pin1;
	input pin2;
	input pin4;
	input pin5;
	input pin12;
	input pin13;
	input pin9;
	input pin10;

	output pin3;
	output pin11;
	output pin6;
	output pin8;
	
	
	assign pin3 = pin1+pin2;
	assign pin6 = pin4+pin5;
	assign pin11 = pin13+pin12;
	assign pin8 = pin9+pin10;


endmodule



module mux2to1(x, y, s, m);
    input x; //select 0
    input y; //select 1
    input s; //select signal
    output m; //output
	 
	 wire wire1, wire2, wire3;
	 
	 v7404 chip1(
		.pin1(s),
		
		.pin2(wire1)
	 );
	 
	 v7408 chip2(
		.pin1(wire1),
		.pin2(x),
		.pin4(s),
		.pin5(y),
		
		.pin3(wire2),
		.pin6(wire3)
		
	 );
  
	v7432 chip3(
		.pin1(wire3),
		.pin2(wire2),
		
		.pin3(m)
	);
    //assign m = s & y | ~s & x;
    // OR
//    assign m = s ? y : x;

endmodule



