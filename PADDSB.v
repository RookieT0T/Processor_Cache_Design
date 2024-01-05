module PADDSB(a, b, sum);
input [15:0] a, b;
output [15:0] sum;

wire [3:0] s1, s2, s3, s4;
wire ovfl1, ovfl2, ovfl3, ovfl4, dummyG, dummyP;

CLA_4bit cla1 (.a(a[3:0]), .b(b[3:0]), .cin(1'b0), .s(s1), .g(dummyG), .p(dummyP));
assign ovfl1 = ((a[3]&b[3]&!s1[3])||(!a[3]&!b[3]&s1[3])) ? 1'b1 : 1'b0;
assign sum[3:0] = (ovfl1) ? ((a[3]) ? 4'b1000 : 4'b0111) : s1;

CLA_4bit cla2 (.a(a[7:4]), .b(b[7:4]), .cin(1'b0), .s(s2), .g(dummyG), .p(dummyP));
assign ovfl2 = ((a[7]&b[7]&!s2[3])||(!a[7]&!b[7]&s2[3])) ? 1'b1 : 1'b0;
assign sum[7:4] = (ovfl2) ? ((a[7]) ? 4'b1000 : 4'b0111) : s2;

CLA_4bit cla3 (.a(a[11:8]), .b(b[11:8]), .cin(1'b0), .s(s3), .g(dummyG), .p(dummyP));
assign ovfl3 = ((a[11]&b[11]&!s3[3])||(!a[11]&!b[11]&s3[3])) ? 1'b1 : 1'b0;
assign sum[11:8] = (ovfl3) ? ((a[11]) ? 4'b1000 : 4'b0111) : s3;

CLA_4bit cla4 (.a(a[15:12]), .b(b[15:12]), .cin(1'b0), .s(s4), .g(dummyG), .p(dummyP));
assign ovfl4 = ((a[15]&b[15]&!s4[3])||(!a[15]&!b[15]&s4[3])) ? 1'b1 : 1'b0;
assign sum[15:12] = (ovfl4) ? ((a[15]) ? 4'b1000 : 4'b0111) : s4;

endmodule