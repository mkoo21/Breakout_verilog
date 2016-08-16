`timescale 1ns / 1ns // `timescale time_unit/time_precision 

module paddle_control(
    input clk,
    input resetn,
    input [1:0] go, //[1,0] is left, [0,1] is right, [0,0] is stay
	 input [8:0] ball_x,
	 input [7:0] ball_y,
	 output reg LEDR, //debug
	 output reg [2:0] PADDLE_HIT,
    output reg draw,
	 output reg [8:0] current_state
    );
	 // clocked @ 60 fps
	
    reg [8:0] next_state; 
    
    localparam  BRICK_WIDTH = 8'd16,
					 BRICK_HEIGHT = 8'd8,
					 PADDLE_WIDTH= 8'd32, //this is actually wall width
					 PADDLE_HEIGHT = 8'd2,
					 PADDLE_SIZE = 8'd32,
					 PADDLE_Y_POS = 9'd220;    
					 
    // State transitions
    always @(posedge clk)
    begin
		if(resetn) begin
         case (current_state)
					9'd8: current_state <= 2'd2 * go[0] + current_state; //Paddle is on far left side
					9'd280: current_state <= current_state - (2'd2 * go[1]); //Paddle is on far right side
            default: current_state <= (2'd2 * go[0]) - (2'd2 * go[1]) + current_state; //Paddle can go either direction depending on input
         endcase

			if (go[0] || go[1]) draw <= 1'b1;
			else draw <= 1'b0;
		end
		if(resetn == 1'b0) begin
			draw <= 1'b1;
			current_state <= 9'd152;
		end
    end // state_table
	 
	
	 //Check for a ball-paddle collision
	 always@(posedge clk) begin
		PADDLE_HIT <= 0;
		if(ball_y >= PADDLE_Y_POS && ball_y <= PADDLE_Y_POS + 9'd3 && ball_x >= current_state && ball_x <= current_state + PADDLE_WIDTH) //collision
			PADDLE_HIT <= ((ball_x - current_state) / 9'd8) + 1'b1;
	 end

endmodule
