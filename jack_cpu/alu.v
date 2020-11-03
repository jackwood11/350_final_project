module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

    wire [31:0]add_result, sub_result;
    wire [31:0]negB;
    wire [31:0] and_result, or_result;
    wire [31:0] sll_result, sra_result;
    wire add_overflow, sub_overflow;

    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;

    //ADD
    thirty_two_bit_cla add(data_operandA, data_operandB, 1'b0, add_overflow, add_result);
    
    //SUB
    not_op negate(negB, data_operandB);
    thirty_two_bit_cla sub(data_operandA, negB, 1'b1, sub_overflow, sub_result);
    is_zero is_not_equal(isNotEqual, sub_result);
    assign isLessThan = sub_result[31];

    //AND
    and_op bw_and(and_result, data_operandA, data_operandB);

    //OR
    or_op bw_or(or_result, data_operandA, data_operandB);
    
    //SLL
    sll shift_left_logical(sll_result, data_operandA, ctrl_shiftamt);

    //SRA
    sra shift_right_arithmetical(sra_result, data_operandA, ctrl_shiftamt);

    //OPCODE
    mux_8 opcode_mux(data_result, ctrl_ALUopcode[2:0], add_result, sub_result, and_result, or_result, sll_result, sra_result, 32'b0, 32'b0);
    assign overflow = ctrl_ALUopcode[0] ? sub_overflow: add_overflow;

endmodule