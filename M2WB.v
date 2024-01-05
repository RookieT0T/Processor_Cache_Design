module M2WB (RegWrite, MemtoReg, PCS, HALT, clk, rst_n, ALU_Out, DataMem, Rd, PC_Inc, RegWrite_Out, MemtoReg_Out, PCS_Out, HALT_Out, ALU_Out_Out, DataMem_Out, Rd_Out, PC_Inc_Out, wen);
	// control input
	input RegWrite,MemtoReg,PCS,HALT;
	// data input
	input [15:0] ALU_Out,DataMem,PC_Inc;
	input [3:0] Rd;
	// default input
	input clk,rst_n;
	input wen;
	// control output
	output RegWrite_Out,MemtoReg_Out,PCS_Out,HALT_Out;
	// data output
	output [15:0] ALU_Out_Out,DataMem_Out,PC_Inc_Out;
	output [3:0] Rd_Out;

	// Instantiation
	dff iFF_RegWrite(.q(RegWrite_Out), .d(RegWrite), .wen(wen), .clk(clk), .rst(rst_n));
	dff iFF_MemtoReg(.q(MemtoReg_Out), .d(MemtoReg), .wen(wen), .clk(clk), .rst(rst_n));
	dff iFF_PCS(.q(PCS_Out), .d(PCS), .wen(wen), .clk(clk), .rst(rst_n));
	dff iFF_HALT(.q(HALT_Out), .d(HALT), .wen(wen), .clk(clk), .rst(rst_n));
	dff iFF_ALU_Out[15:0](.q(ALU_Out_Out), .d(ALU_Out), .wen({16{wen}}), .clk({16{clk}}), .rst({16{rst_n}}));
	dff iFF_DataMem[15:0](.q(DataMem_Out), .d(DataMem), .wen({16{wen}}), .clk({16{clk}}), .rst({16{rst_n}}));
	dff iFF_Rd[3:0](.q(Rd_Out), .d(Rd), .wen({4{wen}}), .clk({4{clk}}), .rst({4{rst_n}}));
	dff iFF_PC_Inc[15:0](.q(PC_Inc_Out), .d(PC_Inc), .wen({16{wen}}), .clk({16{clk}}), .rst({16{rst_n}}));

endmodule