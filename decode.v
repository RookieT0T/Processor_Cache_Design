module decode(clk, rst, instruction, writeData, ALUOp, Branch, BranchReg, MemRead, MemtoReg, MemWrite, ALUSrc, HALT, PCS, immediate, BranchCCC, readData1, readData2);

	input clk, rst;
	input [15:0] instruction;
	input [15:0] writeData;
	
	output [3:0] ALUOp;
	output Branch;
	output BranchReg;
	output MemRead;
	output MemtoReg;
	output MemWrite;
	output ALUSrc;
	output HALT;
	output PCS;
	output [15:0] immediate;
	output [2:0] BranchCCC;
	inout [15:0] readData1, readData2;
	
	wire readReg; // signal indicating LLB & LHB
	wire SW;	  // signal indicating SW
	wire writeToReg;
	wire [3:0] Opcode, Rd, Rt, Rs, tempoRs, tempoRt;
	
	assign Opcode = instruction[15:12];
	assign Rd = instruction[11:8];
	assign tempoRt = instruction[3:0];
	assign tempoRs = instruction[7:4];
	
	assign BranchCCC = instruction[11:9];
	
	// determine Rs
	assign Rs = (readReg) ? Rd : tempoRs;
	
	// determine Rt
	assign Rt = (SW) ? Rd : tempoRt;
	
	// determine immediate
	Sign_extend iSignExtend (.instruction(instruction), .sign_extended(immediate));
	
	// determine control signals
	control iControl(.opCode(Opcode), .ALUOp(ALUOp), .Branch(Branch), .BranchReg(BranchReg), .MemRead(MemRead), .MemtoReg(MemtoReg), .MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(writeToReg), .HALT(HALT), .PCS(PCS), .readReg(readReg), .SW(SW));
	
	// determine readData1 & readData2 from the register file
	RegisterFile iRegisterFile(.clk(clk), .rst(rst), .SrcReg1(Rs), .SrcReg2(Rt), .DstReg(Rd), .WriteReg(writeToReg), .DstData(writeData), .SrcData1(readData1), .SrcData2(readData2));

endmodule