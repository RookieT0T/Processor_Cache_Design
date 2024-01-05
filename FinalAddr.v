module FinalAddr(
    input Branch,
    input [2:0] Flag,
    input [2:0] ccc,
    input BranchReg,
    input [15:0] ID_EX_Rs,
    input [15:0] pcplus2, // in IF/ID stage
    input [15:0] immediate,
    output [15:0] FinalAddr
);
    wire taken;

	BranchMux  iBranchMux(.branch(Branch), .ccc(ccc), .Flag(Flag), .branch_out(taken));
	wire pp,gg,ov;
	wire [15:0] targetaddr;
	// pcplus2 = curAddr + 2;
	// CLA_16bit branchadder1(.a(16'h0002), .b(curAddr), .sum(pcplus2), .sub(1'b0), .ppp(ppp), .ggg(ggg), .ovfl(ovfl));
	// targetaddr  = pcplus2 + immediate << 1;
	CLA_16bit branchadder2(.a(pcplus2), .b(immediate << 1), .sum(targetaddr), .sub(1'b0), .ppp(pp), .ggg(gg), .ovfl(ov));
	
	// New address of PC
	assign FinalAddr = taken ? (BranchReg ? ID_EX_Rs : targetaddr) : pcplus2;


endmodule