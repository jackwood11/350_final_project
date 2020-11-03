module thirty_two_bit_cla(A, B, cIn, cOut, sum);
    input [31:0] A, B;
    input cIn;
    output [31:0] sum;
    output cOut;
    wire G0, P0, G1, P1, G2, P2, G3, P3;
    wire c8, c16, c24, c32; 
    wire c8RHS;
    wire c16RHSa, c16RHSb;
    wire c24RHSa, c24RHSb, c24RHSc;
    wire c32RHSa, c32RHSb, c32RHSc, c32RHSd;

    //block zero
    eight_bit_cla block_zero(A[7:0], B[7:0], cIn, G0, P0, sum[7:0]);
    //c8
    and c_eight_RHS(c8RHS, P0, cIn); // P0*c0
    or c_eight(c8, G0, c8RHS); // c8 = G0 + P0*c0

    //block one
    eight_bit_cla block_one(A[15:8], B[15:8], c8, G1, P1, sum[15:8]);
    //c16
    and c_sixteen_RHSa(c16RHSa, P1, G0); // P1*G0
    and c_sixteen_RHSb(c16RHSb, P1, P0, cIn); // P1*P0*c0
    or c_sixteen(c16, G1, c16RHSa, c16RHSb); // c16 = G1 + P1*G0 + P1*P0*c0

    //block two
    eight_bit_cla block_two(A[23:16], B[23:16], c16, G2, P2, sum[23:16]);
    //c24
    and c_twentyfour_RHSa(c24RHSa, P2, G1); // P2*G1
    and c_twentyfour_RHSb(c24RHSb, P2, P1, G0); // P2*P1*G0
    and c_twentyfour_RHSc(c24RHSc, P2, P1, P0, cIn); // P2*P1*P0*c0
    or c_twentyfour(c24, G2, c24RHSa, c24RHSb, c24RHSc); 
    //^ c24 = G2 + P2*G1 + P2*P1*G0 + P2*P1*P0*c0

    //block three
    eight_bit_cla_ovf block_three(A[31:24], B[31:24], c24, G3, P3, c31, sum[31:24]);
    //c32
    and c_thirtytwo_RHSa(c32RHSa, P3, G2); // P3*G2
    and c_thirtytwo_RHSb(c32RHSb, P3, P2, G1); // P3*P2*G1
    and c_thirtytwo_RHSc(c32RHSc, P3, P2, P1, G0); // P3*P2*P1*G0
    and c_thirtytwo_RHSd(c32RHSd, P3, P2, P1, P0, cIn); // P3*P2*P1*P0*c0
    or c_thirtytwo(c32, G3, c32RHSa, c32RHSb, c32RHSc, c32RHSd); 
    //^ c32 = G3 + P3*G2 + P3*P2*G1 + P3*P2*P1*G0 + P3*P2*P1*P0*c0
    
    // overflow
    xor overflow(cOut, c32, c31);

endmodule



