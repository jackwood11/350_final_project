module FD(
    PC_in,
    IR_in,
    clk,
    clr,
    en, 
    mdb,
    PC_out,
    IR_out,
    rs,
    rt,
    rd
);

    input [31:0] PC_in, IR_in;
    input clk, clr, en, mdb;
    output [31:0] PC_out, IR_out;
    output [4:0] rs, rt, rd;

    //Registers
    gen_reg PC(PC_out, PC_in, clk, en, clr);
    gen_reg IR(IR_out, IR_in, clk, en, clr);

    //Decode 
    wire [4:0] opcode;
    wire R, I, JI, JII, J;
    gen_reg_5 op(opcode, IR_in[31:27], clk, en, clr);
    get_ins_type RIJ(opcode, R, I, JI, JII, J);

    //Get output registers
    gen_reg_5 rd_reg(rd, IR_in[26:22], clk, en, clr);
    gen_reg_5 rs_reg(rs, IR_in[21:17], clk, en, clr);
    gen_reg_5 rt_reg(rt, IR_in[16:12], clk, en, clr);
    
    




endmodule