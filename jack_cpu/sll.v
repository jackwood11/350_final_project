module sll(sll_result, A, shft_amount);
    input [31:0] A;
    input [4:0] shft_amount;
    output[31:0] sll_result;

    wire [31:0] sixteenShift, eightShift, fourShift, twoShift, oneShift;
    wire [31:0] mux_16, mux_8, mux_4, mux_2, mux_1;
    
    LL_shift_sixteen sixteen(sixteenShift, A);
    mux_2 mux4(mux_16, shft_amount[4], A, sixteenShift);

    LL_shift_eight eight(eightShift, mux_16);
    mux_2 mux3(mux_8, shft_amount[3], mux_16, eightShift);

    LL_shift_four four(fourShift, mux_8);
    mux_2 mux2(mux_4, shft_amount[2], mux_8, fourShift);

    LL_shift_two two(twoShift, mux_4);
    mux_2 mux1(mux_2, shft_amount[1], mux_4, twoShift);

    LL_shift_one one(oneShift, mux_2);
    mux_2 mux0(mux_1, shft_amount[0], mux_2, oneShift);
    assign sll_result = mux_1;

endmodule