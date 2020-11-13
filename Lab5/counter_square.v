module counter_square(count, clk, reset, inside_sq); 

    output [11:0] count; 
    input clk, reset; 

    reg [11:0] cnt;

    always @ (posedge clk)
    begin

        if(!reset)
            cnt <= 2500; 
        
        else if()
        
    end