module lfsr_32    (
out             ,  // Output of the counter
data            ,  // Input
enable          ,  // Enable  for counter
clk                // clock input
);

//----------Output Ports--------------
output [31:0] out;
//------------Input Ports--------------
input [31:0] data;
input enable, clk;
reg [31:0] in = 32'b0;
//------------Internal Variables--------
gen_reg register(.q(out), .d(in), .clk(clk), .en(1'b1), .clr(1'b0));
wire        linear_feedback_one;

//-------------Code Starts Here-------
// assign linear_feedback_one = !(out[9] ^ out[3]);
assign linear_feedback_one = !(in[9] ^ in[3]);


//EDGE CASE: possible to have the random value to be zero.
always @(posedge clk) begin
  if (enable) begin
  in[31] = 1'b0;
  in[30:1] = in[29:0];
  in[0] = linear_feedback_one;
end 
end


endmodule // End Of Module counter