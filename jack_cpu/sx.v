module sx(in, out);
    //sign extending 17-bit immediate value to 32 bits
    input [16:0] in;
    output [31:0] out;
    wire msb;
    assign msb = in[16];

    assign out[31] = msb;
    assign out[30] = msb;
    assign out[29] = msb;
    assign out[28] = msb;
    assign out[27] = msb;
    assign out[26] = msb;
    assign out[25] = msb;
    assign out[24] = msb;
    assign out[23] = msb;
    assign out[22] = msb;
    assign out[21] = msb;
    assign out[20] = msb;
    assign out[19] = msb;
    assign out[18] = msb;
    assign out[17] = msb;


    assign out[16:0] = in;


endmodule