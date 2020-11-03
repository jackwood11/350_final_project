module alu_decoder(alu_ctrl, instr_in, is_add, is_addi, is_sub, is_mul, is_div);
    input [31:0] instr_in;
    output [4:0] alu_ctrl;
    output is_add, is_addi, is_sub, is_mul, is_div;

    wire alu, addi, sw, lw, j, bne, jal, jr, blt, bex, setx;
    wire [4:0] opcode;
    assign opcode = instr_in[31:27];

    decoder decode(
    alu, 
    addi, 
    sw, 
    lw, 
    j, 
    bne, 
    jal, 
    jr, 
    blt, 
    bex, 
    setx, 
    opcode
    );


    //decode alu opcodes for 00000 instructions
    wire [4:0] alu_op;
    assign alu_op = instr_in[6:2];
    //instantiate complemented inputs for alu_op
    wire not4, not3, not2, not1, not0;
    not n4(not4, alu_op[4]);
    not n3(not3, alu_op[3]);
    not n2(not2, alu_op[2]);
    not n1(not1, alu_op[1]);
    not n0(not0, alu_op[0]);
 
    //DEALING WITH ALU OP CODES 
    wire alu_add, alu_sub, alu_and, alu_or, alu_sll, alu_sra, alu_mul, alu_div;
    and add_op(alu_add, alu, not4, not3, not2, not1, not0);
    and sub_op(alu_sub, alu, not4, not3, not2, not1, alu_op[0]);
    and and_op(alu_and, alu, not4, not3, not2, alu_op[1], not0);
    and or_op(alu_or, alu, not4, not3, not2, alu_op[1], alu_op[0]);
    and sll_op(alu_sll, alu, not4, not3, alu_op[2], not1, not0);
    and sra_op(alu_sra, alu, not4, not3, alu_op[2], not1, alu_op[0]);
    and mul_op(alu_mul, alu, not4, not3, alu_op[2], alu_op[1], not0);
    and div_op(alu_div, alu, not4, not3, alu_op[2], alu_op[1], alu_op[0]);

    //for ADDs to ALU
    wire add_ctrl;
    or check_add(add_ctrl, alu_add, addi, sw, lw);

    //for SUBs to ALU
    wire sub_ctrl;
    or check_sub(sub_ctrl, alu_sub, 1'b0);

    //for ANDs to ALU
    wire and_ctrl;
    or check_and(and_ctrl, alu_and, 1'b0);

    //for ORs to ALU
    wire or_ctrl;
    or check_or(or_ctrl, alu_or, 1'b0);

    //for SLLs to ALU
    wire sll_ctrl;
    or check_sll(sll_ctrl, alu_sll, 1'b0);

    //for SRAs to ALU
    wire sra_ctrl;
    or check_sra(sra_ctrl, alu_sra, 1'b0);
    

    //Now, need encoder to create 5-bit alu_ctrl output
    //as of now, only have 6 controls so only need 3 bits
    //lets pad the upper ones
    assign alu_ctrl[4] = 1'b0;
    assign alu_ctrl[3] = 1'b0;
    or c2(alu_ctrl[2], sll_ctrl, sra_ctrl, alu_mul, alu_div);
    or c1(alu_ctrl[1], and_ctrl, or_ctrl, alu_mul, alu_div);
    or c0(alu_ctrl[0], sub_ctrl, or_ctrl, sra_ctrl, alu_div);


    //get these instructions for checking instructions
    // output is_add, is_addi, is_sub, is_mul, is_div;
    assign is_add = alu_add;
    assign is_addi = addi;
    assign is_sub = alu_sub;
    assign is_mul = alu_mul;
    assign is_div = alu_div;

endmodule