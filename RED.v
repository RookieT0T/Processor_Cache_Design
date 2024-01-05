module RED(a, b, sum);
input [15:0] a, b;
output [15:0] sum;

wire [3:0] s1, s2, s3, s4;
wire [8:0] s_int1, s_int2;
wire [15:0] sum_int;  
wire g1, g2, g3, G1, G2, dummyG, dummyP,ovfl;

CLA_4bit claA (.a(a[11:8]), .b(b[11:8]), .cin(1'b0), .s(s3), .g(g2), .p(dummyP));
CLA_4bit claC (.a(a[15:12]), .b(b[15:12]), .cin(g2), .s(s4), .g(G1), .p(dummyP));
assign s_int2 = {G1, s4, s3};

CLA_4bit claB (.a(a[3:0]), .b(b[3:0]), .cin(1'b0), .s(s1), .g(g1), .p(dummyP));
CLA_4bit claD (.a(a[7:4]), .b(b[7:4]), .cin(g1), .s(s2), .g(G2), .p(dummyP));
  assign s_int1 = {G2, s2, s1};

CLA_16bit cla (.a({7'h00,s_int1}), .b({7'h00,s_int2}), .sub(1'b0), .sum(sum_int), .ggg(g3), .ppp(dummyP),.ovfl(ovfl));

  assign sum = {{6{sum_int[9]}},sum_int[9:0]};

endmodule
