module decoder(
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
    
    input [4:0] opcode;

    output alu, addi, sw, lw, j, bne, jal, jr, blt, bex, setx;
    wire not4, not3, not2, not1, not0;

    //instantiate complemented inputs
    not n4(not4, opcode[4]);
    not n3(not3, opcode[3]);
    not n2(not2, opcode[2]);
    not n1(not1, opcode[1]);
    not n0(not0, opcode[0]);

    //alu
    and alu_check(alu, not4, not3, not2, not1, not0);

    //addi
    and addi_check(addi, not4, not3, opcode[2], not1, opcode[0]);

    //sw
    and sw_check(sw, not4, not3, opcode[2], opcode[1], opcode[0]);

    //lw
    and lw_check(lw, not4, opcode[3], not2, not1, not0);

    //j
    and j_check(j, not4, not3, not2, not1, opcode[0]);

    //bne
    and bne_check(bne, not4, not3, not2, opcode[1], not0);

    //jal
    and jal_check(jal, not4, not3, not2, opcode[1], opcode[0]);

    //jr
    and jr_check(jr, not4, not3, opcode[2], not1, not0);

    //blt
    and blt_check(blt, not4, not3, opcode[2], opcode[1], not0);

    //bex
    and bex_check(bex, opcode[4], not3, opcode[2], opcode[1], not0);

    //setx
    and setx_check(setx, opcode[4], not3, opcode[2], not1, opcode[0]);

endmodule