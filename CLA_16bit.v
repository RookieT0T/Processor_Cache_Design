module CLA_16bit(a, b, sub, sum, ppp, ggg, ovfl);
input [15:0] a,b;
input sub;
output [15:0] sum;
output ppp, ggg, ovfl;

wire [3:1] c;
wire [15:0] bPrime, sumRaw;
wire [3:0] G, P;

assign bPrime = (sub) ? ~b	: b;


CLA_logic logic1(.g(G),.p(P),.cin(sub),.gg(ggg),.pp(ppp),.cout(c));
CLA_4bit cla1 (.a(a[3:0]), .b(bPrime[3:0]), .cin(sub), .s(sumRaw[3:0]),.p(P[0]), .g(G[0]));
CLA_4bit cla2 (.a(a[7:4]), .b(bPrime[7:4]), .cin(c[1]), .s(sumRaw[7:4]),.p(P[1]), .g(G[1]));
CLA_4bit cla3 (.a(a[11:8]), .b(bPrime[11:8]), .cin(c[2]), .s(sumRaw[11:8]),.p(P[2]), .g(G[2]));
CLA_4bit cla4 (.a(a[15:12]), .b(bPrime[15:12]), .cin(c[3]), .s(sumRaw[15:12]),.p(P[3]), .g(G[3]));

assign ovfl = ((a[15]&bPrime[15]&!sumRaw[15])||(!a[15]&!bPrime[15]&sumRaw[15])) ? 1'b1 : 1'b0;
assign sum = (ovfl) ? ((a[15]) ? 16'h8000 : 16'h7FFF) : sumRaw;
endmodule