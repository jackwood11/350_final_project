`timescale 1 ns/ 100 ps
module VGAController(     
	input clk, 			// 100 MHz System Clock
	input reset, 		// Reset Signal
	// input[14:0] switch_input, //15bits for switches!
	input digit_1,
	input playerButton,
	output hSync, 		// H Sync Signal
	output vSync, 		// Veritcal Sync Signal
	output[3:0] VGA_R,  // Red Signal Bits
	output[3:0] VGA_G,  // Green Signal Bits
	output[3:0] VGA_B,  // Blue Signal Bits
	inout ps2_clk,
	inout ps2_data);
	
	//need inputs for all switches + button (1biteach)

	// Lab Memory Files Location
	localparam FILES_PATH = "C:/Users/jw543/Desktop/new_proj_who_dis/";

	// Clock divider 100 MHz -> 25 MHz
	wire clk25; // 25MHz clock

	reg[1:0] pixCounter = 0;      // Pixel counter to divide the clock
    assign clk25 = pixCounter[1]; // Set the clock high whenever the second bit (2) is high
	always @(posedge clk) begin
		pixCounter <= pixCounter + 1; // Since the reg is only 3 bits, it will reset every 8 cycles
	end

	// VGA Timing Generation for a Standard VGA Screen
	localparam 
		VIDEO_WIDTH = 640,  // Standard VGA Width
		VIDEO_HEIGHT = 480,
		IMAGE_WIDTH = 138,
		IMAGE_HEIGHT = 138; // Standard VGA Height

	wire active, screenEnd;
	wire[9:0] x;
	wire[8:0] y;
	
	VGATimingGenerator #(
		.HEIGHT(VIDEO_HEIGHT), // Use the standard VGA Values
		.WIDTH(VIDEO_WIDTH))
	Display( 
		.clk25(clk25),  	   // 25MHz Pixel Clock
		.reset(reset),		   // Reset Signal
		.screenEnd(screenEnd), // High for one cycle when between two frames
		.active(active),	   // High when drawing pixels
		.hSync(hSync),  	   // Set Generated H Signal
		.vSync(vSync),		   // Set Generated V Signal
		.x(x), 				   // X Coordinate (from left)
		.y(y)); 			   // Y Coordinate (from top)	   

	// Image Data to Map Pixel Location to Color Address
	localparam 
		PIXEL_COUNT = VIDEO_WIDTH*VIDEO_HEIGHT,  // Number of pixels on the screen
		PIXEL_COUNT_SMALL =  IMAGE_HEIGHT * IMAGE_WIDTH,
		PIXEL_ADDRESS_WIDTH_SMALL = $clog2(PIXEL_COUNT_SMALL) + 1,       
		PIXEL_ADDRESS_WIDTH = $clog2(PIXEL_COUNT) + 1,           // Use built in log2 command
		BITS_PER_COLOR = 12, 	  								 // Nexys A7 uses 12 bits/color
		PALETTE_COLOR_COUNT = 256, 								 // Number of Colors available
		PALETTE_ADDRESS_WIDTH = $clog2(PALETTE_COLOR_COUNT) + 1; // Use built in log2 Command

	wire[PIXEL_ADDRESS_WIDTH-1:0] backgroundAddress;  	 // Image address for the image data
	wire[PALETTE_ADDRESS_WIDTH-1:0] colorAddr; 	 // Color address for the color palette
	assign backgroundAddress = x + 640*y;				 // Address calculated coordinate

	wire [PIXEL_ADDRESS_WIDTH_SMALL-1: 0] imgAddress;
	assign imgAddress = x + 138*y;

	RAM #(		
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(PALETTE_ADDRESS_WIDTH),      // Set data width according to the color palette
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "image.mem"})) // Memory initialization
	ImageData(
		.clk(clk), 						 // Falling edge of the 100 MHz clk
		.addr(backgroundAddress),					 // Image data address
		.dataOut(colorAddr),				 // Color palette address
		.wEn(1'b0)); 						 // We're always reading

	// Color Palette to Map Color Address to 12-Bit Color
	wire[BITS_PER_COLOR-1:0] colorData; // 12-bit color data at current pixel

	RAM #(
		.DEPTH(PALETTE_COLOR_COUNT), 		       // Set depth to contain every color		
		.DATA_WIDTH(BITS_PER_COLOR), 		       // Set data width according to the bits per color
		.ADDRESS_WIDTH(PALETTE_ADDRESS_WIDTH),     // Set address width according to the color count
		.MEMFILE({FILES_PATH, "colors.mem"}))  // Memory initialization
	ColorPalette(
		.clk(clk), 							   	   // Rising edge of the 100 MHz clk
		.addr(colorAddr),					       // Address from the ImageData RAM
		.dataOut(colorData),				       // Color at current pixel
		.wEn(1'b0)); 						       // We're always reading
	
	wire [14:0] small_address;
	wire in_square;
	localparam
		IMAGE_X_OFFSET = 50,
		IMAGE_Y_OFFSET = 50;
		
    assign in_square = (x >= IMAGE_X_OFFSET && x < IMAGE_X_OFFSET + 138) && (y >= IMAGE_X_OFFSET && y < IMAGE_X_OFFSET + 138); 
    assign small_address = (x-IMAGE_X_OFFSET) + (y-IMAGE_Y_OFFSET)*IMAGE_WIDTH; 
		
	//always @(x,y) begin
	   //if((x >= IMAGE_X_OFFSET && x < IMAGE_X_OFFSET + 138) && (y >= IMAGE_X_OFFSET && y < IMAGE_X_OFFSET + 138)) begin
		   //small_address <= (x-IMAGE_X_OFFSET) + (y-IMAGE_Y_OFFSET)*IMAGE_WIDTH;
		   //in_square <= 1;
	   //end
	       
		 

	RAM #(
		.DEPTH(PIXEL_COUNT_SMALL), //For the specific square in the board (will be our arrow)
		.DATA_WIDTH(1'b1), 
		.ADDRESS_WIDTH(15),
		.MEMFILE({FILES_PATH, "up_image.mem"}))
	UpData(
		.clk(clk),
		.addr(small_address),
		.dataOut(upDataOut),
		.wEn(1'b0));

	RAM #(
		.DEPTH(PIXEL_COUNT_SMALL), //For the specific square in the board (will be our arrow)
		.DATA_WIDTH(1'b1), 
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH_SMALL),
		.MEMFILE({FILES_PATH, "down_image.mem"}))
	DownData(
		.clk(clk),
		.addr(imgAddress),
		.dataOut(downDataOut),
		.wEn(1'b0));

	RAM #(
		.DEPTH(PIXEL_COUNT_SMALL), //For the specific square in the board (will be our arrow)
		.DATA_WIDTH(1'b1), 
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH_SMALL),
		.MEMFILE({FILES_PATH, "correct_image.mem"}))
	CorrectData(
		.clk(clk),
		.addr(imgAddress),
		.dataOut(correctDataOut),
		.wEn(1'b0));
	
	reg check_up = 0;
	
	always @(posedge clk25) begin
	   if (playerButton) begin
	       if(digit_1) begin
	           check_up <= 1; 
	       end
	   end
	       
	 end 
	            
	//always @(posedge playerButton) begin

	
		
		//read switch input 
		//check against the answer
		//and based on that^ choose select bits accordingly
		//so that we choose the corresponding ram for the right image. 

		//can have a mux beforehand that assigns a single select register


	// wire [3:0] directions;
	// wire in_square;
	// square check_pos(directions, clk, x, y, in_square, screenEnd);
	wire [BITS_PER_COLOR-1: 0] pixelData;
	assign pixelData = (check_up && upDataOut && in_square) ? 12'h0000ff: 12'd0;
	
	
	
	// Assign to output color from register if active
	wire[BITS_PER_COLOR-1:0] colorOut; 			  // Output color 
	assign colorOut = active ? pixelData : 12'd0; // When not active, output black

	// Quickly assign the output colors to their channels using concatenation
	assign {VGA_R, VGA_G, VGA_B} = colorOut;





endmodule