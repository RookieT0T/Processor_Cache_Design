module Register( input clk,  input rst, input [15:0] D, input WriteReg, input ReadEnable1, input ReadEnable2, inout [15:0] Bitline1, inout [15:0] Bitline2);
	
	BitCell iBitCells [15:0] (.clk({16{clk}}),  .rst({16{rst}}), .D(D), .WriteEnable({16{WriteReg}}), .ReadEnable1({16{ReadEnable1}}), .ReadEnable2({16{ReadEnable2}}), .Bitline1(Bitline1), .Bitline2(Bitline2));

endmodule