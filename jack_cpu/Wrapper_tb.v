`timescale 1 ns / 100 ps
module Wrapper_tb();
    reg clk, reset;

    /*
    n.b.: 
    to see register value in GTKwave
    must use our regfile module bc
    provided is behaviorial verilog
    */

    //Module to test
    Wrapper processor(clk, reset);

    //Give inputs and runtime
    initial begin
        //Initialize inputs to 0
        clk = 0;
        reset = 0;

        //time delay (ns)
        #16000

        //End testbench
        $finish;
    end

    //Input manipulation
    //Toggle clock every 20ns
    always 
        #20 clk = ~clk;
    
    initial begin
        //output filename
        $dumpfile("wrapper.vcd");
        //module to capture and what level, 0 -> all wires
        $dumpvars(0, Wrapper_tb);
    end

endmodule