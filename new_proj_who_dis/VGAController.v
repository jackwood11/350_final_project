`timescale 1 ns/ 100 ps
module VGAController(     
	input clk, 			// 100 MHz System Clock
	input reset, 		// Reset Signal
	// input[14:0] switch_input, //15bits for switches!
	input digit_1,
	input digit_2, 
	input digit_3, 
	input digit_4, 
	input digit_5, 
	input digit_6, 
	input digit_7, 
	input digit_8, 
	input digit_9, 
	input digit_10,
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
	localparam FILES_PATH = "C:/Users/til3/Desktop/new_proj_who_dis/";

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
	
	wire [14:0] small_address, small_address_1;
	wire in_square, in_square_1, in_square_2, in_square_3;
	localparam
		IMAGE_X_OFFSET = 50,
		IMAGE_Y_OFFSET = 50,
		IMAGE_X_OFFSET1 = 190, 
		IMAGE_Y_OFFSET1 = 50,
		IMAGE_X_OFFSET2 = 328,
		IMAGE_Y_OFFSET2 = 50, 
		IMAGE_X_OFFSET3 = 470, 
		IMAGE_Y_OFFSET3 = 50;
		
    assign in_square = (x >= IMAGE_X_OFFSET && x < IMAGE_X_OFFSET + 138) && (y >= IMAGE_X_OFFSET && y < IMAGE_X_OFFSET + 138); 
    assign in_square_1 = (x >= IMAGE_X_OFFSET1 && x < IMAGE_X_OFFSET1 + 138) && (y >= IMAGE_Y_OFFSET1 && y < IMAGE_Y_OFFSET1 + 138);
    assign in_square_2 = (x >= IMAGE_X_OFFSET2 && x < IMAGE_X_OFFSET2 + 138) && (y >= IMAGE_Y_OFFSET2 && y < IMAGE_Y_OFFSET2 + 138);
     assign in_square_3 = (x >= IMAGE_X_OFFSET3 && x < IMAGE_X_OFFSET3 + 138) && (y >= IMAGE_Y_OFFSET3 && y < IMAGE_Y_OFFSET3 + 138);
    
    assign small_address = (x-IMAGE_X_OFFSET) + (y-IMAGE_Y_OFFSET)*IMAGE_WIDTH;
    //assign small_address_1 = (x-IMAGE_X_OFFSET) + (y-IMAGE_Y_OFFSET)*IMAGE_WIDTH; 
   
    
		
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
	reg second = 0; 
	
	reg [3:0] counter;
	reg [3:0] counter_next = 4'b0; 
	reg [3:0] random_number = 4'd3; 
	
	always @(posedge playerButton) begin
	   counter <= counter_next; 
	   if(digit_1) begin
	       if(4'd1 < random_number) begin
	       
	       end
	       check_up <= 1; 
	       counter_next = counter + 4'b1; 
	   end
	   if(digit_2) begin
	       check_up <= 1;
	       counter_next = counter + 4'b1;          
	   end
	       
	   if(digit_3) begin
	        check_up <= 1;
	        counter_next = counter + 4'b1;  
	   end
	       
	   if(digit_4) begin
	        check_up <= 1;
	        counter_next = counter + 4'b1; 
	   end
	      
	   if(digit_5) begin
	        check_up <= 1;
	        counter_next = counter + 4'b1; 
	   end
	       
	   if(digit_6) begin
	        check_up <= 1;
	        counter_next = counter + 4'b1; 
	   end
	       
	   if(digit_7) begin
	        check_up <= 1;
	        counter_next = counter + 4'b1; 
	   end
	       
	   if(digit_8) begin
	        check_up <= 1;
	        counter_next = counter + 4'b1; 
	   end
	       
	   if(digit_9) begin
	        check_up <= 1;
	        counter_next = counter + 4'b1; 
	   end
	       
	   if(digit_10) begin
	         check_up <= 1;
	         counter_next = counter + 4'b1; 
	   end      
	       
	 end 
	            
	//always @(posedge playerButton) begin
	//pick which square to write to, test position 1 and position 2
	wire s1, s2, s3, s4, s5, s6, s7, s8, s9;

	assign s1 = (counter == 4'd0); 
	assign s2 = (counter == 4'd1); 
	assign s3 = (counter == 4'd2);
	assign s4 = (counter == 4'd3);  
	
	wire correct_square, correct_sq0, correct_sq1, correct_sq2, correct_sq3; 
	
	assign correct_sq0 = s1 ? in_square : in_square_1;
	assign correct_sq1 = s2 ? in_square_1 : correct_sq0; 
	assign correct_sq3 = s3 ? in_square_2 : correct_sq1; 
	assign correct_square = s4 ? in_square_3 : correct_sq3;  
	
	//decide on which image 
	
		
		//read switch input 
		//check against the answer
		//and based on that^ choose select bits accordingly
		//so that we choose the corresponding ram for the right image. 

		//can have a mux beforehand that assigns a single select register


	// wire [3:0] directions;
	// wire in_square;
	// square check_pos(directions, clk, x, y, in_square, screenEnd);
	wire [BITS_PER_COLOR-1: 0] pixelData, tempData0, tempData1, tempData_combine;
	assign tempData0 = (check_up && upDataOut && correct_square) ? 12'h0000ff: 12'd0;
	assign pixelData = (check_up && upDataOut && correct_square) ? 12'h0000ff : tempData0; 
	

	//assign pixelData = check_up ? tempData0 : tempData1; 
	//assign tempData_combine = (second && upDataOut && in_square_1 && check_up && in_square) ? (tempData0 && tempData1) : pixelData; 
	
	// Assign to output color from register if active
	wire[BITS_PER_COLOR-1:0] colorOut; 			  // Output color 
	assign colorOut = active ? pixelData : 12'd0; // When not active, output black

	// Quickly assign the output colors to their channels using concatenation
	assign {VGA_R, VGA_G, VGA_B} = colorOut;





endmodule