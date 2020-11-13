module get_answer(q, d);
    //takes 32-bit value and generates a random number 1-10 (4-bits);
    input [31:0] d;
    output [3:0] q;

    wire [2:0] seven;
    wire [1:0] three;

    assign seven = d[4:2];
    assign three = d[10:9];

    integer seven_i, three_i, sum;
    seven_i = seven;
    three_i = three;
    sum = three_i + seven_i;

    initial begin
        if(sum == 0)
            assign q = 4'd1;
        else begin
            case(sum)
              1: assign q[3:0] = 4'd1;
              2: assign q[3:0] = 4'd2;
              3: assign q[3:0] = 4'd3;
              4: assign q[3:0] = 4'd4;
              5: assign q[3:0] = 4'd5;
              6: assign q[3:0] = 4'd6;
              7: assign q[3:0] = 4'd7;
              8: assign q[3:0] = 4'd8;
              9: assign q[3:0] = 4'd9;
              10: assign q[3:0] = 4'd10;  

            endcase
    end

endmodule