module gen_reg_17(q, d, clk, en, clr);

    input [16:0] d;
    input clk, en, clr;
    output [16:0] q;

    //instantiate
    dffe_ref d0(q[0], d[0], clk, en, clr);
    dffe_ref d1(q[1], d[1], clk, en, clr);
    dffe_ref d2(q[2], d[2], clk, en, clr);
    dffe_ref d3(q[3], d[3], clk, en, clr);
    dffe_ref d4(q[4], d[4], clk, en, clr);
    dffe_ref d5(q[5], d[5], clk, en, clr);
    dffe_ref d6(q[6], d[6], clk, en, clr);
    dffe_ref d7(q[7], d[7], clk, en, clr);
    dffe_ref d8(q[8], d[8], clk, en, clr);
    dffe_ref d9(q[9], d[9], clk, en, clr);
    dffe_ref d10(q[10], d[10], clk, en, clr);
    dffe_ref d11(q[11], d[11], clk, en, clr);
    dffe_ref d12(q[12], d[12], clk, en, clr);
    dffe_ref d13(q[13], d[13], clk, en, clr);
    dffe_ref d14(q[14], d[14], clk, en, clr);
    dffe_ref d15(q[15], d[15], clk, en, clr);
    dffe_ref d16(q[16], d[16], clk, en, clr);

endmodule