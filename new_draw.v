`timescale 1ns / 1ns // `timescale time_unit/time_precision 

module new_draw(input clk,
	input reset,
	input [8:0] paddle_pos,
	input p_draw,
	input [8:0] ball_x,
	input [7:0] ball_y,
	input fps,
	input BRICK_HIT,
	input [8:0] brick_x,
	input [7:0] brick_y,
	
	output reg [8:0] x,
	output reg [7:0] y,
	output reg [2:0] color,
	output reg wren);

	//temporary storage
	reg [30:0] current_state, next_state;	
	reg [8:0] current_paddle;
	reg [8:0] current_ball_x;
	reg [7:0] current_ball_y;
	reg [3:0] current_brick;
	
	//Buffers (for different clock speeds)
	reg paddle_draw;
	reg ball_draw;
	reg brick_hit;
	
	//draw counters
	reg [15:0] wall_draw_progress;
	reg [6:0] paddle_draw_progress;
	reg [31:0] reset_progress;
	reg [8:0] brick_draw_progress;
	
	localparam  PADDLE_SIZE = 8'd64,
					INIT = 32'd0,
					LEFT_WALL_FINISHED = INIT + 32'd1920,
					TOP_WALL_FINISHED = LEFT_WALL_FINISHED + 32'd2560,
					RIGHT_WALL_FINISHED = TOP_WALL_FINISHED + 32'd1920,
					DRAW_BRICKS = RIGHT_WALL_FINISHED + 1,
					BRICKS_FINISHED = DRAW_BRICKS + 32'd128,
					WAIT = BRICKS_FINISHED + 1'd1,
					PADDLE_ERASE_START = WAIT + 1'd1,
					PADDLE_DRAW_START = PADDLE_ERASE_START + PADDLE_SIZE + 1'd1,
					PADDLE_CYCLE_END = PADDLE_DRAW_START + PADDLE_SIZE + 1'd1,
					BALL_ERASE = PADDLE_CYCLE_END + 1,
					BALL_DRAW = BALL_ERASE + 2'd2,
					BALL_CYCLE_END = BALL_DRAW + 2'd2,
					RESET_START = BRICK_ERASE_END + 1'b1,
					RESET_END = RESET_START + 32'd76800,
					//Reset and erase brick cycle have been swapped
					BRICK_ERASE_START = BALL_CYCLE_END + 1'b1,
					BRICK_ERASE_END = BRICK_ERASE_START + 8'd128;
				
	//state transitions (change current, next state here
	always @(posedge clk) begin
		case (current_state)
		
		//TRANSITIONS
			WAIT: next_state <= ball_draw ? BALL_ERASE : (paddle_draw ? PADDLE_ERASE_START: WAIT); //Loop if not time to draw paddle or ball
			PADDLE_CYCLE_END: next_state <= (ball_draw ? BALL_ERASE : WAIT);
			BALL_CYCLE_END: next_state <= (brick_hit ? BRICK_ERASE_START : WAIT);
			BRICKS_FINISHED: begin
				if(current_brick < 3'd3) next_state <= DRAW_BRICKS;
				else next_state <= WAIT;
			end
			BRICK_ERASE_END: next_state <= (paddle_draw ? PADDLE_ERASE_START : WAIT);
			RESET_END: next_state <= INIT;
			default: next_state <= current_state + 1'd1;
		endcase			
		if(!reset) begin
			current_state <= INIT;
		end
		else current_state <= next_state;
	end
	
	//drawing
	always @(posedge clk) begin
	
		//first thing buffer draw signals from other clock domains
		if(fps) ball_draw <= 1'b1;
		if(BRICK_HIT) brick_hit <= 1'b1;
		
		//bricks only i guess?
		if(!reset) begin 
			brick_hit <= 1'b0;
			current_brick <= 3'b0;
		end
		
		//set/reset state-specific params 
		case (current_state)
			INIT: begin 
				wall_draw_progress <= 16'd0;
				wren <= 1'b1;
			end	
			LEFT_WALL_FINISHED: begin
				wall_draw_progress <= 16'd0;
			end
			TOP_WALL_FINISHED: begin
				wall_draw_progress <= 16'd0;
			end
			WAIT: begin
				paddle_draw <= p_draw;
				wren <= 1'b0;
			end
			PADDLE_ERASE_START: begin 
				wren <= 1'b1;
				paddle_draw_progress <= 6'd0;
			end
			PADDLE_DRAW_START: begin
				paddle_draw_progress <= 6'd0;
				current_paddle <= paddle_pos;
			end
			PADDLE_CYCLE_END: paddle_draw <= 1'b0;
			BALL_ERASE: wren <= 1'b1;
			BALL_DRAW: begin
				current_ball_x <= ball_x;
				current_ball_y <= ball_y;
			end
			BALL_CYCLE_END: ball_draw <= 1'b0;
			RESET_START: begin 
				wren <= 1'b1;
				reset_progress <= 32'd0;
				y <= 8'd8;
			end
			DRAW_BRICKS: begin 
				wren <= 1'b1;
				brick_draw_progress <= 9'd0;
				current_brick <= current_brick + 1'b1;
			end
			BRICKS_FINISHED: wren <= 1'b0;
			BRICK_ERASE_START: brick_draw_progress <= 9'd0;
			BRICK_ERASE_END: brick_hit <= 1'b0;
			default: begin
				//DRAW IN DEFAULT STATE
				if(INIT < current_state && current_state < LEFT_WALL_FINISHED) begin
					color <= 3'b100;
					x <= wall_draw_progress % 4'd8;
					y <= wall_draw_progress / 4'd8;
				end
				if(LEFT_WALL_FINISHED < current_state && current_state < TOP_WALL_FINISHED) begin
					color <= 3'b100;
					x <= wall_draw_progress % 9'd320;
					y <= wall_draw_progress / 9'd320;
				end
				if(TOP_WALL_FINISHED < current_state && current_state < RIGHT_WALL_FINISHED) begin
					color <= 3'b100;
					x <= 9'd320 - (wall_draw_progress % 4'd8);
					y <= wall_draw_progress / 4'd8;
				end
				if(PADDLE_ERASE_START < current_state && current_state < PADDLE_DRAW_START) begin
					color <= 3'b000;
					x <= current_paddle + (paddle_draw_progress % 6'd32);
					y <= 9'd220 + (paddle_draw_progress / 6'd32);
				end
				if(PADDLE_DRAW_START < current_state && current_state < PADDLE_CYCLE_END) begin
					color <= 3'b001;
					x <= current_paddle + (paddle_draw_progress % 6'd32);
					y <= 9'd220 + (paddle_draw_progress / 6'd32);
				end
				if(BALL_ERASE < current_state && current_state < BALL_DRAW) begin
					color <= 3'b000;
					x <= current_ball_x;
					y <= current_ball_y;
				end
				if(BALL_DRAW < current_state && current_state < BALL_CYCLE_END) begin
					color <= 3'b010;
					x <= current_ball_x;
					y <= current_ball_y;
				end
				if(RESET_START < current_state && current_state < RESET_END) begin
					color<= 3'b000;
					x <= reset_progress % 9'd320;
					y <= reset_progress / 9'd320;
				end
				if(DRAW_BRICKS < current_state && current_state < BRICKS_FINISHED && current_brick == 4'd1) begin
					color <= 3'b110;
					x <= 9'd100 + (brick_draw_progress % 9'd32);
					y <= 8'd60 + (brick_draw_progress / 8'd32);
				end
				if(DRAW_BRICKS < current_state && current_state < BRICKS_FINISHED && current_brick == 4'd2) begin
					color <= 3'b110;
					x <= 9'd150 + (brick_draw_progress % 9'd32);
					y <= 8'd60 + (brick_draw_progress / 8'd32);
				end
				if(DRAW_BRICKS < current_state && current_state < BRICKS_FINISHED && current_brick == 4'd3) begin
					color <= 3'b110;
					x <= 9'd200 + (brick_draw_progress % 9'd32);
					y <= 8'd60 + (brick_draw_progress / 8'd32);
				end
				if(BRICK_ERASE_START < current_state && current_state < BRICK_ERASE_END) begin
					wren <= 1'b1;
					color <= 3'b000;
					x <= brick_x + (brick_draw_progress % 9'd32);
					y <= brick_y + (brick_draw_progress / 8'd32);
				end
					
				//increment draw progress counters (they are reset at the beginning of the relevant draw state)
				wall_draw_progress <= wall_draw_progress + 1'b1;
				paddle_draw_progress <= paddle_draw_progress + 1'b1;
				reset_progress <= reset_progress + 1'b1;
				brick_draw_progress <= brick_draw_progress + 1'b1;
			end
		endcase

	end

endmodule