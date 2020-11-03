module RA_shift_sixteen(f, in);
    input [31:0] in;
    wire msb;
    output [31:0] f;

    assign msb = in[31];
    assign f[31] = msb;
    assign f[30] = msb;
    assign f[29] = msb;
    assign f[28] = msb;
    assign f[27] = msb;
    assign f[26] = msb;
    assign f[25] = msb;
    assign f[24] = msb;
    assign f[23] = msb;
    assign f[22] = msb;
    assign f[21] = msb;
    assign f[20] = msb;
    assign f[19] = msb;
    assign f[18] = msb;
    assign f[17] = msb;
    assign f[16] = msb;
    assign f[15] = in[31];
    assign f[14] = in[30];
    assign f[13] = in[29];
    assign f[12] = in[28];
    assign f[11] = in[27];
    assign f[10] = in[26];
    assign f[9] = in[25];
    assign f[8] = in[24];
    assign f[7] = in[23];
    assign f[6] = in[22];
    assign f[5] = in[21];
    assign f[4] = in[20];
    assign f[3] = in[19];
    assign f[2] = in[18];
    assign f[1] = in[17];
    assign f[0] = in[16];
    
    
    

endmodule