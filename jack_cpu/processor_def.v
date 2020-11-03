/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile
	 
	);


	// Control signals
	input clock, reset;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

    //STALLS!
    wire PC_master_stall, FD_master_stall, DX_master_stall, XM_master_stall, MW_master_stall;

    //Program Counter 
    wire [31:0] PC_out, PC_in;
    wire clock_rise, clock_fall;
    assign clock_rise = clock;
    gen_reg PC(PC_out, PC_in, clock_rise, ~PC_master_stall, reset);
    assign address_imem = PC_out;

    wire [31:0] PC_plus_one;
    assign PC_plus_one = PC_out + 32'd1;

    
    
    //
    //  F/D
    //
    wire [31:0] FD_PC, FD_IR, new_instruction;
    wire [4:0] FD_rs, FD_rt, FD_rd;
    assign new_instruction = (FD_is_jumping | is_branch) ? 32'd0 : q_imem;
    FD fd(
        .PC_in(PC_out), 
        .IR_in(new_instruction), 
        .clk(clock), 
        .clr(reset), 
        .en(~FD_master_stall),
        .PC_out(FD_PC), 
        .IR_out(FD_IR), 
        .rs(FD_rs), 
        .rt(FD_rt),
        .rd(FD_rd)
        );

   
    //
    //  JUMPS
    //
    wire FD_is_jumping, fd_j_or_jal, fd_j, fd_jal;
    get_ins_type jump_check(.any_J(FD_is_jumping), .opcode(FD_IR[31:27]));
    decoder check_jI(.j(fd_j), .jal(fd_jal), .opcode(FD_IR[31:27]));
    assign fd_j_or_jal = fd_j | fd_jal;

    //bit extend target
    wire [31:0] t_extended;
    assign t_extended[31:27] = 5'b0;
    assign t_extended[26:0] = FD_IR[26:0];

    //jump register
    wire FD_is_jr, FD_is_bex;
    decoder check_jII(.jr(FD_is_jr), .bex(FD_is_bex), .opcode(FD_IR[31:27]));

    //Register inputs
    wire [4:0] pre_readA;
    assign pre_readA = FD_is_jr ? 5'd31: FD_rs;
    assign ctrl_readRegA = FD_is_bex ? 5'd30 : pre_readA; 
    assign ctrl_readRegB = (is_sw_read | FD_is_jr) ? FD_rd: FD_rt;

    //PC reassignment 
    wire [31:0] PC_temp, PC_linked, PC_jump;
    assign PC_temp = fd_j_or_jal ? t_extended: PC_plus_one;
    assign PC_jump = FD_is_jr ? data_readRegB : PC_temp;
    assign PC_linked = PC_plus_one;

    //FLUSH if branching or jumping
    wire [31:0] FD_IR_temp;
    get_ins_type J_FD(.opcode(FD_IR[31:27]), .any_J(FD_is_jumping));
    assign FD_IR_temp = (is_branch | LA_stall) ? 32'b0: FD_IR;

    //reg file inputs & outputs
    //only on sw's do we need to change our inputs
    wire [31:0] DX_A, DX_B;
    wire is_sw_read;
    decoder check_sw_read(.sw(is_sw_read), .opcode(FD_IR[31:27]));

    
    
    //
    //  D/X
    //
    wire [31:0] DX_PC, DX_IR, DX_linked_PC;
    wire [31:0] immediate;
    wire [4:0] shamt;
    wire DX_is_jumping;
    DX dx(
        .PC_in(FD_PC), 
        .IR_in(FD_IR_temp), 
        .ra_data(data_readRegA), 
        .rb_data(data_readRegB),
        .j_in(FD_is_jumping),
        .linked_PC_in(PC_linked),
        .clk(clock), 
        .clr(reset), 
        .en(~DX_master_stall),
        .PC_out(DX_PC), 
        .IR_out(DX_IR), 
        .ra_data_out(DX_A), 
        .rb_data_out(DX_B), 
        .j_out(DX_is_jumping),
        .linked_PC_out(DX_linked_PC),
        .immediate(immediate),
        .shamt(shamt)
        );


    //ALU preprocessing
    wire DX_R, DX_I, DX_JI, DX_JII;
    get_ins_type ALU_preprocess(.opcode(DX_IR[31:27]), .R(DX_R), .I(DX_I), 
                                .JI(DX_JI), .JII(DX_JII));


    //HAZARD DETECTOR
    wire [4:0] H_XM_rd, H_DX_rs, H_DX_rt, H_MW_rd;
    assign H_DX_rs = DX_IR[21:17];
    assign H_DX_rt = DX_IR[16:12];
    assign H_MW_rd = MW_IR[26:22];
    assign H_XM_rd = XM_IR[26:22];
    wire hazard, HMX_A, HMX_B, HWX_A, HWX_B, HWM, LA_stall;
    hazard_detect haz_control(
        .fd_rs(FD_rs),
        .fd_rt(FD_rt),
        .fd_op(FD_IR[31:27]),
        .dx_rd(DX_IR[26:22]),
        .dx_rs(H_DX_rs), 
        .dx_rt(H_DX_rt),
        .dx_op(DX_IR[31:27]), 
        .xm_rd(H_XM_rd), 
        .mw_rd(H_MW_rd), 
        .hazard(hazard),
        .MX_A(HMX_A),
        .MX_B(HMX_B),
        .WX_A(HWX_A),
        .WX_B(HWX_B),
        .WM(HWM),
        .LA_stall(LA_stall)
        );               
    
    //BYPASSING
    wire [31:0] ALU_in_A, ALU_in_B, pre_ALU_B, XM_O, reg_file_wr_d;
    wire [1:0] by_A_s, by_B_s;
    
    // bypass A
    assign by_A_s[0] = ~HMX_A & HWX_A; //select == 0 for MX_A and select == 1 for WX_A
    assign by_A_s[1] = ~HMX_A & ~HWX_A; //select == 2 for else
    mux_4 Byp_ALU_A(.out(ALU_in_A), .select(by_A_s), .in0(XM_O), .in1(reg_file_wr_d), .in2(DX_A));

    // bypass B
    assign by_B_s[0] = ~HMX_B & HWX_B; //select == 0 for MX_B and select == 1 for WX_B
    assign by_B_s[1] = ~HMX_B & ~HWX_B; //select == 2 for else
    mux_4 Byp_ALU_B(.out(pre_ALU_B), .select(by_B_s), .in0(XM_O), .in1(reg_file_wr_d), .in2(DX_B));

    assign ALU_in_B = DX_I ? immediate: pre_ALU_B;
    wire [4:0] ALU_op;
    alu_decoder alu_ctrl(.alu_ctrl(ALU_op), .instr_in(DX_IR));
    
    //Bex: check rstatus value.
    wire X_is_bex, check_bex;
    decoder xbx(.bex(check_bex), .opcode(DX_IR[31:27]));
    assign X_is_bex = (DX_A != 32'b0) & check_bex;


    
    //ALU
    wire [31:0] ALU_out;
    wire ALU_is_LT, ALU_ovf, ALU_is_NE;
    alu main_alu(
        .data_operandA(ALU_in_A), 
        .data_operandB(ALU_in_B), 
        .ctrl_ALUopcode(ALU_op), 
        .ctrl_shiftamt(shamt), 
        .data_result(ALU_out),
        .isNotEqual(ALU_is_NE),
        .isLessThan(ALU_is_LT),
        .overflow(ALU_ovf)
        );

    wire [31:0] muldiv_result;
    wire data_resultRDY;
    wire muldiv_data_ready, is_mul, is_div, mul_div_exception;
    wire is_an_alu_op;
    decoder check_alu(.alu(is_an_alu_op), .opcode(DX_IR[31:27]));
    assign is_mul = is_an_alu_op & (~ALU_op[4] & ~ALU_op[3] & ALU_op[2] & ALU_op[1] & ~ALU_op[0]);
    assign is_div = is_an_alu_op & (~ALU_op[4] & ~ALU_op[3] & ALU_op[2] & ALU_op[1] & ALU_op[0]);
        
    assign data_resultRDY = muldiv_data_ready;

    //set enable to high for when we are storing mul or div values
    //PC halted so dff will maintain values until cleared upon data_resultRDY
    dffe_ref dffM(ffM_out, is_mul, clock, 1'b1, data_resultRDY);
    dffe_ref dffD(ffD_out, is_div, clock, 1'b1, data_resultRDY);

    wire mul_start, div_start, mul_progress, div_progress;
    assign mul_start = (~ffM_out & is_mul & ~data_resultRDY);
    assign div_start = (~ffD_out & is_div & ~data_resultRDY);

    wire muldiv_busy;
    assign mul_progress = (ffM_out | mul_start);
    assign div_progress = (ffD_out | div_start);
    assign muldiv_busy = mul_progress | div_progress;

    multdiv mul_div(
        .data_operandA(ALU_in_A), 
        .data_operandB(ALU_in_B), 
        .ctrl_MULT(mul_start), 
        .ctrl_DIV(div_start),
        .clock(clock),
        .data_result(muldiv_result),
        .data_exception(mul_div_exception),
        .data_resultRDY(muldiv_data_ready)
        );


    //if jal, reassign ALU output to PC+1
    wire [31:0] ALU_final, data_out;
    wire DX_jal;
    decoder another_decoder(.jal(DX_jal), .opcode(DX_IR[31:27]));
    assign ALU_final = DX_jal ? (DX_PC + 32'd1): ALU_out;
    assign data_out = (data_resultRDY) ? muldiv_result : ALU_final;
    
    
    //check for branching
    wire is_branch, is_bne, is_blt, check_bne, check_blt;
    decoder check_branch(.bne(check_bne), .blt(check_blt), .opcode(DX_IR[31:27]));
    //clock the bne and blt one cycle to even
    dffe_ref bne_stall(is_bne, check_bne, clock, 1'b1, reset);
    dffe_ref blt_stall(is_blt, check_blt, clock, 1'b1, reset);
    assign is_branch = (is_bne & ALU_is_NE) | (is_blt & ALU_is_LT) | X_is_bex;

    //assign PC to branch value if branching, else PC_plus_one (unless JAL)
    wire [31:0] PC_Np1, N, PC_jr, PC_branch, PC_branch_final;
    wire [16:0] hold_DX_imm;
    gen_reg_17 stall_N(hold_DX_imm, DX_IR[16:0], clock, 1'b1, reset);
    sx sx_imm(.in(hold_DX_imm), .out(N));
    assign PC_Np1 = PC_plus_one + N;

    assign PC_branch = (is_branch & ~X_is_bex) ? PC_Np1 : PC_plus_one;
    assign PC_branch_final = (is_branch & X_is_bex) ? DX_IR[26:0] : PC_branch;
    assign PC_in  = is_branch ? PC_branch_final : PC_jump;

    wire [31:0] DX_checked_flush;
    assign DX_checked_flush = (is_branch | XM_is_jumping) ? 32'b0: DX_IR; 

    
    //HANDLE EXCEPTION DATA
    wire ovf_add, ovf_addi, ovf_sub, ovf_mul, ovf_div;
    alu_decoder get_ovf_ins(
        .instr_in(DX_IR), 
        .is_add(ovf_add),
        .is_addi(ovf_addi),
        .is_sub(ovf_sub),
        .is_mul(ovf_mul),
        .is_div(ovf_div)
        );

    wire [31:0] o_add_d, o_addi_d, o_sub_d, o_mul_d, o_div_d;
    assign o_add_d = 32'd1;
    assign o_addi_d = 32'd2;
    assign o_sub_d = 32'd3;
    assign o_mul_d = 32'd4;
    assign o_div_d = 32'd5;

    wire [31:0] exception_data;
    wire [2:0] s_ovf;
    assign s_ovf[2] = ovf_mul | ovf_div;
    assign s_ovf[1] = ovf_addi | ovf_sub;
    assign s_ovf[0] = ovf_add | ovf_sub | ovf_div;
    mux_8 ch_ovf(
        .out(exception_data), 
        .select(s_ovf), 
        .in0(32'b0),
        .in1(o_add_d),
        .in2(o_addi_d),
        .in3(o_sub_d),
        .in4(o_mul_d),
        .in5(o_div_d),
        .in6(32'b0),
        .in7(32'b0)
        );

    
    //check for div_by_zero exception
    wire div_by_zero;
    assign div_by_zero = ovf_div & (ALU_in_B == 32'd0);
    
    //select correct value to give to XM latch
    wire [31:0] data_out_final;
    wire [4:0] XM_rd_in;
    assign XM_rd_in = (ALU_ovf | mul_div_exception | div_by_zero) ? 5'd30 : DX_IR[26:22];
    assign data_out_final = (ALU_ovf | mul_div_exception) ? exception_data : data_out;



    //
    //  X/M
    //
    wire [31:0] XM_IR, XM_B, r31, XM_linked_PC;
    wire [4:0] XM_rd;
    wire XM_is_LT, XM_is_NE, XM_data_exception, XM_is_jumping, XM_md;
    XM xm(
        .IR_in(DX_checked_flush),
        .O_in(data_out_final),
        .rd_in(XM_rd_in),
        .r31_in(ALU_in_A),
        .B_in(DX_B),
        .j_in(DX_is_jumping),
        .LT_in(ALU_is_LT),
        .NE_in(ALU_is_NE),
        .ex_in(ALU_ovf),
        .linked_PC_in(DX_linked_PC),
        .is_md_in(p_or_q),
        .clk(clock),
        .en(~XM_master_stall),
        .clr(reset),
        .IR_out(XM_IR),
        .O_out(XM_O),
        .rd_out(XM_rd),
        .r31_out(r31),
        .B_out(XM_B),
        .j_out(XM_is_jumping),
        .LT_out(XM_is_LT),
        .NE_out(XM_is_NE),
        .ex_out(XM_data_exception),
        .linked_PC_out(XM_linked_PC),
        .is_md_out(XM_md)
    );
    
    //memory pre-processing for sw
    wire is_sw_write;
    decoder check_sw_write(.sw(is_sw_write), .opcode(XM_IR[31:27]));
    assign wren = is_sw_write;
    assign data = (is_sw_write & HWM) ? reg_file_wr_d: XM_B;
    assign address_dmem = XM_O;



    //
    //  M/W
    //
    wire [31:0] MW_IR, MW_O, MW_D, MW_linked_PC;
    // wire [4:0] mul_div_rd;
    wire [4:0] MW_IR_op, MW_rd;
    wire MW_data_exception, MW_md;
    MW mw(
        .IR_in(XM_IR),
        .O_in(XM_O),
        .rd_in(XM_rd),
        .Dmem_in(q_dmem),
        .ex_in(XM_data_exception),
        .linked_PC_in(XM_linked_PC),
        .is_md_in(XM_md),
        .clk(clock),
        .en(~MW_master_stall),
        .clr(reset),
        .IR_out(MW_IR),
        .O_out(MW_O),
        .rd_out(MW_rd),
        .D_out(MW_D),
        .ex_out(MW_data_exception),
        .linked_PC_out(MW_linked_PC),
        .is_md_out(MW_md)
    );
    
    //assign reg_file write data based on instruction
    wire is_lw;
    decoder check_MW_lw(.opcode(MW_IR[31:27]), .lw(is_lw));
    // if lw, take output data from dmem, else take MW_O
    assign reg_file_wr_d = is_lw ? q_dmem: MW_O;
    

    //assign corresponding writeReg values
    wire MW_jal, MW_setx;
    decoder a_decoder(.jal(MW_jal), .setx(MW_setx), .opcode(MW_IR[31:27]));
    //first check jal
    wire [4:0] wr_dest;
    wire [4:0] final_reg_dest;
    // assign wr_dest = MW_jal ? 5'b31 : MW_IR[26:22];
    assign wr_dest[4] = MW_jal ? 1'b1: MW_rd[4];
    assign wr_dest[3] = MW_jal ? 1'b1: MW_rd[3];
    assign wr_dest[2] = MW_jal ? 1'b1: MW_rd[2];
    assign wr_dest[1] = MW_jal ? 1'b1: MW_rd[1];
    assign wr_dest[0] = MW_jal ? 1'b1: MW_rd[0];
    
    assign final_reg_dest[4] = MW_setx ? 1'b1 : wr_dest[4];
    assign final_reg_dest[3] = MW_setx ? 1'b1 : wr_dest[3];
    assign final_reg_dest[2] = MW_setx ? 1'b1 : wr_dest[2];
    assign final_reg_dest[1] = MW_setx ? 1'b1 : wr_dest[1];
    assign final_reg_dest[0] = MW_setx ? 1'b0 : wr_dest[0];
    

    //disallow reg_wr_enable for sw, j, jr, bne, blt, bex
    wire allow_reg_write;
    check_reg_we cwe(.allow(allow_reg_write), .ins_opcode(MW_IR[31:27]));
    assign data_writeReg = MW_setx ?  MW_IR[26:0] : reg_file_wr_d;
    assign ctrl_writeReg = final_reg_dest;
    assign ctrl_writeEnable = allow_reg_write;
    
    //STALLS
    assign PC_master_stall = muldiv_busy | LA_stall;
    assign FD_master_stall = muldiv_busy | LA_stall;
    assign DX_master_stall = muldiv_busy;
    assign XM_master_stall = muldiv_busy;
    assign MW_master_stall = muldiv_busy;

	/* END CODE */

endmodule
