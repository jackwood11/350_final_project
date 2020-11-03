module and_op(AandB, A, B);
    input [31:0] A, B;
    output [31:0] AandB;

    and zero(AandB[0], A[0], B[0]);
    and one(AandB[1], A[1], B[1]);
    and two(AandB[2], A[2], B[2]);
    and three(AandB[3], A[3], B[3]);
    and four(AandB[4], A[4], B[4]);
    and five(AandB[5], A[5], B[5]);
    and six(AandB[6], A[6], B[6]);
    and seven(AandB[7], A[7], B[7]);
    and eight(AandB[8], A[8], B[8]);
    and nine(AandB[9], A[9], B[9]);
    and ten(AandB[10], A[10], B[10]);
    and eleven(AandB[11], A[11], B[11]);
    and twelve(AandB[12], A[12], B[12]);
    and thirteen(AandB[13], A[13], B[13]);
    and fourteen(AandB[14], A[14], B[14]);
    and fifteen(AandB[15], A[15], B[15]);
    and sixteen(AandB[16], A[16], B[16]);
    and seventeen(AandB[17], A[17], B[17]);
    and eigthteen(AandB[18], A[18], B[18]);
    and nineteen(AandB[19], A[19], B[19]);
    and twenty(AandB[20], A[20], B[20]);
    and twentyOne(AandB[21], A[21], B[21]);
    and twentyTwo(AandB[22], A[22], B[22]);
    and twentyThree(AandB[23], A[23], B[23]);
    and twentyFour(AandB[24], A[24], B[24]);
    and twentyFive(AandB[25], A[25], B[25]);
    and twentySix(AandB[26], A[26], B[26]);
    and twentySeven(AandB[27], A[27], B[27]);
    and twentyEight(AandB[28], A[28], B[28]);
    and twentyNine(AandB[29], A[29], B[29]);
    and thirty(AandB[30], A[30], B[30]);
    and thirtyOne(AandB[31], A[31], B[31]);


endmodule