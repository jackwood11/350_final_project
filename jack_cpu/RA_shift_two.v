module RA_shift_two(f, in);
    input [31:0] in;
    wire msb;
    output [31:0] f;

    assign msb = in[31];
    assign f[31] = msb;
    assign f[30] = msb;
    assign f[29] = in[31];
    assign f[28] = in[30];
    assign f[27] = in[29];
    assign f[26] = in[28];
    assign f[25] = in[27];
    assign f[24] = in[26];
    assign f[23] = in[25];
    assign f[22] = in[24];
    assign f[21] = in[23];
    assign f[20] = in[22];
    assign f[19] = in[21];
    assign f[18] = in[20];
    assign f[17] = in[19];
    assign f[16] = in[18];
    assign f[15] = in[17];
    assign f[14] = in[16];
    assign f[13] = in[15];
    assign f[12] = in[14];
    assign f[11] = in[13];
    assign f[10] = in[12];
    assign f[9] = in[11];
    assign f[8] = in[10];
    assign f[7] = in[9];
    assign f[6] = in[8];
    assign f[5] = in[7];
    assign f[4] = in[6];
    assign f[3] = in[5];
    assign f[2] = in[4];
    assign f[1] = in[3];
    assign f[0] = in[2];
    
    
    

endmodule