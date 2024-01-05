module control (opCode, ALUOp, Branch, BranchReg, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, HALT, PCS, readReg, SW);
	input [3:0] opCode;
	output [3:0] ALUOp;
	output reg Branch;
	output reg BranchReg;
	output reg MemRead;
	output reg MemtoReg;
	output reg MemWrite;
	output reg ALUSrc;
	output reg RegWrite;
	output reg HALT;
	output reg PCS;
	output reg readReg;
	output reg SW;
	
	// determine ALUOp for ALU part
	control_ALUOp iALUOp (.opCode(opCode), .ALUOp(ALUOp));
	
	// determine other control signals
	always@(*) begin
		casex(opCode)
			// ADD, SUB, XOR, RED  
			4'b00xx: begin
					Branch = 1'b0;
					BranchReg = 1'b0;
					MemRead = 1'b0;
					MemtoReg = 1'b0;
					MemWrite = 1'b0;
					ALUSrc = 1'b0;
					RegWrite = 1'b1;
					HALT = 1'b0;
					PCS = 1'b0;
					readReg = 1'b0;
					SW = 1'b0;
					end
			// SLL
			4'b0100: begin
					Branch = 1'b0;
					BranchReg = 1'b0;
					MemRead = 1'b0;
					MemtoReg = 1'b0;
					MemWrite = 1'b0;
					ALUSrc = 1'b1;
					RegWrite = 1'b1;
					HALT = 1'b0;
					PCS = 1'b0;
					readReg = 1'b0;
					SW = 1'b0;
					end
			// SRA
			4'b0101: begin
					Branch = 1'b0;
					BranchReg = 1'b0;
					MemRead = 1'b0;
					MemtoReg = 1'b0;
					MemWrite = 1'b0;
					ALUSrc = 1'b1;
					RegWrite = 1'b1;
					HALT = 1'b0;
					PCS = 1'b0;
					readReg = 1'b0;
					SW = 1'b0;
					end
			// ROR
			4'b0110: begin
					Branch = 1'b0;
					BranchReg = 1'b0;
					MemRead = 1'b0;
					MemtoReg = 1'b0;
					MemWrite = 1'b0;
					ALUSrc = 1'b1;
					RegWrite = 1'b1;
					HALT = 1'b0;
					PCS = 1'b0;
					readReg = 1'b0;
					SW = 1'b0;
					end
			// PADDSB
			4'b0111: begin
					Branch = 1'b0;
					BranchReg = 1'b0;
					MemRead = 1'b0;
					MemtoReg = 1'b0;
					MemWrite = 1'b0;
					ALUSrc = 1'b0;
					RegWrite = 1'b1;
					HALT = 1'b0;
					PCS = 1'b0;
					readReg = 1'b0;
					SW = 1'b0;
					end
			// LW
			4'b1000: begin
					Branch = 1'b0;
					BranchReg = 1'b0;
					MemRead = 1'b1;
					MemtoReg = 1'b1;
					MemWrite = 1'b0;
					ALUSrc = 1'b1;
					RegWrite = 1'b1;
					HALT = 1'b0;
					PCS = 1'b0;
					readReg = 1'b0;
					SW = 1'b0;
					end
			// SW
			4'b1001: begin
					Branch = 1'b0;
					BranchReg = 1'b0;
					MemRead = 1'b0;
					MemtoReg = 1'b0;
					MemWrite = 1'b1;
					ALUSrc = 1'b1;
					RegWrite = 1'b0;
					HALT = 1'b0;
					PCS = 1'b0;
					readReg = 1'b0;
					SW = 1'b1;
					end
			// LLB, LHB
			4'b101x: begin
					Branch = 1'b0;
					BranchReg = 1'b0;
					MemRead = 1'b0;
					MemtoReg = 1'b0;
					MemWrite = 1'b0;
					ALUSrc = 1'b1;
					RegWrite = 1'b1;
					HALT = 1'b0;
					PCS = 1'b0;
					readReg = 1'b1;
					SW = 1'b0;
					end
			// B
			4'b1100: begin
					Branch = 1'b1;
					BranchReg = 1'b0;
					MemRead = 1'b0;
					MemtoReg = 1'b0;
					MemWrite = 1'b0;
					ALUSrc = 1'b0;
					RegWrite = 1'b0;
					HALT = 1'b0;
					PCS = 1'b0;
					readReg = 1'b0;
					SW = 1'b0;
					end
			// BR
			4'b1101: begin
					Branch = 1'b1;
					BranchReg = 1'b1;
					MemRead = 1'b0;
					MemtoReg = 1'b0;
					MemWrite = 1'b0;
					ALUSrc = 1'b0;
					RegWrite = 1'b0;
					HALT = 1'b0;
					PCS = 1'b0;
					readReg = 1'b0;
					SW = 1'b0;
					end
			// PCS
			4'b1110: begin
					Branch = 1'b0;
					BranchReg = 1'b0;
					MemRead = 1'b0;
					MemtoReg = 1'b0;
					MemWrite = 1'b0;
					ALUSrc = 1'b0;
					RegWrite = 1'b1;
					HALT = 1'b0;
					PCS = 1'b1;
					readReg = 1'b0;
					SW = 1'b0;
					end
			// HALT
			4'b1111: begin
					Branch = 1'b0;
					BranchReg = 1'b0;
					MemRead = 1'b0;
					MemtoReg = 1'b0;
					MemWrite = 1'b0;
					ALUSrc = 1'b0;
					RegWrite = 1'b0;
					HALT = 1'b1;
					PCS = 1'b0;
					readReg = 1'b0;
					SW = 1'b0;
					end
			default: begin
					Branch = 1'b0;
					BranchReg = 1'b0;
					MemRead = 1'b0;
					MemtoReg = 1'b0;
					MemWrite = 1'b0;
					ALUSrc = 1'b0;
					RegWrite = 1'b0;
					HALT = 1'b0;
					PCS = 1'b0;
					readReg = 1'b0;
					SW = 1'b0;
					end
		endcase
	end
endmodule