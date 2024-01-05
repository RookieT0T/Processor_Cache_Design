module EX2M(MemRead, MemWrite, RegWrite, MemtoReg, PCS, HALT, clk, rst_n, ALU_Out, Rt, Rd, PC_Inc, MemRead_Out, MemWrite_Out, RegWrite_Out, MemtoReg_Out, PCS_Out, HALT_Out, ALU_Out_Out, Rt_Out, Rd_Out, PC_Inc_Out, dataRt, dataRt_Out, wen);

	// control input
	input MemRead;
	input MemWrite;
	input RegWrite;
	input MemtoReg;
	input PCS;
	input HALT;
	
	// data input
	input [15:0] ALU_Out;
	input [3:0] Rt;
	input [3:0] Rd;
	input [15:0] PC_Inc;
	input [15:0] dataRt;
	
	// default input
	input clk;
	input rst_n;
	input wen;
	
	// control output
	output MemRead_Out;
	output MemWrite_Out;
	output RegWrite_Out;
	output MemtoReg_Out;
	output PCS_Out;
	output HALT_Out;
	
	// data output
	output [15:0] ALU_Out_Out;
	output [3:0] Rt_Out;
	output [3:0] Rd_Out;
	output [15:0] PC_Inc_Out;
	output [15:0] dataRt_Out;
	
	// Instantiation
	dff iFF_MemRead(.q(MemRead_Out), .d(MemRead), .wen(wen), .clk(clk), .rst(rst_n));
	dff iFF_MemWrite(.q(MemWrite_Out), .d(MemWrite), .wen(wen), .clk(clk), .rst(rst_n));
	dff iFF_RegWrite(.q(RegWrite_Out), .d(RegWrite), .wen(wen), .clk(clk), .rst(rst_n));
	dff iFF_MemtoReg(.q(MemtoReg_Out), .d(MemtoReg), .wen(wen), .clk(clk), .rst(rst_n));
	dff iFF_PCS(.q(PCS_Out), .d(PCS), .wen(wen), .clk(clk), .rst(rst_n));
	dff iFF_HALT(.q(HALT_Out), .d(HALT), .wen(wen), .clk(clk), .rst(rst_n));
	
	dff iFF_ALU_Out[15:0](.q(ALU_Out_Out), .d(ALU_Out), .wen({16{wen}}), .clk({16{clk}}), .rst({16{rst_n}}));
	dff iFF_Rt[3:0](.q(Rt_Out), .d(Rt), .wen({4{wen}}), .clk({4{clk}}), .rst({4{rst_n}}));
	dff iFF_Rd[3:0](.q(Rd_Out), .d(Rd), .wen({4{wen}}), .clk({4{clk}}), .rst({4{rst_n}}));
	dff iFF_PC_Inc[15:0](.q(PC_Inc_Out), .d(PC_Inc), .wen({16{wen}}), .clk({16{clk}}), .rst({16{rst_n}}));
	dff iFF_dataRt[15:0](.q(dataRt_Out), .d(dataRt), .wen({16{wen}}), .clk({16{clk}}), .rst({16{rst_n}}));
endmodule