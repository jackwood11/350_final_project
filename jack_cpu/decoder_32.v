module decoder_32(out, select);
    input[4:0] select;
    output [31:0] out;
   
    wire [4:0] not_bit;

    not not_bit0(not_bit[0], select[0]);
    not not_bit1(not_bit[1], select[1]);
    not not_bit2(not_bit[2], select[2]);
    not not_bit3(not_bit[3], select[3]);
    not not_bit4(not_bit[4], select[4]);

    and bit31(out[31], select[0], select[1], select[2], select[3], select[4]);
    and bit30(out[30], not_bit[0], select[1], select[2], select[3], select[4]);
    and bit29(out[29], select[0], not_bit[1], select[2], select[3], select[4]);
    and bit28(out[28], not_bit[0], not_bit[1], select[2], select[3], select[4]);
    and bit27(out[27], select[0], select[1], not_bit[2], select[3], select[4]);
    and bit26(out[26], not_bit[0], select[1], not_bit[2], select[3], select[4]);
    and bit25(out[25], select[0], not_bit[1], not_bit[2], select[3], select[4]);
    and bit24(out[24], not_bit[0], not_bit[1], not_bit[2], select[3], select[4]);
    and bit23(out[23], select[0], select[1], select[2], not_bit[3], select[4]);
    and bit22(out[22], not_bit[0], select[1], select[2], not_bit[3], select[4]); 
    and bit21(out[21], select[0], not_bit[1], select[2], not_bit[3], select[4]); 
    and bit20(out[20], not_bit[0], not_bit[1], select[2], not_bit[3], select[4]);
    and bit19(out[19], select[0], select[1], not_bit[2], not_bit[3], select[4]);
    and bit18(out[18], not_bit[0], select[1], not_bit[2], not_bit[3], select[4]);
    and bit17(out[17], select[0], not_bit[1], not_bit[2], not_bit[3], select[4]);
    and bit16(out[16], not_bit[0], not_bit[1], not_bit[2], not_bit[3], select[4]);
    and bit15(out[15], select[0], select[1], select[2], select[3], not_bit[4]);
    and bit14(out[14], not_bit[0], select[1], select[2], select[3], not_bit[4]);
    and bit13(out[13], select[0], not_bit[1], select[2], select[3], not_bit[4]);
    and bit12(out[12], not_bit[0], not_bit[1], select[2], select[3], not_bit[4]);
    and bit11(out[11], select[0], select[1], not_bit[2], select[3], not_bit[4]);
    and bit10(out[10], not_bit[0], select[1], not_bit[2], select[3], not_bit[4]);
    and bit9(out[9], select[0], not_bit[1], not_bit[2], select[3], not_bit[4]);
    and bit8(out[8], not_bit[0], not_bit[1], not_bit[2], select[3], not_bit[4]);
    and bit7(out[7], select[0], select[1], select[2], not_bit[3], not_bit[4]);
    and bit6(out[6], not_bit[0], select[1], select[2], not_bit[3], not_bit[4]);
    and bit5(out[5], select[0], not_bit[1], select[2], not_bit[3], not_bit[4]);
    and bit4(out[4], not_bit[0], not_bit[1], select[2], not_bit[3], not_bit[4]);
    and bit3(out[3], select[0], select[1], not_bit[2], not_bit[3], not_bit[4]);
    and bit2(out[2], not_bit[0], select[1], not_bit[2], not_bit[3], not_bit[4]);
    and bit1(out[1], select[0], not_bit[1], not_bit[2], not_bit[3], not_bit[4]);
    and bit0(out[0], not_bit[0], not_bit[1], not_bit[2], not_bit[3], not_bit[4]);


        
        
endmodule