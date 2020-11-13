module ascii_decoder(data_out, ascii_input);
    input [11:0] ascii_input;
    output [31:0] data_out;

    always @* begin
        case(ascii_input)
            12'd49: assign data_out = 32'd1;
            12'd50: assign data_out = 32'd2;
            12'd51: assign data_out = 32'd3;
            12'd52: assign data_out = 32'd4;
            12'd53: assign data_out = 32'd5;
            12'd54: assign data_out = 32'd6;
            12'd55: assign data_out = 32'd7;
            12'd56: assign data_out = 32'd8;
            12'd57: assign data_out = 32'd9;
            default: assign data_out = 32'd0;
        endcase
     
    end


endmodule