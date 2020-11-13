module counter(q, clock, reset);

    input clock, reset;

    output[11:0] q;

    wire w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11;

    tff t0(q[0], 1'b1, clock, reset);
    and w0(w0, 1'b1, q[0]);

    tff t1(q[1], w0, clock, reset);
    and w1(w1, w0, q[1]);

    tff t2(q[2], w1, clock, reset);
    and w2(w2, w1, q[2]);
    
    tff t3(q[3], w2, clock, reset);
    and w3(w3, w2, q[3]);

    tff t4(q[4], w3, clock, reset);
    and w4(w4, w3, q[4]);

    tff t5(q[5], w4, clock, reset);
    and w5(w5, w4, q[5]);

    tff t6(q[6], w5, clock, reset);
    and w6(w6, w5, q[6]);

    tff t7(q[7], w6, clock, reset);
    and w7(w7, w6, q[7]);

    tff t8(q[8], w7, clock, reset);
    and w8(w8, w7, q[8]);

    tff t9(q[9], w8, clock, reset);
    and w9(w9, w8, q[9]);

    tff t10(q[10], w9, clock, reset);
    and w10(w10, w9, q[10]);

    tff t11(q[11], w10, clock, reset);





endmodule