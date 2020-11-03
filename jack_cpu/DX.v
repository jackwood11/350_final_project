module DX(
    PC_in,
    IR_in,
    ra_data, 
    rb_data,
    j_in,
    linked_PC_in,
    clk,
    clr,
    en,
    mdb,
    PC_out,
    IR_out,
    ra_data_out,
    rb_data_out,
    j_out,
    linked_PC_out,
    immediate,
    shamt 
);

    input [31:0] PC_in, IR_in, linked_PC_in;
    input [31:0] ra_data, rb_data;
    input j_in, clk, clr, en, mdb;
    output [31:0] PC_out, IR_out, ra_data_out, rb_data_out, linked_PC_out;
    output [31:0] immediate;
    output [4:0] shamt;
    output j_out;

    //Registers
    gen_reg PC(PC_out, PC_in, clk, en, clr);
    gen_reg IR(IR_out, IR_in, clk, en, clr);
    gen_reg A(ra_data_out, ra_data, clk, en, clr);
    gen_reg B(rb_data_out, rb_data, clk, en, clr);
    gen_reg linked_PC(linked_PC_out, linked_PC_in, clk, en, clr);
    
    //R-type
    gen_reg_5 shamt_reg(shamt, IR_in[11:7], clk, en, clr);

    //I-type
    wire [31:0] sx_immediate;
    sx sign_extend(.in(IR_in[16:0]), .out(sx_immediate));  
    gen_reg imm(immediate, sx_immediate, clk, en, clr);

    //J-type!
    dffe_ref J(j_out, j_in, clk, en, clr);


endmodule