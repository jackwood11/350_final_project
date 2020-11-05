// `timescale 1 ns / 100 ps;
module lfsr_tb();
    
    reg clk = 1'b0;
    wire [7:0] in, value;
    assign in = 8'b0;
    lfsr_A lfsr(.value(value), .enable(1'b1), .data(in), .clk(clk));
    always @(*)
        #20 clk <= ~clk;

    always @(*)
        #10000 $display(value);

    initial begin
        $dumpfile("lfsr_dump.vcd");
        $dumpvars(0, lfsr_tb);
    end

endmodule