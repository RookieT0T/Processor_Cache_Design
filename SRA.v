module SRA (Shift_Out, Shift_In, Shift_Val);
input [15:0] Shift_In; // This is the input data to perform shift operation on
input [3:0] Shift_Val; // Shift amount (used to shift the input data)
output reg [15:0] Shift_Out; // Shifted output data

reg [5:0] amt;
reg [15:0] out_int, out_int2;

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
		2'b01	: out_int = {Shift_In[15],Shift_In[15:1]};
		2'b10	: out_int = {{2{Shift_In[15]}},Shift_In[15:2]};
		default	: out_int = 16'hxxxx;
	endcase
	
	case(amt[3:2])
		2'b00	: out_int2 = out_int;
		2'b01	: out_int2 = {{3{out_int[15]}},out_int[15:3]};
		2'b10	: out_int2 = {{6{out_int[15]}},out_int[15:6]};
		default	: out_int2 = 16'hxxxx;
	endcase
	
	case(amt[5:4])
		2'b00	: Shift_Out = out_int2;
		2'b01	: Shift_Out = {{9{out_int2[15]}},out_int2[15:9]};
		default	: Shift_Out = 16'hxxxx;
	endcase
	
end 
endmodule
