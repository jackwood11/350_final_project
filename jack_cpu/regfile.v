module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB
);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;

	output [31:0] data_readRegA, data_readRegB;

	wire [31:0] regWriteEnable, AregRead, BregRead;
	wire [31:0] activewire;
	wire we2,we3,we4,we5,we6,we7,we8,we9,we10,we11,we12,we13,we14,we15,we16,we17,we18,we19,we20,we21,we22,we23,we24,we25,we26,we27,we28,we29,we30,we31;
	wire [31:0] o0,o1,o2,o3,o4,o5,o6,o7,o8,o9,o10,o11,o12,o13,o14,o15,o16,o17,o18,o19,o20,o21,o22,o23,o24,o25,o26,o27,o28,o29,o30,o31;

	//get random number
	//Q: how computationally expensive is constantly generating random numbers??
	//Alluding to that we may only want to trigger random number generation upon READS to r1 register
	//That is, assuming, we are not eliminating "randomness" due to short lifecycle
	wire [31:0] random_val;
	lfsr_32 lfsr(.value(random_val), .data(32'b0), .enable(1'b1), .clk(clock));

	//take 5-bit number turn 1-bit on for corresponding register
	decoder_32 decode(regWriteEnable, ctrl_writeReg);

	and writeEnable2(we2, ctrl_writeEnable, regWriteEnable[2]);
	and writeEnable3(we3, ctrl_writeEnable, regWriteEnable[3]);
	and writeEnable4(we4, ctrl_writeEnable, regWriteEnable[4]);
	and writeEnable5(we5, ctrl_writeEnable, regWriteEnable[5]);
	and writeEnable6(we6, ctrl_writeEnable, regWriteEnable[6]);
	and writeEnable7(we7, ctrl_writeEnable, regWriteEnable[7]);
	and writeEnable8(we8, ctrl_writeEnable, regWriteEnable[8]);
	and writeEnable9(we9, ctrl_writeEnable, regWriteEnable[9]);
	and writeEnable10(we10, ctrl_writeEnable, regWriteEnable[10]);
	and writeEnable11(we11, ctrl_writeEnable, regWriteEnable[11]);
	and writeEnable12(we12, ctrl_writeEnable, regWriteEnable[12]);
	and writeEnable13(we13, ctrl_writeEnable, regWriteEnable[13]);
	and writeEnable14(we14, ctrl_writeEnable, regWriteEnable[14]);
	and writeEnable15(we15, ctrl_writeEnable, regWriteEnable[15]);
	and writeEnable16(we16, ctrl_writeEnable, regWriteEnable[16]);
	and writeEnable17(we17, ctrl_writeEnable, regWriteEnable[17]);
	and writeEnable18(we18, ctrl_writeEnable, regWriteEnable[18]);
	and writeEnable19(we19, ctrl_writeEnable, regWriteEnable[19]);
	and writeEnable20(we20, ctrl_writeEnable, regWriteEnable[20]);
	and writeEnable21(we21, ctrl_writeEnable, regWriteEnable[21]);
	and writeEnable22(we22, ctrl_writeEnable, regWriteEnable[22]);
	and writeEnable23(we23, ctrl_writeEnable, regWriteEnable[23]);
	and writeEnable24(we24, ctrl_writeEnable, regWriteEnable[24]);
	and writeEnable25(we25, ctrl_writeEnable, regWriteEnable[25]);
	and writeEnable26(we26, ctrl_writeEnable, regWriteEnable[26]);
	and writeEnable27(we27, ctrl_writeEnable, regWriteEnable[27]);
	and writeEnable28(we28, ctrl_writeEnable, regWriteEnable[28]);
	and writeEnable29(we29, ctrl_writeEnable, regWriteEnable[29]);
	and writeEnable30(we30, ctrl_writeEnable, regWriteEnable[30]);
	and writeEnable31(we31, ctrl_writeEnable, regWriteEnable[31]);


	gen_reg r0(o0, 32'b0, clock, 1'b0, 1'b0);
	gen_reg r1(o1, random_val, clock, 1'b1, 1'b0);
	gen_reg r2(o2, data_writeReg, clock, we2, ctrl_reset);
	gen_reg r3(o3, data_writeReg, clock, we3, ctrl_reset);
	gen_reg r4(o4, data_writeReg, clock, we4, ctrl_reset);
	gen_reg r5(o5, data_writeReg, clock, we5, ctrl_reset);
	gen_reg r6(o6, data_writeReg, clock, we6, ctrl_reset);
	gen_reg r7(o7, data_writeReg, clock, we7, ctrl_reset);
	gen_reg r8(o8, data_writeReg, clock, we8, ctrl_reset);
	gen_reg r9(o9, data_writeReg, clock, we9, ctrl_reset);
	gen_reg r10(o10, data_writeReg, clock, we10, ctrl_reset);
	gen_reg r11(o11, data_writeReg, clock, we11, ctrl_reset);
	gen_reg r12(o12, data_writeReg, clock, we12, ctrl_reset);
	gen_reg r13(o13, data_writeReg, clock, we13, ctrl_reset);
	gen_reg r14(o14, data_writeReg, clock, we14, ctrl_reset);
	gen_reg r15(o15, data_writeReg, clock, we15, ctrl_reset);
	gen_reg r16(o16, data_writeReg, clock, we16, ctrl_reset);
	gen_reg r17(o17, data_writeReg, clock, we17, ctrl_reset);
	gen_reg r18(o18, data_writeReg, clock, we18, ctrl_reset);
	gen_reg r19(o19, data_writeReg, clock, we19, ctrl_reset);
	gen_reg r20(o20, data_writeReg, clock, we20, ctrl_reset);
	gen_reg r21(o21, data_writeReg, clock, we21, ctrl_reset);
	gen_reg r22(o22, data_writeReg, clock, we22, ctrl_reset);
	gen_reg r23(o23, data_writeReg, clock, we23, ctrl_reset);
	gen_reg r24(o24, data_writeReg, clock, we24, ctrl_reset);
	gen_reg r25(o25, data_writeReg, clock, we25, ctrl_reset);
	gen_reg r26(o26, data_writeReg, clock, we26, ctrl_reset);
	gen_reg r27(o27, data_writeReg, clock, we27, ctrl_reset);
	gen_reg r28(o28, data_writeReg, clock, we28, ctrl_reset);
	gen_reg r29(o29, data_writeReg, clock, we29, ctrl_reset);
	gen_reg r30(o30, data_writeReg, clock, we30, ctrl_reset);
	gen_reg r31(o31, data_writeReg, clock, we31, ctrl_reset);


	decoder_32 reg_a_val(AregRead, ctrl_readRegA);
	decoder_32 reg_b_val(BregRead, ctrl_readRegB);
	tri_state t0(o0, BregRead[0], data_readRegB);
	tri_state t1(o1, BregRead[1], data_readRegB);
	tri_state t2(o2, BregRead[2], data_readRegB);
	tri_state t3(o3, BregRead[3], data_readRegB);
	tri_state t4(o4, BregRead[4], data_readRegB);
	tri_state t5(o5, BregRead[5], data_readRegB);
	tri_state t6(o6, BregRead[6], data_readRegB);
	tri_state t7(o7, BregRead[7], data_readRegB);
	tri_state t8(o8, BregRead[8], data_readRegB);
	tri_state t9(o9, BregRead[9], data_readRegB);
	tri_state t10(o10, BregRead[10], data_readRegB);
	tri_state t11(o11, BregRead[11], data_readRegB);
	tri_state t12(o12, BregRead[12], data_readRegB);
	tri_state t13(o13, BregRead[13], data_readRegB);
	tri_state t14(o14, BregRead[14], data_readRegB);
	tri_state t15(o15, BregRead[15], data_readRegB);
	tri_state t16(o16, BregRead[16], data_readRegB);
	tri_state t17(o17, BregRead[17], data_readRegB);
	tri_state t18(o18, BregRead[18], data_readRegB);
	tri_state t19(o19, BregRead[19], data_readRegB);
	tri_state t20(o20, BregRead[20], data_readRegB);
	tri_state t21(o21, BregRead[21], data_readRegB);
	tri_state t22(o22, BregRead[22], data_readRegB);
	tri_state t23(o23, BregRead[23], data_readRegB);
	tri_state t24(o24, BregRead[24], data_readRegB);
	tri_state t25(o25, BregRead[25], data_readRegB);
	tri_state t26(o26, BregRead[26], data_readRegB);
	tri_state t27(o27, BregRead[27], data_readRegB);
	tri_state t28(o28, BregRead[28], data_readRegB);
	tri_state t29(o29, BregRead[29], data_readRegB);
	tri_state t30(o30, BregRead[30], data_readRegB);
	tri_state t31(o31, BregRead[31], data_readRegB);
	

	
	tri_state at0(o0, AregRead[0], data_readRegA);
	tri_state at1(o1, AregRead[1], data_readRegA);
	tri_state at2(o2, AregRead[2], data_readRegA);
	tri_state at3(o3, AregRead[3], data_readRegA);
	tri_state at4(o4, AregRead[4], data_readRegA);
	tri_state at5(o5, AregRead[5], data_readRegA);
	tri_state at6(o6, AregRead[6], data_readRegA);
	tri_state at7(o7, AregRead[7], data_readRegA);
	tri_state at8(o8, AregRead[8], data_readRegA);
	tri_state at9(o9, AregRead[9], data_readRegA);
	tri_state at10(o10, AregRead[10], data_readRegA);
	tri_state at11(o11, AregRead[11], data_readRegA);
	tri_state at12(o12, AregRead[12], data_readRegA);
	tri_state at13(o13, AregRead[13], data_readRegA);
	tri_state at14(o14, AregRead[14], data_readRegA);
	tri_state at15(o15, AregRead[15], data_readRegA);
	tri_state at16(o16, AregRead[16], data_readRegA);
	tri_state at17(o17, AregRead[17], data_readRegA);
	tri_state at18(o18, AregRead[18], data_readRegA);
	tri_state at19(o19, AregRead[19], data_readRegA);
	tri_state at20(o20, AregRead[20], data_readRegA);
	tri_state at21(o21, AregRead[21], data_readRegA);
	tri_state at22(o22, AregRead[22], data_readRegA);
	tri_state at23(o23, AregRead[23], data_readRegA);
	tri_state at24(o24, AregRead[24], data_readRegA);
	tri_state at25(o25, AregRead[25], data_readRegA);
	tri_state at26(o26, AregRead[26], data_readRegA);
	tri_state at27(o27, AregRead[27], data_readRegA);
	tri_state at28(o28, AregRead[28], data_readRegA);
	tri_state at29(o29, AregRead[29], data_readRegA);
	tri_state at30(o30, AregRead[30], data_readRegA);
	tri_state at31(o31, AregRead[31], data_readRegA);



endmodule
