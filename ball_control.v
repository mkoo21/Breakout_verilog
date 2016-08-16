`timescale 1ns / 1ns // `timescale time_unit/time_precision 

module ball_control(input clk, 
	input reset,
	input [2:0] PADDLE_HIT,
	
	
	output reg [8:0] x,
	output reg [7:0] y,
	output reg BRICK_HIT,
	output reg [8:0] brick_x,
	output reg [7:0] brick_y
	);
	
	//Words > numbers
	localparam LEFT_UP = 3'd0, UP_LEFT = 3'd1, UP_RIGHT = 3'd2, RIGHT_UP = 3'd3, LEFT_DOWN = 3'd4, DOWN_LEFT = 3'd5, DOWN_RIGHT = 3'd6, RIGHT_DOWN = 3'd7,
					LEFT_WALL_X = 9'd12,
					TOP_WALL_Y = 8'd20,
					RIGHT_WALL_X = 9'd320 - 9'd12,
					BRICK_WIDTH = 9'd32, BRICK_HEIGHT = 8'd4,
					BRICK_ONE_X = 9'd100, BRICK_ONE_Y = 8'd60,
					BRICK_TWO_X = 9'd150, BRICK_TWO_Y = 8'd60,
					BRICK_THREE_X = 9'd200, BRICK_THREE_Y = 8'd60;
	
	
	//Local storage
	reg [8:0] d_x;
	reg [7:0] d_y;
	reg [2:0] current_direction;
	reg [1:0] WALL_HIT; 
	reg [2:0] status; //ON or OFF, length = # of bricks
	
	always @(posedge clk) begin
		case(current_direction)
			LEFT_UP: begin
				d_x <= -9'd2;
				d_y <= -8'd1;
			end
			UP_LEFT: begin
				d_x <= -9'd1;
				d_y <= -8'd2;
			end
			UP_RIGHT: begin
				d_x <= 9'd1;
				d_y <= -8'd2;
			end
			RIGHT_UP: begin
				d_x <= 9'd2;
				d_y <= -8'd1;
			end
			LEFT_DOWN: begin
				d_x <= -9'd2;
				d_y <= 8'd1;
			end
			DOWN_LEFT: begin
				d_x <= -9'd1;
				d_y <= 8'd2;
			end
			DOWN_RIGHT: begin
				d_x <= 9'd1;
				d_y <= 8'd2;
			end
			RIGHT_DOWN: begin
				d_x <= 9'd2;
				d_y <= 8'd1;
			end

		endcase
		if(!reset) begin
			x <= 9'd160;
			y <= 8'd218;
			current_direction <= UP_RIGHT; 
			d_x <= 9'd1;
			d_y <= -8'd2;
		end
		
		//change direction on collision
		
		//BRICK COLLISIONS ARE DONE HERE
		
		if(!reset) begin 
			status <= 3'b111;
			BRICK_HIT <= 1'b0;
		end
		BRICK_HIT <= 1'b0;
		//maybe one set of statements per brick (check in parallel)
		//brick 1
		if(y >= BRICK_ONE_Y && y <= (BRICK_ONE_Y + BRICK_HEIGHT) && x >= BRICK_ONE_X && x <= (BRICK_ONE_X + BRICK_WIDTH) && status[0] == 1'b1) begin
			BRICK_HIT <= 1'b1;
			brick_x <= BRICK_ONE_X; brick_y <= BRICK_ONE_Y;
			status[0] <= 1'b0;
			//change direction
			if(current_direction == LEFT_UP || current_direction == UP_LEFT || current_direction == RIGHT_UP || current_direction == UP_RIGHT)
				current_direction <= ((x - BRICK_ONE_X) / 9'd8) + 3'd4;
			else 
				current_direction <= (x - BRICK_ONE_X) / 9'd8;
		end
		//brick 2
		if(y >= BRICK_TWO_Y && y <= (BRICK_TWO_Y + BRICK_HEIGHT) && x >= BRICK_TWO_X && x <= (BRICK_TWO_X + BRICK_WIDTH) && status[1] == 1'b1) begin
			BRICK_HIT <= 1'b1;
			brick_x <= BRICK_TWO_X; brick_y <= BRICK_TWO_Y;
			status[1] <= 1'b0;
			//change direction
			if(current_direction == LEFT_UP || current_direction == UP_LEFT || current_direction == RIGHT_UP || current_direction == UP_RIGHT)
				current_direction <= ((x - BRICK_TWO_X) / 9'd8) + 3'd4;
			else 
				current_direction <= (x - BRICK_TWO_X) / 9'd8;
		end
		//brick 3
		if(y >= BRICK_THREE_Y && y <= (BRICK_THREE_Y + BRICK_HEIGHT) && x >= BRICK_THREE_X && x <= (BRICK_THREE_X + BRICK_WIDTH) && status[2] == 1'b1) begin
			BRICK_HIT <= 1'b1;
			brick_x <= BRICK_THREE_X; brick_y <= BRICK_THREE_Y;
			status[2] <= 1'b0;
			//change direction
			if(current_direction == LEFT_UP || current_direction == UP_LEFT || current_direction == RIGHT_UP || current_direction == UP_RIGHT)
				current_direction <= ((x - BRICK_THREE_X) / 9'd8) + 3'd4;
			else 
				current_direction <= (x - BRICK_THREE_X) / 9'd8;
		end
	
		if(reset && PADDLE_HIT !== 0) current_direction <= PADDLE_HIT - 3'b1;
		if(reset && WALL_HIT !== 0) begin
			case(WALL_HIT)
				2'd1: begin case(current_direction)
							LEFT_UP: begin current_direction <= RIGHT_UP;
											d_x <= 9'd2;
											d_y <= -8'd1;
										end
							UP_LEFT: begin current_direction <= UP_RIGHT;
											d_x <= 9'd1;
											d_y <= -8'd2;
										end
							LEFT_DOWN: begin current_direction <= RIGHT_DOWN;
												d_x <= 9'd2;
												d_y <= 8'd1;
											end
							DOWN_LEFT: begin current_direction <= DOWN_RIGHT;
												d_x <= 9'd1;
												d_y <= 8'd2;
											end
						endcase
					end
				2'd2: begin case(current_direction)
							LEFT_UP: begin current_direction <= LEFT_DOWN;
											d_x <= -9'd2;
											d_y <= 8'd1;
										end
							UP_LEFT: begin current_direction <= DOWN_LEFT;
											d_x <= -9'd1;
											d_y <= 8'd2;
										end
							RIGHT_UP: begin current_direction <= RIGHT_DOWN;
											d_x <= 9'd2;
											d_y <= 8'd1;
										end
							UP_RIGHT: begin current_direction <= DOWN_RIGHT;
												d_x <= 9'd1;
												d_y <= 8'd2;
										end
						endcase
					end
				2'd3: begin case(current_direction)
							RIGHT_UP: begin current_direction <= LEFT_UP;
											d_x <= -9'd2;
											d_y <= -8'd1;
										end
							UP_RIGHT: begin current_direction <= UP_LEFT;
											d_x <= -9'd1;
											d_y <= -8'd2;
										end
							RIGHT_DOWN: begin current_direction <= LEFT_DOWN;
												d_x <= -9'd2;
												d_y <= 8'd1;
										end
							DOWN_RIGHT: begin current_direction <= DOWN_LEFT;
												d_x <= -9'd2;
												d_y <= 8'd1;
										end
						endcase
					end
			
			endcase
		end
		
		if(reset) begin 
			x <= x + d_x;
			y <= y + d_y;
		end
		if(y >= 8'd235 && y <= 8'd240) begin
			//DED
			d_x <= 1'b0;
			d_y <= 1'b0;
		end
	end
	
	//FIGURE OUT WHICH WALL WAS HIT
	
	always @(posedge clk) begin
		if(!reset) WALL_HIT <= 2'b0;
		else begin
			//WALL_HIT == 1 means left wall was hit, WALL_HIT == 2 means top wall was hit, 3 means right wall was hit
			if(x <= LEFT_WALL_X) WALL_HIT <= 2'd1; 
			else begin
				if(y <= TOP_WALL_Y) WALL_HIT <= 2'd2;
				else begin
					if(x >= RIGHT_WALL_X) WALL_HIT <= 2'd3;
					else WALL_HIT <= 2'b0;
				end
			end
		end
	end
	
endmodule