`timescale 1 ns/ 100 ps
module VGAController(     
	input clk, 			// 100 MHz System Clock
	input reset,		// Reset Signal
	input playerButton,
	input box1,
	input box2, 
	input box3, 
	input box4, 
	input box5, 
	input box6, 
	input box7, 
	input box8, 
	input box9,

	output hSync, 		// H Sync Signal
	output vSync, 		// Veritcal Sync Signal
	output[3:0] VGA_R,  // Red Signal Bits
	output[3:0] VGA_G,  // Green Signal Bits
	output[3:0] VGA_B,  // Blue Signal Bits
	
	inout ps2_clk,
	inout ps2_data);
	
	// Lab Memory Files Location
	localparam FILES_PATH = "/Users/hannahtaubenfeld/Documents/duke/F20/ECE350/course project/";

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
		VIDEO_HEIGHT = 480, // Standard VGA Height
		VIDEO_WIDTH2 = 206,
		VIDEO_HEIGHT2 = 152,
		col1_start = 0,
		col1_end = 205, 
		col2_start = 217, 
		col2_end = 422, 
		col3_start = 434,
		col3_end = 639,
		row1_start = 0,
		row1_end = 151,
		row2_start = 163,
		row2_end = 314, 
		row3_start = 326,
		row3_end = 477;


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
		PIXEL_COUNT_SMALL = VIDEO_WIDTH2*VIDEO_HEIGHT2,
		PIXEL_ADDRESS_WIDTH = $clog2(PIXEL_COUNT) + 1,           // Use built in log2 command
		PIXEL_ADDRESS_WIDTH_SMALL = $clog2(PIXEL_COUNT_SMALL) + 1,
		BITS_PER_COLOR = 12, 	  								 // Nexys A7 uses 12 bits/color
		PALETTE_COLOR_COUNT = 256, 								 // Number of Colors available
		PALETTE_ADDRESS_WIDTH = $clog2(PALETTE_COLOR_COUNT) + 1; // Use built in log2 Command
		

	wire[PIXEL_ADDRESS_WIDTH-1:0] imgAddress;  	 // Image address for the image data
	wire[PALETTE_ADDRESS_WIDTH-1:0] colorAddr;	 // Color address for the color palette
	wire colorAddr2, colorAddr3, colorAddr4, colorAddr5; 
	wire[PIXEL_ADDRESS_WIDTH_SMALL-1:0] XimgAddress;
	wire[PIXEL_ADDRESS_WIDTH_SMALL-1:0] OimgAddress;
	assign imgAddress = x + 640*y;				 // Address calculated coordinate
	//assign XimgAddress = x+206*y;
	//assign OimgAddress = x+206*y;
	
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
	wire[BITS_PER_COLOR-1:0] colorBack, colorData; // 12-bit color data at current pixel

	RAM #(
		.DEPTH(PALETTE_COLOR_COUNT), 		       // Set depth to contain every color		
		.DATA_WIDTH(BITS_PER_COLOR), 		       // Set data width according to the bits per color
		.ADDRESS_WIDTH(PALETTE_ADDRESS_WIDTH),     // Set address width according to the color count
		.MEMFILE({FILES_PATH, "colors.mem"}))  // Memory initialization
	ColorPalette(
		.clk(clk), 							   	   // Rising edge of the 100 MHz clk
		.addr(colorAddr),					       // Address from the ImageData RAM
		.dataOut(colorBack),				       // Color at current pixel
		.wEn(1'b0)); 						       // We're always reading
	
	wire[PIXEL_ADDRESS_WIDTH_SMALL-1:0] pixel_box;
	reg[PIXEL_ADDRESS_WIDTH_SMALL-1:0] count1 = 1;
	reg[PIXEL_ADDRESS_WIDTH_SMALL-1:0] count2 = 0;
	reg[PIXEL_ADDRESS_WIDTH_SMALL-1:0] count3 = 0;
	reg[PIXEL_ADDRESS_WIDTH_SMALL-1:0] count4 = 0;
	reg[PIXEL_ADDRESS_WIDTH_SMALL-1:0] count5 = 0;
	reg[PIXEL_ADDRESS_WIDTH_SMALL-1:0] count6 = 0;
	reg[PIXEL_ADDRESS_WIDTH_SMALL-1:0] count7 = 0;
	reg[PIXEL_ADDRESS_WIDTH_SMALL-1:0] count8 = 0;
	reg[PIXEL_ADDRESS_WIDTH_SMALL-1:0] count9 = 0;
	reg[3:0] select;
	wire[1:0] isBoxActive;

	always @(posedge clk25) begin
		if (screenEnd)
		begin
			count1 = 1;
			count2 = 0;
			count3 = 0;
			count4 = 0;
			count5 = 0;
			count6 = 0;
			count7 = 0;
			count8 = 0;
			count9 = 0;
		end
		if( x > col1_start && x <= col1_end && y >= row1_start && y <= row1_end)
		begin
			count1 = count1 + 1;
			select = 4'b0000;
		end
		else if (x >= col2_start && x <= col2_end && y >= row1_start && y <= row1_end) begin
			count2 = count2 + 1;
			select = 4'b0001;
		end
		else if (x >= col3_start && x <= col3_end && y >= row1_start && y <= row1_end) begin
			count3 = count3 + 1;
			select = 4'b0010;
		end
		else if (x > col1_start && x <= col1_end && y >= row2_start && y <= row2_end) begin
			count4 = count4 + 1;
			select = 4'b0011;
		end
		else if (x >= col2_start && x <= col2_end && y >= row2_start && y <= row2_end) begin
			count5 = count5 + 1;
			select = 4'b0100;
		end
		else if (x >= col3_start && x <= col3_end && y >= row2_start && y <= row2_end) begin
			count6 = count6 + 1;
			select = 4'b0101;
		end
		else if (x > col1_start && x <= col1_end && y >= row3_start && y <= row3_end) begin
			count7 = count7 + 1;
			select = 4'b0110;
		end
		else if (x >= col2_start && x <= col2_end && y >= row3_start && y <= row3_end) begin
			count8 = count8 + 1;
			select = 4'b0111;
		end
		else if (x >= col3_start && x <= col3_end && y >= row3_start && y <= row3_end) begin
			count9 = count9 + 1;
			select = 4'b1000;
		end
		//else
		//begin 
			//TODO:  need to have an else block for background
		//end
	end

	reg[8:0] playerAssignment;
	reg[1:0] isBox1 = 2'b0;
	reg[1:0] isBox2 = 2'b0;
	reg[1:0] isBox3 = 2'b0;
	reg[1:0] isBox4 = 2'b0;
	reg[1:0] isBox5 = 2'b0;
	reg[1:0] isBox6 = 2'b0;
	reg[1:0] isBox7 = 2'b0;
	reg[1:0] isBox8 = 2'b0;
	reg[1:0] isBox9 = 2'b0;
	reg[2:0] col1 = 3'b0;
	reg[2:0] col2 = 3'b0;
	reg[2:0] col3 = 3'b0;
	reg[2:0] row1 = 3'b0;
	reg[2:0] row2 = 3'b0;
	reg[2:0] row3 = 3'b0;
	reg[2:0] diag1 = 3'b0;
	reg[2:0] diag2 = 3'b0;


	// at beginning, set playerNum = 0
	reg playerNum = 0;
	always @(posedge playerButton) begin
		//if(playerButton)
		//begin
		if(playerNum == 0)
		begin 
		  playerNum = 1;
		 end 
		 else
		 begin 
		 playerNum = 0;
		 end
		//playerNum = ~playerNum;
			if(box1)
			begin
				isBox1[0] = 1;
				isBox1[1] = playerNum;
				if(playerNum ==0)
				begin 
					col1 = col1+1;
					row1 = row1+1;
					diag1 = diag1+1;
				end
				else
				begin
					col1 = col1-1;
					row1 = row1-1;
					diag1 = diag1-1;
				end
			end
			else if(box2)
			begin
				isBox2[0] = 1;
				isBox2[1] = playerNum;
				if(playerNum ==0)
				begin 
					col2 = col2+1;
					row1 = row1+1;
				end
				else
				begin
					col2 = col2-1;
					row1 = row1-1;
				end
			end
			else if(box3)
			begin
				isBox3[0] = 1;
				isBox3[1] = playerNum;
				if(playerNum ==0)
				begin 
					col3 = col3+1;
					row1 = row1+1;
					diag2 = diag2+1;
				end
				else
				begin
					col3 = col3-1;
					row1 = row1-1;
					diag2 = diag2-1;
				end
			end
			else if(box4)
			begin
				isBox4[0] = 1;
				isBox4[1] = playerNum;
				if(playerNum ==0)
				begin 
					col1 = col1+1;
					row2 = row2+1;
				end
				else
				begin
					col1 = col1-1;
					row2 = row2-1;
				end
				
			end
			else if(box5)
			begin
				isBox5[0] = 1;
				isBox5[1] = playerNum;
				if(playerNum ==0)
				begin 
					col2 = col2+1;
					row2 = row2+1;
					diag1 = diag1+1;
					diag2 = diag2+1;
				end
				else
				begin
					col2 = col2-1;
					row2 = row2-1;
					diag1 = diag1-1;
					diag2 = diag2-1;
				end
			end
			else if(box6)
			begin
				isBox6[0] = 1;
				isBox6[1] = playerNum;
				if(playerNum ==0)
				begin 
					col3 = col3+1;
					row2 = row2+1;
				end
				else
				begin
					col3 = col3-1;
					row2 = row2-1;
				end
			end
			else if(box7)
			begin
				isBox7[0] = 1;
				isBox7[1] = playerNum;
				if(playerNum ==0)
				begin 
					col1 = col1+1;
					row3 = row3+1;
					diag2 = diag2+1;
				end
				else
				begin
					col1 = col1-1;
					row3 = row3-1;
					diag2 = diag2-1;
				end
				
			end
			else if(box8)
			begin
				isBox8[0] = 1;
				isBox8[1] = playerNum;
				if(playerNum ==0)
				begin 
					col2 = col2+1;
					row3 = row3+1;
				end
				else
				begin
					col2 = col2-1;
					row3 = row3-1;
				end
			end
			else if(box9)
			begin
				isBox9[0] = 1;
				isBox9[1] = playerNum;
				if(playerNum ==0)
				begin 
					col3 = col3+1;
					row3 = row3+1;
					diag1 = diag1+1;
				end
				else
				begin
					col3 = col3-1;
					row3 = row3-1;
					diag1 = diag1-1;
				end
			end
		
		//end
	end

	wire player1_won, player2_won, aPlayer_won;
	always @(posedge clk25) begin
		if(col1 == 3 || col2 == 3 || col3 == 3 || row1 == 3 || row2 == 3 || row3 == 3 || diag1 ==3 || diag2 ==3) 
		begin 
			player2_won =1;
			aPlayer_won=1;
		end
		else if(col1 == -3 or col2 == -3 or col3 == -3 or row1 == -3 or row2 == -3 or row3 == -3 or diag1 == -3 or diag2 == -3)
		begin
			player1_won =1;
			aPlayer_won=1;
		end
	end

	// update select_count

	/// 0000 count1
	/// 0001 count2
	/// 0010 count3
	/// 0011 count4
	/// 0100 count5
	/// 0101 count6
	/// 0110 count7
	/// 0111 count8
	/// 1000 count9

	//TODO: make sure these muxes is the write number of bits
	mux_16_16bits choose_count(pixel_box, select, count1, count2, count3, count4, count5, count6, count7, count8, count9, 16'b0, 16'b0, 16'b0, 16'b0, 16'b0, 16'b0, 16'b0);
	//mux to see if the box we are in currently is active
	mux_16_2bits choose_box(isBoxActive, select, isBox1, isBox2, isBox3, isBox4, isBox5, isBox6, isBox7, isBox8, isBox9, 2'b0, 2'b0, 2'b0, 2'b0, 2'b0, 2'b0, 2'b0);

	assign XimgAddress = pixel_box;  //(imgAddress%152) + (imgAddress%217)*206;
	assign OimgAddress = pixel_box; //(imgAddress%152) + (imgAddress%217)*206;

	RAM #(
		.DEPTH(PIXEL_COUNT_SMALL),
		.DATA_WIDTH(1'b1), 
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH_SMALL),
		.MEMFILE({FILES_PATH, "x_image.mem"}))
	XData(
		.clk(clk),
		.addr(XimgAddress), /// as function imgAddress
		.dataOut(colorAddr2), // 0 or 1 
		.wEn(1'b0));
		
		// RAM for O

	RAM #(
		.DEPTH(PIXEL_COUNT_SMALL), //For the specific square in the board (will be our arrow)
		.DATA_WIDTH(1'b1), 
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH_SMALL),
		.MEMFILE({FILES_PATH, "o_image.mem"}))
	OData(
		.clk(clk),
		.addr(OimgAddress),
		.dataOut(colorAddr3),
		.wEn(1'b0));

	RAM #(		
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(PALETTE_ADDRESS_WIDTH),      // Set data width according to the color palette
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "player1_image.mem"})) // Memory initialization
	Player1ImageData(
		.clk(clk), 						 // Falling edge of the 100 MHz clk
		.addr(imgAddress),					 // Image data address
		.dataOut(colorAddr4),				 // Color palette address
		.wEn(1'b0)); 						 // We're always reading

	RAM #(		
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(PALETTE_ADDRESS_WIDTH),      // Set data width according to the color palette
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "player2_image.mem"})) // Memory initialization
	Player2ImageData(
		.clk(clk), 						 // Falling edge of the 100 MHz clk
		.addr(imgAddress),					 // Image data address
		.dataOut(colorAddr5),				 // Color palette address
		.wEn(1'b0)); 						 // We're always reading

	
	
	wire[11:0] xColor, oColor, accColor, player1Color, player2_color, playerColor_int, playerColor, playerColor_or_Back;
	
	
	assign xColor = colorAddr2 ? 12'd0 : colorBack;
    assign oColor = colorAddr3 ? 12'd0 : colorBack;


	
	assign player1Color = colorAddr4? 12'd0 : colorBack;
	assign player2Color = colorAddr5? 12'd0 : colorBack;
	// if currPlayer is a 1 we are at Player 2 = O
	assign accColor = isBoxActive[1]? oColor : xColor;
	//for us our select bit will be too high or too small
	//to know if we do down or up arrow

	assign playerColor_int = player1_won? player1Color : colorBack;
	assign playerColor = player2_won? player2Color : playerColor_int;
	assign playerColor_or_Back = aPlayer_won? playerColor : colorBack;

	//if the pixel you're currently in is in a box that is high, write the x or o
    assign colorData = isBoxActive[0] ? accColor : playerColor_or_Back;
    

	//mux(userChose == select, colorAddr2, colorAddr3, xoOutput == outp);
	//mux(xoOutput == select, colorBack, 24'haaaaafa, colorData == outp);


	// Assign to output color from register if active
	wire[BITS_PER_COLOR-1:0] colorOut; 			  // Output color 
	assign colorOut = active ? colorData : 12'd0; // When not active, output black
    
	// Quickly assign the output colors to their channels using concatenation
	assign {VGA_R, VGA_G, VGA_B} = colorOut;
endmodule