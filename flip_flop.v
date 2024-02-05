module flip_flop(Q,clk,D,rst);
input [31:0]Q;
input clk;
input rst;
output reg [31:0]D;

always@(posedge clk)
if(rst == 1)
begin
D <= 'd0;
end
else
begin
D<=Q;
end
endmodule
