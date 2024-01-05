module SLL (Shift_Out, Shift_In, Shift_Val);
input [15:0] Shift_In; // This is the input data to perform shift operation on
input [3:0] Shift_Val; // Shift amount (used to shift the input data)
output reg [15:0] Shift_Out; // Shifted output data

reg [5:0] amt;
reg [15:0] out_int;


always @(*) begin 

	case(Shift_Val)
		4'h0	: amt = 6'b000000;
		4'h1	: amt = 6'b000001;
		4'h2	: amt = 6'b000010;
		4'h3	: amt = 6'b000100;
		4'h4	: amt = 6'b000101;
		4'h5	: amt = 6'b000110;
		4'h6	: amt = 6'b001000;
		4'h7	: amt = 6'b001001;
		4'h8	: amt = 6'b001010;
		4'h9	: amt = 6'b010000;
		4'hA	: amt = 6'b010001;
		4'hB	: amt = 6'b010010;
		4'hC	: amt = 6'b010100;
		4'hD	: amt = 6'b010101;
		4'hE	: amt = 6'b010110;
		4'hF	: amt = 6'b011000;
		default : amt = 6'hxx;
	endcase
	
	case(amt[1:0])
		2'b00	: out_int = Shift_In;
		2'b01	: out_int = {Shift_In[14:0],1'b0};
		2'b10	: out_int = {Shift_In[13:0],2'b00};
		default	: out_int = 16'hxxxx;
	endcase
	
	case(amt[3:2])
		2'b00	: out_int = out_int;
		2'b01	: out_int = {out_int[12:0],3'b000};
		2'b10	: out_int = {out_int[9:0],6'b000000};
		default	: out_int = 16'hxxxx;
	endcase
	
	case(amt[5:4])
		2'b00	: out_int = out_int;
		2'b01	: out_int = {out_int[6:0],9'b000000000};
		default	: out_int = 16'hxxxx;
	endcase
	
	Shift_Out = out_int;
end 
endmodule
