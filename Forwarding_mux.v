module Forwarding_mux(XtoX_A, XtoX_B, MtoX_A, MtoX_B, ID_EX_Rs, ID_EX_Rt, EX_MEM_ALUOut, MEM_WB_WriteData, ALUin1, ALUin2, ALUSrc, immediate, dataRt);
	input XtoX_A;
	input XtoX_B;
	input MtoX_A;
	input MtoX_B;
	
	input [15:0] ID_EX_Rs;
	input [15:0] ID_EX_Rt;
	input [15:0] EX_MEM_ALUOut;
	input [15:0] MEM_WB_WriteData;
	
	input ALUSrc;
	input [15:0] immediate;
	output [15:0] ALUin1;
	output [15:0] ALUin2;
	output [15:0] dataRt;
	
	assign ALUin1 = XtoX_A ? EX_MEM_ALUOut : MtoX_A ? MEM_WB_WriteData : ID_EX_Rs;
	
	wire [15:0] temp;
	assign temp = XtoX_B ? EX_MEM_ALUOut : MtoX_B ? MEM_WB_WriteData : ID_EX_Rt;
	assign dataRt = temp;
	assign ALUin2 = ALUSrc ? immediate : temp;
	
endmodule