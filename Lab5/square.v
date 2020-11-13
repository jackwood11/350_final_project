`timescale 1ns / 1ps
module square(directions, clk, xIn, yIn, insideSquare, screenEnd); 
    output reg insideSquare;
    input[9:0] xIn;
    input [9:0] yIn;
    input clk, screenEnd; 
    input[3:0] directions; 

//make a register for the x and y coordinates 
                
    reg[9:0] x, y;
    wire [9:0] top, left, bottom, right;

    initial begin
        x = 320; //start at the center of the monitor 
        y = 240;
    end
    
        //boundaries of the square
    assign top = y - 25;
    assign left = x - 25;
    assign bottom = y + 25;
    assign right = x + 25;

    //define the bounds of the square     
    wire left_bound, right_bound, top_bound, bottom_bound;
    assign left_bound = (x <= 25);
    assign right_bound = (x >= (615)); //640-100
    assign top_bound = (y <= 25);
    assign bottom_bound = (y >= (455)); //480-100
    
    always @(posedge clk) begin
        case (directions[3:2])
            2'b10 : y <=  (!top_bound && screenEnd) ? y-1 : y; //choose the location based on whether we're at the top or bottom bound
            //if above, subtract 1, if below, add 1
            2'b01 : y <=  (!bottom_bound && screenEnd) ? y+1 : y;
            2'b00 : y <=  y;
        endcase
                
        case (directions[1:0])
            2'b10 : x <=  (!left_bound && screenEnd) ? x-1 : x;
            2'b01 : x <=  (!right_bound && screenEnd) ? x+1 : x;
            2'b00 : x <= x;
        endcase
    end
    
    always @(posedge clk) begin
        if((yIn <= bottom) && (yIn >= top) && (xIn <= right) && (xIn >= left)) begin
            insideSquare <= 1'b1;
        end
        else begin
            insideSquare <= 1'b0;
        end
    end
    
endmodule