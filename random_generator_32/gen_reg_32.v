module gen_reg_32(q, d, clk, en, clr);

    input [31:0] d;
    input clk, en, clr;
    output [31:0] q;

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
    dffe_ref d17(q[17], d[17], clk, en, clr);
    dffe_ref d18(q[18], d[18], clk, en, clr);
    dffe_ref d19(q[19], d[19], clk, en, clr);
    dffe_ref d20(q[20], d[20], clk, en, clr);
    dffe_ref d21(q[21], d[21], clk, en, clr);
    dffe_ref d22(q[22], d[22], clk, en, clr);
    dffe_ref d23(q[23], d[23], clk, en, clr);
    dffe_ref d24(q[24], d[24], clk, en, clr);
    dffe_ref d25(q[25], d[25], clk, en, clr);
    dffe_ref d26(q[26], d[26], clk, en, clr);
    dffe_ref d27(q[27], d[27], clk, en, clr);
    dffe_ref d28(q[28], d[28], clk, en, clr);
    dffe_ref d29(q[29], d[29], clk, en, clr);
    dffe_ref d30(q[30], d[30], clk, en, clr);
    dffe_ref d31(q[31], d[31], clk, en, clr);
    

endmodule