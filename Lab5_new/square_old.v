`timescale 1ns / 1ps
module square #(parameter H_SIZE=100, 
                Y_START=240, X_START=320, 
                D_HEIGHT=480, D_WIDTH=640)
               (output[11:0] topB, 
                output[11:0] bottB, 
                output[11:0] leftB, 
                output[11:0] rightB,
                input clk, 
                input ani_clk, 
                input animate, 
                input reset,
                input[3:0] butts);
                
    reg[11:0] x, y;
    initial begin
        x = X_START;
        y = Y_START;
    end

    assign topB = y - H_SIZE;
    assign bottB = y + H_SIZE;
    assign leftB = x - H_SIZE;
    assign rightB = x + H_SIZE;
    
    wire atLeftBound, atRightBound, atTopBound, atBottBound, doX, doY;
    wire[31:0] nextX, nextY;
    assign atLeftBound = (x <= H_SIZE);
    assign atRightBound = (x >= (D_WIDTH - H_SIZE));
    assign atTopBound = (y <= H_SIZE);
    assign atBottBound = (y >= (D_HEIGHT - H_SIZE));
    
    always @(posedge clk) begin
        if(reset) begin
            x <= X_START;
            y <= Y_START; 
        end else begin 
            if(ani_clk & animate) begin
                case (butts[3:2])
                    2'b10 : y <=  atTopBound ? y : y-1;
                    2'b01 : y <=  atBottBound ? y : y+1;
                endcase
                
                case (butts[1:0])
                    2'b10 : x <=  atLeftBound ? x : x-1;
                    2'b01 : x <=  atRightBound ? x : x+1;
                endcase
            end
        end
    end
endmodule
