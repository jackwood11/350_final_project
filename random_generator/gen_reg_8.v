module gen_reg_8(q, d, clk, en, clr);

    input [7:0] d;
    input clk, en, clr;
    output [7:0] q;

    //instantiate
    dffe_ref d0(q[0], d[0], clk, en, clr);
    dffe_ref d1(q[1], d[1], clk, en, clr);
    dffe_ref d2(q[2], d[2], clk, en, clr);
    dffe_ref d3(q[3], d[3], clk, en, clr);
    dffe_ref d4(q[4], d[4], clk, en, clr);
    dffe_ref d5(q[5], d[5], clk, en, clr);
    dffe_ref d6(q[6], d[6], clk, en, clr);
    dffe_ref d7(q[7], d[7], clk, en, clr);

endmodule