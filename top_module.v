module top_module(ip1,ip2,clk,rst,result);
    input [31:0]ip1;
    input [31:0]ip2;
    input clk;
    input rst;
    output reg [31:0]result; //made wns tns not NA
    
    wire [31:0] oop;
    wire [31:0] iip1;
    wire [31:0] iip2;
    wire [31:0] op1;

flip_flop flip_flop1 (ip1,clk,iip1,rst);
flip_flop flip_flop2 (ip2,clk,iip2,rst);
fpu fpu1 (iip1,iip2,oop);
flip_flop flip_flop3 (oop,clk,op1,rst);

always @ (posedge clk) begin 
    result <= op1;
end
endmodule
