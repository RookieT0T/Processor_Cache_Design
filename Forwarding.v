module Forwarding(EX_MEM_RegWrite, EX_MEM_WriteRegister, ID_EX_Rs, ID_EX_Rt, XtoX_A, XtoX_B, MEM_WB_RegWrite, MEM_WB_WriteRegister, MtoX_A, MtoX_B, EX_MEM_MemWrite, EX_MEM_Rt, MtoM);
	input EX_MEM_RegWrite;
	input [3:0] EX_MEM_WriteRegister;
	input [3:0] ID_EX_Rs;
	input [3:0] ID_EX_Rt;
	output XtoX_A;
	output XtoX_B;
	
	input MEM_WB_RegWrite;
	input [3:0] MEM_WB_WriteRegister;
	output MtoX_A;
	output MtoX_B;
	
	input EX_MEM_MemWrite;
	input [3:0] EX_MEM_Rt;
	output MtoM;
	
	// EX to EX
	wire temp1;
	wire temp2;
	assign temp1 = (EX_MEM_RegWrite == 1'b1) & (EX_MEM_WriteRegister != 4'h0) & (ID_EX_Rs == EX_MEM_WriteRegister);
	assign temp2 = (EX_MEM_RegWrite == 1'b1) & (EX_MEM_WriteRegister != 4'h0) & (ID_EX_Rt == EX_MEM_WriteRegister);
	assign XtoX_A = temp1;
	assign XtoX_B = temp2;
	
	// MEM to EX
	assign MtoX_A = (MEM_WB_RegWrite == 1'b1) & (MEM_WB_WriteRegister != 4'h0) & (MEM_WB_WriteRegister == ID_EX_Rs) & ~temp1;	// if else logic
	assign MtoX_B = (MEM_WB_RegWrite == 1'b1) & (MEM_WB_WriteRegister != 4'h0) & (MEM_WB_WriteRegister == ID_EX_Rt) & ~temp2;	// if else logic

	// MEM to MEM
	assign MtoM = (MEM_WB_RegWrite == 1'b1) & (MEM_WB_WriteRegister != 4'h0) & (MEM_WB_WriteRegister == EX_MEM_Rt) & (EX_MEM_MemWrite == 1'b1);
	
endmodule