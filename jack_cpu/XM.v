module XM(
    IR_in,
    PC_in,
    O_in,
    rd_in,
    r31_in,
    B_in,
    j_in,
    LT_in,
    NE_in,
    ex_in,
    linked_PC_in,
    is_md_in,
    clk,
    en,
    mdb,
    clr,
    IR_out,
    PC_out,
    O_out,
    rd_out,
    r31_out,
    B_out,
    j_out,
    LT_out,
    NE_out,
    ex_out,
    linked_PC_out,
    is_md_out
);

    input [31:0] IR_in, PC_in, O_in, B_in, r31_in, linked_PC_in;
    input [4:0] rd_in;
    input j_in, LT_in, NE_in, clk, en, clr, ex_in, mdb, is_md_in;
    output [31:0] IR_out, PC_out, O_out, B_out, r31_out, linked_PC_out;
    output [4:0] rd_out;
    output j_out, LT_out, NE_out, ex_out, is_md_out;

    //Registers
    gen_reg IR(IR_out, IR_in, clk, en, clr);
    gen_reg PC(PC_out, PC_in, clk, en, clr);
    gen_reg O(O_out, O_in, clk, en, clr);
    gen_reg B(B_out, B_in, clk, en, clr);
    gen_reg regJ(r31_out, r31_in, clk, en, clr);
    gen_reg linked_PC(linked_PC_out, linked_PC_in, clk, en, clr);

    gen_reg_5 rd(rd_out, rd_in, clk, en, clr);

    dffe_ref md(is_md_out, is_md_in, clk, en, clr);


    //ALU output registers
    dffe_ref J(j_out, j_in, clk, en, clr);
    dffe_ref lt(LT_out, LT_in, clk, en, clr);
    dffe_ref ne(NE_out, NE_in, clk, en, clr);
    dffe_ref exception(ex_out, ex_in, clk, en, clr);
    

endmodule