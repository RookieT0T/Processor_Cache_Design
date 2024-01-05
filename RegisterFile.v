module RegisterFile(input clk, input rst, input [3:0] SrcReg1, input [3:0] SrcReg2, input [3:0] DstReg, input WriteReg, input [15:0] DstData, inout [15:0] SrcData1, inout [15:0] SrcData2);
	
	wire [15:0] readWL1, readWL2, writeWL, bitlineR1, bitlineR2;
	wire bypass1, bypass2;

	// 2 source register decoders & 1 destination register
	ReadDecoder_4_16 iReadDecoder1 (.RegId(SrcReg1), .Wordline(readWL1));
	ReadDecoder_4_16 iReadDecoder2 (.RegId(SrcReg2), .Wordline(readWL2));
	WriteDecoder_4_16 iWriteDecoder (.RegId(DstReg), .WriteReg(WriteReg), .Wordline(writeWL));
	
	// 16 registers
	Register reg0 (.clk(clk), .rst(rst), .D(DstData), .WriteReg(1'b0), .ReadEnable1(readWL1[0]), .ReadEnable2(readWL2[0]), .Bitline1(bitlineR1), .Bitline2(bitlineR2));
	Register reg1 (.clk(clk), .rst(rst), .D(DstData), .WriteReg(writeWL[1]), .ReadEnable1(readWL1[1]), .ReadEnable2(readWL2[1]), .Bitline1(bitlineR1), .Bitline2(bitlineR2));
	Register reg2 (.clk(clk), .rst(rst), .D(DstData), .WriteReg(writeWL[2]), .ReadEnable1(readWL1[2]), .ReadEnable2(readWL2[2]), .Bitline1(bitlineR1), .Bitline2(bitlineR2));
	Register reg3 (.clk(clk), .rst(rst), .D(DstData), .WriteReg(writeWL[3]), .ReadEnable1(readWL1[3]), .ReadEnable2(readWL2[3]), .Bitline1(bitlineR1), .Bitline2(bitlineR2));
	
	Register reg4 (.clk(clk), .rst(rst), .D(DstData), .WriteReg(writeWL[4]), .ReadEnable1(readWL1[4]), .ReadEnable2(readWL2[4]), .Bitline1(bitlineR1), .Bitline2(bitlineR2));
	Register reg5 (.clk(clk), .rst(rst), .D(DstData), .WriteReg(writeWL[5]), .ReadEnable1(readWL1[5]), .ReadEnable2(readWL2[5]), .Bitline1(bitlineR1), .Bitline2(bitlineR2));
	Register reg6 (.clk(clk), .rst(rst), .D(DstData), .WriteReg(writeWL[6]), .ReadEnable1(readWL1[6]), .ReadEnable2(readWL2[6]), .Bitline1(bitlineR1), .Bitline2(bitlineR2));
	Register reg7 (.clk(clk), .rst(rst), .D(DstData), .WriteReg(writeWL[7]), .ReadEnable1(readWL1[7]), .ReadEnable2(readWL2[7]), .Bitline1(bitlineR1), .Bitline2(bitlineR2));
	
	Register reg8 (.clk(clk), .rst(rst), .D(DstData), .WriteReg(writeWL[8]), .ReadEnable1(readWL1[8]), .ReadEnable2(readWL2[8]), .Bitline1(bitlineR1), .Bitline2(bitlineR2));
	Register reg9 (.clk(clk), .rst(rst), .D(DstData), .WriteReg(writeWL[9]), .ReadEnable1(readWL1[9]), .ReadEnable2(readWL2[9]), .Bitline1(bitlineR1), .Bitline2(bitlineR2));
	Register reg10 (.clk(clk), .rst(rst), .D(DstData), .WriteReg(writeWL[10]), .ReadEnable1(readWL1[10]), .ReadEnable2(readWL2[10]), .Bitline1(bitlineR1), .Bitline2(bitlineR2));
	Register reg11 (.clk(clk), .rst(rst), .D(DstData), .WriteReg(writeWL[11]), .ReadEnable1(readWL1[11]), .ReadEnable2(readWL2[11]), .Bitline1(bitlineR1), .Bitline2(bitlineR2));
	
	Register reg12 (.clk(clk), .rst(rst), .D(DstData), .WriteReg(writeWL[12]), .ReadEnable1(readWL1[12]), .ReadEnable2(readWL2[12]), .Bitline1(bitlineR1), .Bitline2(bitlineR2));
	Register reg13 (.clk(clk), .rst(rst), .D(DstData), .WriteReg(writeWL[13]), .ReadEnable1(readWL1[13]), .ReadEnable2(readWL2[13]), .Bitline1(bitlineR1), .Bitline2(bitlineR2));
	Register reg14 (.clk(clk), .rst(rst), .D(DstData), .WriteReg(writeWL[14]), .ReadEnable1(readWL1[14]), .ReadEnable2(readWL2[14]), .Bitline1(bitlineR1), .Bitline2(bitlineR2));
	Register reg15 (.clk(clk), .rst(rst), .D(DstData), .WriteReg(writeWL[15]), .ReadEnable1(readWL1[15]), .ReadEnable2(readWL2[15]), .Bitline1(bitlineR1), .Bitline2(bitlineR2));
	
	// bypassing logic
	assign bypass1 = (SrcReg1 == DstReg) & WriteReg;
	assign bypass2 = (SrcReg2 == DstReg) & WriteReg;
	assign SrcData1 = (bypass1) ? DstData : bitlineR1;
	assign SrcData2 = (bypass2) ? DstData : bitlineR2;
	
endmodule