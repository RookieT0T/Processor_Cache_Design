module BitCell(input clk,  input rst, input D, input WriteEnable, input ReadEnable1, input ReadEnable2, inout Bitline1, inout Bitline2);
	
	wire dataout;
	
	dff idff(.q(dataout), .d(D), .wen(WriteEnable), .clk(clk), .rst(rst));
	
	assign Bitline1 = (ReadEnable1) ? dataout : 1'bz;
	assign Bitline2 = (ReadEnable2) ? dataout : 1'bz;
	
endmodule