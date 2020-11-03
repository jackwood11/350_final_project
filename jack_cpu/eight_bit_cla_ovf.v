module eight_bit_cla_ovf(A, B, cIn, Gn, Pn, c31, sum);
    input [7:0] A, B;
    input cIn;
    output [7:0] sum;
    output Gn, Pn, c31;
    wire c1, c2, c3, c4, c5, c6, c7;
    wire c1a;
    wire c2a, c2b;
    wire c3a, c3b, c3c;
    wire c4a, c4b, c4c, c4d;
    wire c5a, c5b, c5c, c5d, c5e;
    wire c6a, c6b, c6c, c6d, c6e, c6f;
    wire c7a, c7b, c7c, c7d, c7e, c7f, c7g;
    wire c8a, c8b, c8c, c8d, c8e, c8f, c8g, c8h;

    

    //assign generate & propagate signals
    or pZero(p0, A[0], B[0]);
    or pOne(p1, A[1], B[1]);
    or pTwo(p2, A[2], B[2]);
    or pThree(p3, A[3], B[3]);
    or pFour(p4, A[4], B[4]);
    or pFive(p5, A[5], B[5]);
    or pSix(p6, A[6], B[6]);
    or pSeven(p7, A[7], B[7]);
    
    and gZero(g0, A[0], B[0]);
    and gOne(g1, A[1], B[1]);
    and gTwo(g2, A[2], B[2]);
    and gThree(g3, A[3], B[3]);
    and gFour(g4, A[4], B[4]);
    and gFive(g5, A[5], B[5]);
    and gSix(g6, A[6], B[6]);
    and gSeven(g7, A[7], B[7]);

    //c1
    and cOneA(c1a, p0, cIn);
    or cOne(c1, g0, c1a);

    //c2
    and cTwoA(c2a, p1, p0, cIn);
    and cTwoB(c2b, p1, g0);
    or cTwo(c2, g1, c2a, c2b);

    //c3
    and cThreeA(c3a, p2, p1, p0, cIn);
    and cThreeB(c3b, p2, p1, g0);
    and cThreeC(c3c, p2, g1);
    or cThree(c3, g2, c3a, c3b, c3c);

    //c4
    and cFourA(c4a, p3, p2, p1, p0, cIn);
    and cFourB(c4b, p3, p2, p1, g0);
    and cFourC(c4c, p3, p2, g1);
    and cFourD(c4d, p3, g2);
    or cFour(c4, g3, c4a, c4b, c4c, c4d);

    //c5
    and cFiveA(c5a, p4, p3, p2, p1, p0, cIn);
    and cFiveB(c5b, p4, p3, p2, p1, g0);
    and cFiveC(c5c, p4, p3, p2, g1);
    and cFiveD(c5d, p4, p3, g2);
    and cFiveE(c5e, p4, g3);
    or cFive(c5, g4, c5a, c5b, c5c, c5d, c5e);

    //c6
    and cSixA(c6a, p5, p4, p3, p2, p1, p0, cIn);
    and cSixB(c6b, p5, p4, p3, p2, p1, g0);
    and cSixC(c6c, p5, p4, p3, p2, g1);
    and cSixD(c6d, p5, p4, p3, g2);
    and cSixE(c6e, p5, p4, g3);
    and cSixF(c6f, p5, g4);
    or cSix(c6, g5, c6a, c6b, c6c, c6d, c6e, c6f);

    //c7
    and cSevenA(c7a, p6, p5, p4, p3, p2, p1, p0, cIn);
    and cSevenB(c7b, p6, p5, p4, p3, p2, p1, g0);
    and cSevenC(c7c, p6, p5, p4, p3, p2, g1);
    and cSevenD(c7d, p6, p5, p4, p3, g2);
    and cSevenE(c7e, p6, p5, p4, g3);
    and cSevenF(c7f, p6, p5, g4);
    and cSevenG(c7g, p6, g5);
    or cSeven(c7, g6, c7a, c7b, c7c, c7d, c7e, c7f, c7g);

    // //Block level gen. & prop. functions
    // and cEightA(c8a, p7, p6, p5, p4, p3, p2, p1, p0, cIn);
    // and cEightB(c8b, p7, p6, p5, p4, p3, p2, p1, g0);
    // and cEightC(c8c, p7, p6, p5, p4, p3, p2, g1);
    // and cEightD(c8d, p7, p6, p5, p4, p3, g2);
    // and cEightE(c8e, p7, p6, p5, p4, g3);
    // and cEightF(c8f, p7, p6, p5, g4);
    // and cEightG(c8g, p7, p6, g5);
    // and cEightH(c8h, p7, g6);
    // and P_zero(P0, p7, p6, p5, p4, p3, p2, p1, p0, cIn);
    // or G_zero(G0, g7, c8a, c8b, c8c, c8d, c8e, c8f, c8g, c8h);

     //Block level gen. & prop. functions
    and cEightB(c8b, p7, p6, p5, p4, p3, p2, p1, g0);
    and cEightC(c8c, p7, p6, p5, p4, p3, p2, g1);
    and cEightD(c8d, p7, p6, p5, p4, p3, g2);
    and cEightE(c8e, p7, p6, p5, p4, g3);
    and cEightF(c8f, p7, p6, p5, g4);
    and cEightG(c8g, p7, p6, g5);
    and cEightH(c8h, p7, g6);
    and P_n(Pn, p7, p6, p5, p4, p3, p2, p1, p0);
    or G_n(Gn, g7, c8b, c8c, c8d, c8e, c8f, c8g, c8h);
    
    //sums
    xor s0(sum[0], cIn, A[0], B[0]);
    xor s1(sum[1], c1, A[1], B[1]);
    xor s2(sum[2], c2, A[2], B[2]);
    xor s3(sum[3], c3, A[3], B[3]);
    xor s4(sum[4], c4, A[4], B[4]);
    xor s5(sum[5], c5, A[5], B[5]);
    xor s6(sum[6], c6, A[6], B[6]);
    xor s7(sum[7], c7, A[7], B[7]);

    assign c31 = c7;

endmodule

