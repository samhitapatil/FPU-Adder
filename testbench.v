module testbench();
reg [31:0]ip1;
reg [31:0]ip2;
reg clk;
reg rst;
//reg sign1,sign2;
//reg [2:0] exp1;
//reg [2:0] exp2;
//reg [3:0] mantissa1;
//reg [3:0] mantissa2;
//wire [3:0] net_mantissa;
wire [31:0]result;

top_module dut(.ip1(ip1),.ip2(ip2),.clk(clk),.rst(rst),.result(result));
always
#10 clk = ~clk;
initial begin
#30
rst = 1'b1;
#30
////case1 
clk=1'b0;
rst = 1'b0;
ip1 = 32'b00000000000000000000000000000000;   
ip2 = 32'b00000000000000000000000000000000;

#20
ip1 = 32'b00000000011111111111111111111111;   
ip2 = 32'b10000000011111111111111111111111;

#20
ip1 = 32'b00000000000000000000000000000000;   
ip2 = 32'b10000000000000000000000000000001;  

#20
ip1 = 32'b00000000011111111111100000000000;  
ip2 = 32'b10000000011111111111111111111111; 

#20
ip1 = 32'b00000000011111111111111111111111;   
ip2 = 32'b00000000011111111111111111111111;

//case2
#20
ip1 = 32'b00111111110000000000000000000000;//1.5
ip2 = 32'b01000000010000000000000000000000;//3



#20
ip1 = 32'b01000000011000000000000000000000;//3.5
ip2 = 32'b01000000101100000000000000000000;//5.5

#20
ip2 = 32'b01000001010001001100110011001101;//12.3
ip1 = 32'b01000000100001100110011001100110;//4.2


#20
ip1 = 32'b01000000100001100110011001100110;//4.2
ip2 = 32'b11000001010001001100110011001101;//-12.3


#20
ip1 = 32'b11000000100001100110011001100110;//-4.2
ip2 = 32'b01000001010001001100110011001101;//12.3


#20
ip1 = 32'b01000000100000000000100000110001;//4.001
ip2 = 32'b11000001111111111111011111001111;//-31.999

//case3
#20
ip1 = 32'b01000001111111111111011111001111;//31.999
ip2 = 32'b01000000100000000000100000110001;//4.001


#20
ip1 = 32'b01000001010010000000000000000000;//12.5
ip2 = 32'b01000000010100110011001100110011;//3.3

#20
ip1 = 32'b01000000111110100011110101110001;//7.82
ip2 = 32'b01000001000000101110000101001000;//8.18


#20
ip1 = 32'b01000001011101101110000101001000;//15.43
ip2 = 32'b01000001010100111000010100011111;//13.22


#20
ip1 = 32'b01000001011101101110000101001000;//15.43
ip2 = 32'b11000000010011100001010001111011;//-3.22


//underflow
#20
ip1 = 32'b01000000001101010000000000000000;//2.828125
ip2 = 32'b11000000001011000000000000000000;//-2.6875

#20
$finish;

end
endmodule
