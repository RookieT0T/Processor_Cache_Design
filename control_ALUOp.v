module control_ALUOp(opCode, ALUOp);
	input [3:0] opCode;
	output reg [3:0] ALUOp;	// return 4-bit ALUOp code
	
	always@(*) begin
		casex(opCode)
			// ADD
			4'b0000: ALUOp = 4'b0000;
			// SUB
			4'b0001: ALUOp = 4'b0001;
			// XOR
			4'b0010: ALUOp = 4'b0010;
			// RED
			4'b0011: ALUOp = 4'b0011;
			// SLL
			4'b0100: ALUOp = 4'b0100;
			// SRA
			4'b0101: ALUOp = 4'b0101;
			// ROR
			4'b0110: ALUOp = 4'b0110;
			// PADDSB
			4'b0111: ALUOp = 4'b0111;	
			// LW, SW
			4'b100x: ALUOp = 4'b1010;	// do add in ALU
			// LLB
			4'b1010: ALUOp = 4'b1000;	// do concatenation in ALU?
			// LHB
			4'b1011: ALUOp = 4'b1001;	// do concatenation in ALU?
			default: ALUOp = 4'b1100;
		endcase
	end
endmodule