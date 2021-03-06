// DRAW A 4x4 SQUARE IN COLOR
// Datapath inputs X, Y, color to VGA
// FSM inputs Plot (wren)

`timescale 1ns / 1ns // `timescale time_unit/time_precision
	 
module breakout
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
		  LEDR,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW; //9-7 are color, 6:0 are (x,y) (7-bit numbers from 0-127)
	input   [3:0]   KEY; //KEY0 is asynch reset, KEY3 should load an x or y
	output [9:0] LEDR;

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire resetn;
	assign resetn = SW[9];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [8:0] x;
	wire [7:0] y;
	wire writeEn;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "320x240";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.
    
	 //wires
	 
	 wire draw_paddle;
	 wire[8:0] paddle_pos;
	 wire fps_clock;
	 wire[8:0] ball_x; wire [7:0] ball_y; //not yet driven
	 wire[2:0] BALL_HIT;
	 wire [1:0] WALL_HIT;
	 wire thirty_clock;
	 wire BRICK_HIT;
	 wire [8:0] brick_x;
	 wire [7:0] brick_y;
	 
	//Rate dividers
	fps_divider FD(.clock(CLOCK_50), .resetn(resetn), .q(fps_clock));
	thirty_fps TF(.clock(CLOCK_50), .resetn(resetn), .q(thirty_clock));
   
	//FSM controls
	paddle_control PC(.clk(fps_clock), .resetn(resetn), .go({1'b1 - KEY[1], 1'b1 - KEY[0]}), .ball_x(ball_x), .ball_y(ball_y), .draw(draw_paddle), .current_state(paddle_pos), .PADDLE_HIT(BALL_HIT)); 
	ball_control BC(.clk(thirty_clock), .reset(resetn), .x(ball_x), .y(ball_y), .PADDLE_HIT(BALL_HIT), .BRICK_HIT(BRICK_HIT), .brick_x(brick_x), .brick_y(brick_y));
	new_draw ND(.clk(CLOCK_50), .reset(resetn), .paddle_pos(paddle_pos), .p_draw(draw_paddle), .ball_x(ball_x), .ball_y(ball_y), .x(x), .y(y), .color(colour), .wren(writeEn), .fps(thirty_clock), .BRICK_HIT(BRICK_HIT), .brick_x(brick_x), .brick_y(brick_y));
	
    
endmodule

module fps_divider(input clock, input resetn, output reg q); //60 fps
	reg [25:0] fifty_mil;
	always @(posedge clock)
	begin
		if(resetn == 1'b0 || fifty_mil >= 26'd833333) begin//50M divided by 60
			fifty_mil <= 0;
			q <= 1;
		end
		else begin
			fifty_mil <= fifty_mil + 1'b1;
			q <= 0;
		end
	end
	
endmodule

module thirty_fps(input clock, input resetn, output reg q); //30 fps
	reg [25:0] fifty_mil;
	always @(posedge clock)
	begin
		if(resetn == 1'b0 || fifty_mil >= 26'd1250000) begin //50M divided by 30 (not really)
			fifty_mil <= 0;
			q <= 1;
		end
		else begin
			fifty_mil <= fifty_mil + 1'b1;
			q <= 0;
		end
	end
endmodule
