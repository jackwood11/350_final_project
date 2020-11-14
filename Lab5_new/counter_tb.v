`timescale 1 ns / 100 ps
module counter_tb;

    reg clock; 
    reg[11:0] counter;
    wire [11:0] q;
    counter count(q, clock, 1'b0);

    initial begin
        counter = 0;  
    end

    always

        #10 clock = ~clock;
    always
        #20 counter = counter +1;

    always @(clock, counter) begin
    #1;
    $display("Count: %d", q);
    $dumpfile("counter.vcd");
    $dumpvars(0, counter_tb);
    end
endmodule
