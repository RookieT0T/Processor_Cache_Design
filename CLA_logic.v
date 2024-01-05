module CLA_logic(g,p,cin,gg,pp,cout);
input [3:0] g,p;
input cin;
output gg,pp;
output [3:1] cout;
wire pp_int, gg_int;


assign cout[1] = g[0] | p[0] & cin;
assign cout[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin);
assign cout[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & cin);
assign gg_int = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
assign pp_int = p[3] & p[2] & p[1] & p[0];
assign pp = pp_int;
assign gg = gg_int;
endmodule
