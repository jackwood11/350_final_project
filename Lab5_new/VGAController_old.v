`timescale 1 ns/ 100 ps
module VGAController_old(     
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
	localparam FILES_PATH = "Path/To/File/Directory";

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

	RAM #(		
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(PALETTE_ADDRESS_WIDTH),      // Set data width according to the color palette
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "image.mem"})) // Memory initialization
	ImageData(
		.clk(clk), 						 // Falling edge of the 100 MHz clk
		.addr(imgAddress),					 // Image data address
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


// **************************************************
	//Depth == length
	//Addr_Width == lines log 2
	//Data_width == 8

	//counter to keep track of position.

	RAM #(		
		.DEPTH(256), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(8),      // Set data width according to the color palette
		.ADDRESS_WIDTH(8),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "ascii.mem"})) // Memory initialization
	ImageData(
		.clk(clk), 						 // Falling edge of the 100 MHz clk
		.addr(7'd22),					 // Image data address
		.dataOut(ascii_data),				 // Color palette address
		.wEn(1'b0)); 						 // We're always reading


	

	// Color Palette to Map Color Address to 12-Bit Color
	// wire[BITS_PER_COLOR-1:0] colorData; // 12-bit color data at current pixel
	wire [11:0] sprite_addr;
	wire [11:0] count;
	wire counter_reset;
	// counter c(count, clk, counter_reset);
	always (@posedge clk25) begin
		if (insquare)
			count <= count + 1;
		if (count >= 2500)
			count = 0;
	end

	wire [11:0] spriteColor;
	assign sprite_addr = (ascii_data - 33) * 2500 + count;
	assign counter_reset = (count >= 2500) ? 1'b1: 1'b0;

	RAM #(
		.DEPTH(23500), 		       // Set depth to contain every color		
		.DATA_WIDTH(50), 		       // Set data width according to the bits per color
		.ADDRESS_WIDTH(12),     // Set address width according to the color count
		.MEMFILE({FILES_PATH, "sprites.mem"}))  // Memory initialization
	ColorPalette(
		.clk(clk), 							   	   // Rising edge of the 100 MHz clk
		.addr(sprite_addr),					       // Address from the ImageData RAM
		.dataOut(spriteColor),				       // Color at current pixel
		.wEn(1'b0)); 						       // We're always reading
	

	// Assign to output color from register if active
	wire[BITS_PER_COLOR-1:0] colorOut; 			  // Output color 

	wire squareOut;
	wire [11:0] tempColorOut;
	square gate(buttons, clk, x, y, squareOut, screenEnd);
	assign tempColorOut = squareOut ? 12'h00f : spriteColor;

	assign colorOut = active ? colorData : 12'd0; // When not active, output black

	// Quickly assign the output colors to their channels using concatenation
	assign {VGA_R, VGA_G, VGA_B} = colorOut;

	//8bit output to test 
	Ps2Interface ps2(
	.ps2_clk(ps2_clk),
	.ps2_data(ps2_data),
	.clk(CLK),
	.rst(rst),
	.tx_data(0),
	.write_data(0),
	.rx_data(rx_data),
	.read_data(read_data),
	.busy(busy),
	.err(err));


endmodule