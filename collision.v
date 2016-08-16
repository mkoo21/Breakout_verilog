`timescale 1ns / 1ns // `timescale time_unit/time_precision 

module collision(input clk, input reset, input [8:0] ball_x, input [7:0] ball_y, output reg [1:0] WALL_HIT);
	//clock @ 60 fps
	//checks for wall collisions 
	
	//obsolete...
	
	localparam WALL_WIDTH = 9'd8,
					LEFT_WALL_X = 9'd8,
					TOP_WALL_Y = 8'd8,
					RIGHT_WALL_X = 9'd320 - 9'd8;
					
					always @(posedge clk) begin
						if(!reset) WALL_HIT <= 2'b0;
						else begin
					//WALL_HIT == 1 means left wall was hit, WALL_HIT == 2 means top wall was hit, 3 means right wall was hit
							if(ball_x <= LEFT_WALL_X) WALL_HIT <= 2'd1; 
							else begin
								if(ball_y <= TOP_WALL_Y) WALL_HIT <= 2'd2;
								else begin
									if(ball_x >= RIGHT_WALL_X) WALL_HIT <= 2'd3;
									else WALL_HIT <= 2'b0;
								end
							end
						end
					end
endmodule