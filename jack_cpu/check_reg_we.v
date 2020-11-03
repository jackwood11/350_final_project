module check_reg_we(allow, ins_opcode);
    input [4:0] ins_opcode;
    output allow;

    wire sw, j, jr, bne, blt, bex;
    decoder get_instructions(
        .opcode(ins_opcode),
        .sw(sw),
        .j(j),
        .jr(jr),
        .bne(bne),
        .blt(blt),
        .bex(bex)
    );

    nor(allow, sw, j, jr, bne, blt, bex); 


endmodule