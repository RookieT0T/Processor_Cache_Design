module wordEnable(offset, wordEnable);
	input [2:0] offset;
	output reg [7:0] wordEnable;
	
	always @(offset) begin
		case (offset)
			3'b000: wordEnable = 8'b00000001;
			3'b001: wordEnable = 8'b00000010;
			3'b010: wordEnable = 8'b00000100;
			3'b011: wordEnable = 8'b00001000;
			3'b100: wordEnable = 8'b00010000;
			3'b101: wordEnable = 8'b00100000;
			3'b110: wordEnable = 8'b01000000;
			3'b111: wordEnable = 8'b10000000;
			default: wordEnable = 8'h00;
		endcase
	end
	
endmodule