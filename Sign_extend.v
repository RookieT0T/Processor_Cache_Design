module Sign_extend(instruction, sign_extended);
	input [15:0] instruction;
	output reg [15:0] sign_extended;
	
	// output of sign extended block for each type of instruction
	wire [15:0] computeIns, memoryIns1, memoryIns2, controlIns;
	
	// zero extended for unsigned immediate in compute instruction
	assign computeIns = {{12{1'b0}}, instruction[3:0]};
	
	// sign extended for signed immediate in memory instruction
	assign memoryIns1 = {{12{instruction[3]}}, instruction[3:0]};
	assign memoryIns2 = {{8{instruction[7]}}, instruction[7:0]};
	
	// sign extended for signed immediate in control instruction
	assign controlIns = {{7{instruction[8]}}, instruction[8:0]};
	
	always @(*) begin
		casex(instruction[15:12])
			4'b0xxx: sign_extended = computeIns;
			4'b11xx: sign_extended = controlIns;
			4'b100x: sign_extended = memoryIns1;
			4'b101x: sign_extended = memoryIns2;
			default: sign_extended = 16'h0000;
		endcase
	end
endmodule