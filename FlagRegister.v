module flag_register(clk, rst, flag_in, flag_out, wen);

input clk, rst, wen;
input [2:0] flag_in;
output [2:0] flag_out;

// always write enable
dff i0(.q(flag_out[0]), .d(flag_in[0]), .wen(wen), .clk(clk), .rst(rst));
dff i1(.q(flag_out[1]), .d(flag_in[1]), .wen(wen), .clk(clk), .rst(rst));
dff i2(.q(flag_out[2]), .d(flag_in[2]), .wen(wen), .clk(clk), .rst(rst));

endmodule

	