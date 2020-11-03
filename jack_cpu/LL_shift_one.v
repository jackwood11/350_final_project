module LL_shift_one(f, in);
    input [31:0] in;
    output [31:0] f;
    assign f[31] = in[30];
    assign f[30] = in[29];
    assign f[29] = in[28];
    assign f[28] = in[27];
    assign f[27] = in[26];
    assign f[26] = in[25];
    assign f[25] = in[24];
    assign f[24] = in[23];
    assign f[23] = in[22];
    assign f[22] = in[21];
    assign f[21] = in[20];
    assign f[20] = in[19];
    assign f[19] = in[18];
    assign f[18] = in[17];
    assign f[17] = in[16];
    assign f[16] = in[15];
    assign f[15] = in[14];
    assign f[14] = in[13];
    assign f[13] = in[12];
    assign f[12] = in[11];
    assign f[11] = in[10];
    assign f[10] = in[9];
    assign f[9] = in[8];
    assign f[8] = in[7];
    assign f[7] = in[6];
    assign f[6] = in[5];
    assign f[5] = in[4];
    assign f[4] = in[3];
    assign f[3] = in[2];
    assign f[2] = in[1];
    assign f[1] = in[0];
    assign f[0] = 1'b0;


endmodule