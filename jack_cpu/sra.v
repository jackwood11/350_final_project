module sra(sra_result, A, shft_amount);
    input [31:0] A;
    input [4:0] shft_amount;
    output [31:0] sra_result;

    wire [31:0] sixteenShift, eightShift, fourShift, twoShift, oneShift;
    wire [31:0] mux_16, mux_8, mux_4, mux_2, mux_1;
    
    RA_shift_sixteen sixteen(sixteenShift, A);
    mux_2 mux4(mux_16, shft_amount[4], A, sixteenShift);

    RA_shift_eight eight(eightShift, mux_16);
    mux_2 mux3(mux_8, shft_amount[3], mux_16, eightShift);

    RA_shift_four four(fourShift, mux_8);
    mux_2 mux2(mux_4, shft_amount[2], mux_8, fourShift);

    RA_shift_two two(twoShift, mux_4);
    mux_2 mux1(mux_2, shft_amount[1], mux_4, twoShift);

    RA_shift_one one(oneShift, mux_2);
    mux_2 mux0(mux_1, shft_amount[0], mux_2, oneShift);
    assign sra_result = mux_1;
endmodule