// `timescale 1 ns / 100 ps;
module lfsr_32_tb();
    
    reg clk = 1'b0;
    wire [31:0] in, value;
    assign in = 32'b0;
    lfsr_32 lfsr(.value(value), .enable(1'b1), .data(in), .clk(clk));
    always @(*)
        #20 clk <= ~clk;

    always @(*)
        #10000 $display(value);

    initial begin
        $dumpfile("lfsr_32_dump.vcd");
        $dumpvars(0, lfsr_32_tb);
    end

endmodule