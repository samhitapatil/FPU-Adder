module fpu (ip1,ip2,result);
    input [31:0]ip1;
    input [31:0]ip2;
    //input clk;
    output reg [31:0]result;
    
     wire sign1,sign2;
     wire [7:0] exp1;
     wire [7:0] exp2;
     reg [7:0] exp1out;
     reg [7:0] exp2out;
     reg [7:0] net_expout;
     reg [7:0] diff;
     reg   [7:0] net_exp;
     wire  [23:0] mantissa1;
     wire  [23:0] mantissa2;
     reg [23:0] new_mantissa;
     reg  [24:0] net_mantissa;
    
    integer i=0;
    //assign ip1 = {sign1,exp1,mantissa1};
    //31 bit : sign, 30-23 bit: exp, 22-0 bit: mantissa
    // if sign = 1 : negative otherwise positive
    
    assign sign1 = ip1[31] ;
    assign sign2 = ip2[31] ;
    assign exp1 = ip1[30:23] ;
    assign exp2 = ip2[30:23] ;
    assign mantissa1 = {1'b1,ip1[22:0]};//have to add 23rd bit
    assign mantissa2 = {1'b1,ip2[22:0]};
    
    
always @(*)
begin
if(exp1==exp2)//case1
begin
    if(sign1 != sign2)//subcase11
    begin
        if(mantissa1>mantissa2)//subcase111
        begin
        exp1out = exp1;
        net_mantissa = mantissa1 - mantissa2; 
            for(i=0;i<24;i=i+1)     
            //while (net_mantissa[23] == 0) 
            begin           //underflow
            if(net_mantissa[23] == 0)
            begin
            net_mantissa = net_mantissa<<1;
            exp1out = exp1out - 1'b1;
            end
            end
        result = {sign1,exp1out[7:0],net_mantissa[22:0]};
        end
        
        else if(mantissa1<mantissa2)//subcase112
        begin
        net_mantissa = mantissa2 - mantissa1;    
        exp2out = exp2;        
            for(i=0;i<24;i=i+1)               //underflow
            //while (net_mantissa[23] == 0)    
            begin
            if(net_mantissa[23] == 0) 
            begin
            net_mantissa = net_mantissa<<1;
            exp2out = exp2out - 1'b1;
            end
            end
        result = {sign2,exp2out[7:0],net_mantissa[22:0]};
        end
        
        
        else if (mantissa2==mantissa1)//subcase113
        result = 32'b0;
    
    end
   
    else if(sign1 == sign2)//subcase13
    begin 
    net_mantissa = mantissa1 + mantissa2;
        if(net_mantissa[24] == 0)//check for overflow
        result = {sign2,exp2[7:0],net_mantissa[22:0]};
        
        else if(net_mantissa[24] == 1)
        begin
            net_mantissa = net_mantissa>>1;
            exp2out = exp2 + 1'b1;
            result = {sign2,exp2out[7:0],net_mantissa[22:0]};
        end
    end
end

else if (exp2>exp1)//case2
begin
diff = exp2-exp1;
net_exp = exp2;
new_mantissa = (mantissa1 >> diff);
    if(sign1 == sign2)//subcase21 
    begin
    net_mantissa = new_mantissa + mantissa2;
        if(net_mantissa[24] == 1)//check for overflow
        begin
            net_mantissa = net_mantissa>>1;
            net_expout = net_exp+1'b1;
            result = {sign1,net_expout[7:0],net_mantissa[22:0]}; 
        end
        else if(net_mantissa[24] == 0)//check for overflow
        begin
            net_expout = net_exp;
            result = {sign1,net_expout[7:0],net_mantissa[22:0]}; 
        end
    end
    else if(sign1 != sign2)//subcase22
    begin
        if(mantissa1>mantissa2)
        begin
            net_mantissa = new_mantissa - mantissa2;
            for(i=0;i<24;i=i+1)
            begin
            //while (net_mantissa[23] == 0)            //underflow
            if(net_mantissa[23] == 0) 
            begin
            net_mantissa = net_mantissa<<1;
            net_exp = net_exp - 1'b1;
            end            
            end
            result = {sign2,net_exp[7:0],net_mantissa[23:0]};
        end 
        else if(mantissa2>mantissa1)
        begin
            net_mantissa = mantissa2 - new_mantissa ;          
            //while (net_mantissa[23] == 0)            //underflow
            for(i=0;i<24;i=i+1)
            begin
            if(net_mantissa[23] == 0) 
            begin
            net_mantissa = net_mantissa<<1;
            net_exp = net_exp - 1'b1;
            end
            end
            result = {sign2,net_exp[7:0],net_mantissa[22:0]};
        end 
        else if(mantissa2==new_mantissa)
        begin
             net_mantissa = 25'b0 ;
            result = {sign2,net_exp[7:0],net_mantissa[22:0]};
        end 
    end
end

else if (exp1>exp2)//case3
begin
diff = exp1-exp2;
net_exp = exp1;
new_mantissa = (mantissa2 >> diff);
    if(sign1 == sign2)//subcase31 
    begin
    net_mantissa = new_mantissa + mantissa1;
        if(net_mantissa[24] == 1)//check for overflow
        begin
            net_mantissa = net_mantissa>>1;
            net_expout = net_exp + 1'b1;         ///checkkkkk
            result = {sign1,net_expout[7:0],net_mantissa[22:0]}; 
        end
        else if(net_mantissa[24] == 0)//check for overflow
        begin
            net_expout = net_exp;        ///check
            result = {sign1,net_expout[7:0],net_mantissa[22:0]}; 
        end
    end
    else if(sign1 != sign2)//subcase32
    begin
        if(mantissa1>new_mantissa)
        begin
            net_mantissa = mantissa1 - new_mantissa;           
            //while (net_mantissa[23] == 0)            //underflow
            for(i=0;i<24;i=i+1)
            begin
            if(net_mantissa[23] == 0) 
            begin
            net_mantissa = net_mantissa<<1;
            net_exp = net_exp - 1'b1;
            end            
            end
            result = {sign1,net_exp[7:0],net_mantissa[22:0]};
        end 
        else if(new_mantissa>mantissa1)
        begin
            net_mantissa = new_mantissa - mantissa1 ;            
            //while (net_mantissa[23] == 0)            //underflow
            for(i=0;i<24;i=i+1)
            begin
            if(net_mantissa[23] == 0) 
            begin
            net_mantissa = net_mantissa<<1;
            net_exp = net_exp - 1'b1;
            end        
            end
            result = {sign1,net_exp[7:0],net_mantissa[22:0]};
        end 
        else if(mantissa1==new_mantissa)
        begin
             net_mantissa = 24'b0 ;
            result = {sign1,net_exp[7:0],net_mantissa[22:0]};
        end 
    end
end
 
end
endmodule

//normalisation in addition will have to check for carry in sum of mantissa, if overflow detected shift mantissa by 1 right and add 1 to exponent
// in subraction check sum for leading zeroes and shift mantissa left till msb becomes 1
