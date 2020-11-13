module test_ps2(rx_data, read_data, ps2_clk, ps2_data, clk);
    
    input ps2_clk, ps2_data, clk;
    wire rst;
    assign rst = 1'b0;

    output [7:0] rx_data;
    output read_data;
    wire busy, err;    

    //contraints file contains input values
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