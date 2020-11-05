module lfsr_32    (
value             ,  // Output of the counter
data            ,  // Input
enable          ,  // Enable  for counter
clk                // clock input
);

//----------Output Ports--------------
output [31:0] value;
//------------Input Ports--------------
input [31:0] data;
input enable, clk;
reg [31:0] out;
//------------Internal Variables--------
gen_reg register(.q(value), .d(out), .clk(clk), .en(1'b1), .clr(1'b0));
wire        linear_feedback_one;

//-------------Code Starts Here-------
assign linear_feedback_one = !(value[9] ^ value[3]);


//EDGE CASE: possible to have the random value to be zero.
always @(posedge clk) begin
  if (enable) begin
  out[31] = 1'b0;
  out[30:1] = value[29:0];
  out[0] = linear_feedback_one;
end 
end


endmodule // End Of Module counter