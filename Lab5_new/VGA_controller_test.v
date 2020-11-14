`timescale 1 ns/ 100 ps
module VGA_controller_test(     
	input clk, 			// 100 MHz System Clock
	input reset, 		// Reset Signal
	output hSync, 		// H Sync Signal
	output vSync, 		// Veritcal Sync Signal
	output[3:0] VGA_R,  // Red Signal Bits
	output[3:0] VGA_G,  // Green Signal Bits
	output[3:0] VGA_B,  // Blue Signal Bits
	inout ps2_clk,
	inout ps2_data);
	
	// Lab Memory Files Location
	//localparam FILES_PATH = "Path/To/File/Directory";

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
		VIDEO_HEIGHT = 480; // Standard VGA Height

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
		PIXEL_COUNT = VIDEO_WIDTH*VIDEO_HEIGHT, 	             // Number of pixels on the screen
		PIXEL_ADDRESS_WIDTH = $clog2(PIXEL_COUNT) + 1,           // Use built in log2 command
		BITS_PER_COLOR = 12, 	  								 // Nexys A7 uses 12 bits/color
		PALETTE_COLOR_COUNT = 256, 								 // Number of Colors available
		PALETTE_ADDRESS_WIDTH = $clog2(PALETTE_COLOR_COUNT) + 1; // Use built in log2 Command

	wire[PIXEL_ADDRESS_WIDTH-1:0] imgAddress;  	 // Image address for the image data
	wire[PALETTE_ADDRESS_WIDTH-1:0] colorAddr; 	 // Color address for the color palette
	assign imgAddress = x + 640*y;				 // Address calculated coordinate

// **************************************************
	//Depth == length
	//Addr_Width == lines log 2
	//Data_width == 8

	//counter to keep track of position.

	RAM #(		
		.DEPTH(256), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(8),      // Set data width according to the color palette
		.ADDRESS_WIDTH(8),     // Set address with according to the pixel count
		.MEMFILE("ascii.mem")) // Memory initialization
	ImageData(
		.clk(clk), 						 // Falling edge of the 100 MHz clk
		.addr(8'd22),					 // Image data address
		.dataOut(ascii_data),				 // Color palette address
		.wEn(1'b0)); 						 // We're always reading




	
    // Color Palette to Map Color Address to 12-Bit Color
	// wire[BITS_PER_COLOR-1:0] colorData; // 12-bit color data at current pixel
	wire inSquare;
    wire [3:0] directions;
    
    square gate(directions, clk, x, y, inSquare, screenEnd);
    

	//POTENTIAL NEXT STEPS:
    wire [11:0] sprite_addr;
	reg [11:0] count;
	wire counter_reset;
	// counter c(count, clk, counter_reset);
	always @(posedge clk) begin
		if (inSquare)
			count <= count + 1;
		if (count >= 2500)
			count = 0;
	end

	wire [11:0] spriteColor;
	assign sprite_addr = (ascii_data - 33) * 2500 + count;

	RAM #(
		.DEPTH(4700), 		       // Set depth to contain every color		
		.DATA_WIDTH(50), 		       // Set data width according to the bits per color
		.ADDRESS_WIDTH(12),     // Set address width according to the color count
		.MEMFILE("sprites.mem"))  // Memory initialization
	ColorPalette(
		.clk(clk), 							   	   // Rising edge of the 100 MHz clk
		.addr(sprite_addr),					       // Address from the ImageData RAM
		.dataOut(spriteColor),				       // Color at current pixel
		.wEn(1'b0)); 						       // We're always reading
	

	

	
	wire [11:0] tempColorOut;
	assign tempColorOut = !inSquare ? 12'h0000ff : 12'hffff00;



	// Quickly assign the output colors to their channels using concatenation
	assign {VGA_R, VGA_G, VGA_B} = tempColorOut;

endmodule