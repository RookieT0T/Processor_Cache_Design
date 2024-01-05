module PCRegister(clk, rst, wen, newAddr, curAddr);
	input clk;
	input rst;
	input wen;
	input [15:0] newAddr;
	output [15:0] curAddr;
	
	// 16 DFFs
	dff idffs [15:0] (.q(curAddr), .d(newAddr), .wen({16{wen}}), .clk({16{clk}}), .rst({16{rst}}));
	
endmodule