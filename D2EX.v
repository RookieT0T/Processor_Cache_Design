module D2EX(ALUSrc, ALUOp, readData1, readData2, Immediate, Rs, Rt, MemRead, MemWrite, RegWrite, MemtoReg, PCS, HALT, clk, rst_n, Rd, PC_Inc, ALUSrc_Out, ALUOp_Out, readData1_Out, readData2_Out, Immediate_Out, Rs_Out, Rt_Out, MemRead_Out, MemWrite_Out, RegWrite_Out, MemtoReg_Out, PCS_Out, HALT_Out, Rd_Out, PC_Inc_Out, wen);
	
	// control input
	input ALUSrc;
	input [3:0] ALUOp;
	input MemRead;
	input MemWrite;
	input RegWrite;
	input MemtoReg;
	input PCS;
	input HALT;
	
	// data input
	input [15:0] readData1;
	input [15:0] readData2;
	input [15:0] Immediate;
	input [3:0] Rs;
	input [3:0] Rt;
	input [3:0] Rd;
	input [15:0] PC_Inc;
	
	// default input
	input clk;
	input rst_n;
	input wen;
	
	// control output
	output ALUSrc_Out;
	output [3:0] ALUOp_Out;
	output MemRead_Out;
	output MemWrite_Out;
	output RegWrite_Out;
	output MemtoReg_Out;
	output PCS_Out;
	output HALT_Out;

	// data output
	output [15:0] readData1_Out;
	output [15:0] readData2_Out;
	output [15:0] Immediate_Out;
	output [3:0] Rs_Out;
	output [3:0] Rt_Out;
	output [3:0] Rd_Out;
	output [15:0] PC_Inc_Out;
	
	// Instantiation
	dff iFF_ALUSrc(.q(ALUSrc_Out), .d(ALUSrc), .wen(wen), .clk(clk), .rst(rst_n));
	dff iFF_ALUOp[3:0](.q(ALUOp_Out), .d(ALUOp), .wen({4{wen}}), .clk({4{clk}}), .rst({4{rst_n}}));
	dff iFF_MemRead(.q(MemRead_Out), .d(MemRead), .wen(wen), .clk(clk), .rst(rst_n));
	dff iFF_MemWrite(.q(MemWrite_Out), .d(MemWrite), .wen(wen), .clk(clk), .rst(rst_n));
	dff iFF_RegWrite(.q(RegWrite_Out), .d(RegWrite), .wen(wen), .clk(clk), .rst(rst_n));
	dff iFF_MemtoReg(.q(MemtoReg_Out), .d(MemtoReg), .wen(wen), .clk(clk), .rst(rst_n));
	dff iFF_PCS(.q(PCS_Out), .d(PCS), .wen(wen), .clk(clk), .rst(rst_n));
	dff iFF_HALT(.q(HALT_Out), .d(HALT), .wen(wen), .clk(clk), .rst(rst_n));
	dff iFF_readData1[15:0](.q(readData1_Out), .d(readData1), .wen({16{wen}}), .clk({16{clk}}), .rst({16{rst_n}}));
	dff iFF_readData2[15:0](.q(readData2_Out), .d(readData2), .wen({16{wen}}), .clk({16{clk}}), .rst({16{rst_n}}));
	dff iFF_Immediate[15:0](.q(Immediate_Out), .d(Immediate), .wen({16{wen}}), .clk({16{clk}}), .rst({16{rst_n}}));
	dff iFF_Rs[3:0](.q(Rs_Out), .d(Rs), .wen({4{wen}}), .clk({4{clk}}), .rst({4{rst_n}}));
	dff iFF_Rt[3:0](.q(Rt_Out), .d(Rt), .wen({4{wen}}), .clk({4{clk}}), .rst({4{rst_n}}));
	dff iFF_Rd[3:0](.q(Rd_Out), .d(Rd), .wen({4{wen}}), .clk({4{clk}}), .rst({4{rst_n}}));
	dff iFF_PC_Inc[15:0](.q(PC_Inc_Out), .d(PC_Inc), .wen({16{wen}}), .clk({16{clk}}), .rst({16{rst_n}}));
	
endmodule