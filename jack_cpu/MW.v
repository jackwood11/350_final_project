module MW(
    IR_in,
    O_in,
    rd_in,
    is_md_in,
    Dmem_in,
    ex_in,
    linked_PC_in,
    clk,
    en,
    clr,
    IR_out,
    O_out,
    rd_out,
    is_md_out,
    D_out,
    ex_out,
    linked_PC_out
);

    input [31:0] IR_in, O_in, Dmem_in, linked_PC_in;
    input [4:0] rd_in;
    input clk, en, clr, ex_in, is_md_in;
    output [31:0] IR_out, O_out, D_out, linked_PC_out;
    output [4:0] rd_out;
    output ex_out, is_md_out;

    //Registers
    gen_reg IR(IR_out, IR_in, clk, en, clr);
    gen_reg O(O_out, O_in, clk, en, clr);
    gen_reg D(D_out, Dmem_in, clk, en, clr);
    gen_reg linked_PC(linked_PC_out, linked_PC_in, clk, en, clr);

    gen_reg_5 rd(rd_out, rd_in, clk, en, clr);

    dffe_ref exception(ex_out, ex_in, clk, en, clr);
    dffe_ref md(is_md_out, is_md_in, clk, en, clr);
    

endmodule