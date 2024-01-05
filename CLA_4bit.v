module CLA_4bit(a, b, cin, s, g, p);
input [3:0] a, b;
input cin;
output [3:0] s;
output g, p;

wire [3:0] g_vec, p_vec; 
wire [3:1] cout_vec;

CLA_logic logic1(.g(g_vec),.p(p_vec),.cin(cin),.gg(g),.pp(p),.cout(cout_vec));
PFA_1bit adder1(.a(a[0]), .b(b[0]), .cin(cin), .s(s[0]), .g(g_vec[0]), .p(p_vec[0]));
PFA_1bit adder2(.a(a[1]), .b(b[1]), .cin(cout_vec[1]), .s(s[1]), .g(g_vec[1]), .p(p_vec[1]));
PFA_1bit adder3(.a(a[2]), .b(b[2]), .cin(cout_vec[2]), .s(s[2]), .g(g_vec[2]), .p(p_vec[2]));
PFA_1bit adder4(.a(a[3]), .b(b[3]), .cin(cout_vec[3]), .s(s[3]), .g(g_vec[3]), .p(p_vec[3]));

endmodule