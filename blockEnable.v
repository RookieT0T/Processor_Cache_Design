module blockEnable(setBits, blockEnable);
	input [5:0] setBits;
	output [63:0] blockEnable;
	
	wire [63:0] b0, b1, b2, b3, b4, b5;
	
	assign b0 = {{63{1'b0}}, 1'b1};
	assign b1 = (setBits[0]) ? b0 << 1 : b0;
	assign b2 = (setBits[1]) ? b1 << 2 : b1;
	assign b3 = (setBits[2]) ? b2 << 4 : b2;
	assign b4 = (setBits[3]) ? b3 << 8 : b3;
	assign b5 = (setBits[4]) ? b4 << 16 : b4;
	assign blockEnable = (setBits[5]) ? b5 << 32 : b5;

endmodule