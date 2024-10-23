//
// This is the template for Part 2 of Lab 7.
//
// Paul Chow
// November 2021
//

module part2(iResetn,iPlotBox,iBlack,iColour,iLoadX,iXY_Coord,iClock,oX,oY,oColour,oPlot,oDone);
   parameter X_SCREEN_PIXELS = 8'd160;
   parameter Y_SCREEN_PIXELS = 7'd120;

   input wire iResetn, iPlotBox, iBlack, iLoadX;
   input wire [2:0] iColour;
   input wire [6:0] iXY_Coord;
   input wire 	    iClock;
   output wire [7:0] oX;         // VGA pixel coordinates
   output wire [6:0] oY;

   output wire [2:0] oColour;     // VGA pixel colour (0-7)
   output wire 	     oPlot;       // Pixel draw enable
   output wire       oDone;       // goes high when finished drawing frame

   //
   // Your code goes here
   //

	
	wire ld_x, ld_y_c, ld_black, Plot;
	wire[7:0]blackX;
	wire[6:0]blackY;
	wire[4:0]area;
	
	
	
	control aa(iClock, iResetn, iPlotBox, iBlack, iLoadX, blackX, blackY, area,
	ld_x, ld_y_c, ld_black, Plot, oDone, oPlot);
	

	
	datapath bb(iClock, iResetn, ld_x, ld_y_c, ld_black, oPlot, iColour, iXY_Coord, 
	oX, blackX, oY, blackY, oColour, area);
	
endmodule 


///Control Module

module control(
	//input X_SCREEN_PIXELS,
	//input Y_SCREEN_PIXELS, 
	input iClock,
	input iResetn,
   input iPlotBox,
   input iBlack,
	input iLoadX,
	input [7:0] blackX,
	input [6:0] blackY,
	input [4:0] area,
	 
   output reg ld_x, ld_y_c, ld_black,
   output reg plot, done, oPlot
   );
	
	parameter X_SCREEN_PIXELS = 8'd160;
   parameter Y_SCREEN_PIXELS = 7'd120;
	 
	reg [2:0] current_state, next_state;
	 
	localparam  S_LOAD_X        = 3'd0,
               S_LOAD_X_WAIT   = 3'd1,
               S_LOAD_Y_C        = 3'd2,
               S_LOAD_Y_C_WAIT   = 3'd3,
					S_DRAW				 = 3'd4,
				   S_BLACK				 = 3'd5,
					S_DONE				 = 3'd6;
					
	always@(posedge iClock)
		begin: state_table
			case (current_state)
				S_LOAD_X: next_state = iLoadX ? S_LOAD_X_WAIT : S_LOAD_X; 
				S_LOAD_X_WAIT: next_state = iLoadX ? S_LOAD_X_WAIT : S_LOAD_Y_C;
				S_LOAD_Y_C: next_state = iPlotBox ? S_LOAD_Y_C_WAIT : S_LOAD_Y_C; 
				S_LOAD_Y_C_WAIT: next_state = iPlotBox ?  S_LOAD_Y_C_WAIT : S_DRAW;
				
				S_DRAW:
					begin
						if (area == 5'd15)
							next_state = S_DONE;
						else 
							next_state = S_DRAW;
					end
					
				S_BLACK: 
					begin
						if (blackX == X_SCREEN_PIXELS-1 && blackY == Y_SCREEN_PIXELS-1)
							next_state = S_DONE;
						else
							next_state = S_BLACK;
					end
				S_DONE: next_state = S_LOAD_X;
				
            default: next_state = S_LOAD_X;
         endcase
		end // state_table
	 
	 
	always@(posedge iClock)
		begin: Loads
			ld_x <= 1'b0;
			ld_y_c <= 1'b0;
			ld_black <= 1'b0;
			
			if ( iBlack == 1 || iLoadX == 1)
				plot <= 1'b0;
				done <= 1'b0;
				oPlot <= 0;
			
			case (current_state)
			
				S_LOAD_X:
				begin
					ld_x <= 1'b1;
					oPlot <= 1'b0;
					plot <= 1'b0;
					
				end
				
				S_LOAD_Y_C:
				begin
					ld_y_c <= 1'b1;
					plot <= 1'b0;
				end
				
				S_DRAW:
				begin
					plot <= 1'b1;
					oPlot <= 1'b1;
				end
				
				S_BLACK:
				begin
					ld_black <= 1'b1;
					oPlot <= 1'b1;
				end
				
				S_DONE:
				begin
					done <= 1'b1;
				end
		
			endcase
		end ///Loads
		

	always@(posedge iClock)
		begin: FinateStateMachine
			if(!iResetn)
				current_state <= S_LOAD_X;
				
			if (iBlack == 1)
				current_state <= S_BLACK;
	
			else 
				current_state <= next_state;
				
		end /// FinateStateMachine
		
endmodule


///Data Path Module

module datapath(
	//input X_SCREEN_PIXELS,
	//input Y_SCREEN_PIXELS,
	input iClock,
	input iResetn,
	input ld_x, ld_y_c, ld_black, oPlot,
	input [2:0] iColor,
	input [6:0] iXY_Coord,
	 
	output reg [7:0] oX, blackX,
	output reg [6:0] oY, blackY,
	output reg [2:0] oColor,
	output reg [4:0] area
	);
	
	parameter X_SCREEN_PIXELS = 8'd160;
   parameter Y_SCREEN_PIXELS = 7'd120;
	
	/// input values
	
	reg [7:0] x;
	reg [6:0] y;
	reg [2:0] Color;
	
	always@(posedge iClock)
		begin
			if (!iResetn) 
				begin
					x <= 8'b0;
					y <= 7'b0;
					Color <= 3'b0;
					area <= 5'b0;
				end
				
			else
				begin
					if (ld_x == 1)
						begin
							x[7] <= 1'b0;
							x[6:0] <= iXY_Coord;
						end
					
					if (ld_y_c == 1)
						begin
							y <= iXY_Coord;
							Color <= iColor;
						end
					
					if (oPlot == 1 )
						begin
							if (area == 5'd16)
								begin
									area <= 5'd0;
								end
								
							else 
								begin
									area <= area + 1;
								end 
								
							oX <= x + area[1:0];
							oY <= y + area[3:2];
							oColor <= Color;
							
						end
					if (ld_black)
						begin
							oX <= blackX;
							oY <= blackY;
							oColor <= 3'b000;
						end
				end
					
		end
		
	always@(posedge iClock)
		begin
			if (!iResetn) 
				begin
					blackX <= 8'b0;
					blackY <= 7'b0;
				end
				
			if ( blackX == X_SCREEN_PIXELS - 1 && blackY == Y_SCREEN_PIXELS - 1 )
				begin
					blackX <= 8'b0;
					blackY <= 7'b0;
				end
			
			else if ( blackX == X_SCREEN_PIXELS - 1)
				begin
					blackX <= 8'b0;
					blackY <= blackY + 1;
				end
				
			if (ld_black)
				begin
					blackX <= blackX + 1;
					
				end
		end



endmodule































