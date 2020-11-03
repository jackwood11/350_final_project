module get_ins_type(opcode, R, I, JI, JII, any_J);
    input [4:0] opcode;
    output R, I, JI, JII, any_J;

    wire alu, addi, sw, lw, j, bne, jal, jr, blt, bex, setx;

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

    assign R = alu;
    or I_type(I, addi, sw, lw, bne, blt);
    or JI_type(JI, j, jal);
    assign JII = jr;
    or all_j(any_J, JI, JII);


endmodule