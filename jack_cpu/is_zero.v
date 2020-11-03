module is_zero(isZero, value);
    input [31:0] value;
    output isZero;

    or or_gate(isZero, value[31], value[30], value[29], value[28], value[27], value[26], value[25], value[24], value[23]
                , value[22], value[21], value[20], value[19], value[18], value[17], value[16], value[15], value[14]
                , value[13], value[12], value[11], value[10], value[9], value[8], value[7], value[6], value[5], value[4]
                , value[3], value[2], value[1], value[0]);

endmodule
