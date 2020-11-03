module or_op(AorB, A, B);
    input [31:0] A, B;
    output [31:0] AorB;

    or zero(AorB[0], A[0], B[0]);
    or one(AorB[1], A[1], B[1]);
    or two(AorB[2], A[2], B[2]);
    or three(AorB[3], A[3], B[3]);
    or four(AorB[4], A[4], B[4]);
    or five(AorB[5], A[5], B[5]);
    or six(AorB[6], A[6], B[6]);
    or seven(AorB[7], A[7], B[7]);
    or eight(AorB[8], A[8], B[8]);
    or nine(AorB[9], A[9], B[9]);
    or ten(AorB[10], A[10], B[10]);
    or eleven(AorB[11], A[11], B[11]);
    or twelve(AorB[12], A[12], B[12]);
    or thirteen(AorB[13], A[13], B[13]);
    or fourteen(AorB[14], A[14], B[14]);
    or fifteen(AorB[15], A[15], B[15]);
    or sixteen(AorB[16], A[16], B[16]);
    or seventeen(AorB[17], A[17], B[17]);
    or eigthteen(AorB[18], A[18], B[18]);
    or nineteen(AorB[19], A[19], B[19]);
    or twenty(AorB[20], A[20], B[20]);
    or twentyOne(AorB[21], A[21], B[21]);
    or twentyTwo(AorB[22], A[22], B[22]);
    or twentyThree(AorB[23], A[23], B[23]);
    or twentyFour(AorB[24], A[24], B[24]);
    or twentyFive(AorB[25], A[25], B[25]);
    or twentySix(AorB[26], A[26], B[26]);
    or twentySeven(AorB[27], A[27], B[27]);
    or twentyEight(AorB[28], A[28], B[28]);
    or twentyNine(AorB[29], A[29], B[29]);
    or thirty(AorB[30], A[30], B[30]);
    or thirtyOne(AorB[31], A[31], B[31]);


endmodule