module hazard_detect(fd_rs, fd_rt, fd_op, dx_rs, dx_rt, dx_rd, dx_op, 
                        xm_rd, mw_rd, hazard, MX_A, MX_B, WX_A, WX_B, WM, LA_stall);
    
    input [4:0] fd_rs, fd_rt, fd_op, dx_rs, dx_rt, dx_rd, dx_op, xm_rd, mw_rd;
    output hazard, MX_A, MX_B, WX_A, WX_B, WM, LA_stall;
    
    //MX 
    assign MX_A = (dx_rs == xm_rd) && (xm_rd != 5'b0);
    assign MX_B = (dx_rt == xm_rd) && (xm_rd != 5'b0);
    
    //WX
    assign WX_A = (dx_rs == mw_rd) && (mw_rd != 5'b0);
    assign WX_B = (dx_rt == mw_rd) && (mw_rd != 5'b0);

    //WM
    assign  WM  = (xm_rd == mw_rd) && (mw_rd != 5'b0);

    //Load Output to ALU Input
    wire fd_is_sw, dx_is_lw;
    decoder get_fd(.sw(fd_is_sw), .opcode(fd_op));
    decoder get_dx(.lw(dx_is_lw), .opcode(dx_op));
    assign LA_stall = dx_is_lw & (fd_rs == dx_rd || (fd_rt == dx_rd && ~fd_is_sw));

    //bex 
    

    //Broadcast hazard
    or check_haz(hazard, MX_A, MX_B, WX_A, WX_B);

endmodule