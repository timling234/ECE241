//SW[0] reset when 0
//SW[1] input signal

//KEY[0] Clock signal

//LEDR[3:0] displays current state
//LEDR[9] displays output

module part1(Clock, Reset, w, z, CurState);
    input Clock;
    input Reset;
    input w;
    output z;
    output [3:0] CurState;

    reg [3:0] y_Q, Y_D; // y_Q represents current state, Y_D represents next state

    localparam A = 4'b0000, B = 4'b0001, C = 4'b0010, D = 4'b0011, E = 4'b0100, F = 4'b0101, G = 4'b0110;


    //State table
    //The state table should only contain the logic for state transitions
    //Do not mix in any output logic. The output logic should be handled separately.
    //This will make it easier to read, modify and debug the code.
    always@(*)
    begin: state_table
        case (y_Q)
            A: begin
                   if (!w) Y_D = A;
                   else Y_D = B;
               end
					
            B: begin
                   if (!w) Y_D = A;
                   else Y_D = C;
               end
					
            C: begin
						 if (!w) Y_D = E;
						 else Y_D = D;
					end
				
				
            D: begin
						 if (!w) Y_D = E;
						 else Y_D = F;
					end
			
            E: begin
						 if (!w) Y_D = A;
						 else Y_D = G;
					end
				
            F: begin
						 if (!w) Y_D = E;
						 else Y_D = F;
					end
				
            G: begin
						 if (!w) Y_D = A;
						 else Y_D = C;
					end
				
            default: Y_D = A;
        endcase
    end // state_table

    // State Registers
    always @(posedge Clock)
    begin: state_FFs
        if(Reset == 1'b1)
            y_Q <=  A; // Should set reset state to state A
        else
            y_Q <= Y_D;
    end // state_FFS

    // Output logic
    // Set z to 1 to turn on LED when in relevant states
    assign z = ((y_Q == F ) | (y_Q == G));

    assign CurState = y_Q;
endmodule
