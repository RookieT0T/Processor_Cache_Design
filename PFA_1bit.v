module PFA_1bit(a, b, cin, s, g, p);
input a,b,cin;
output s,g,p;

wire p_int;

assign g = a & b;
assign p_int = a ^ b;
assign s = p_int ^ cin;
assign p = p_int;
endmodule