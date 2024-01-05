module ALU(ALU_Out, In1, In2, ALUOp, Flag, Flagin);
    input [15:0] In1, In2;
    input [3:0] ALUOp;
	input [2:0] Flagin;
    output reg [15:0] ALU_Out;
    output wire [2:0] Flag; 
    
    wire [15:0] add_out, xor_out, paddsb_out, sra_out, sll_out, ror_out, lb_out, ls_out, red_out;
    wire ppp, ggg, ovfl; // for CLA_16bit, to be discussed
    wire pp, gg, ov;
    reg Flag_Z; // set when output == 0;
    reg Flag_V; // set when output overflow, add and sub only
    reg Flag_N; // set when output < 0, add and sub only

    wire Mode;
    assign Mode = (ALUOp[0] == 1'b1) ? 1'b1 : 1'b0;  
    wire [15:0] ls_input1 = In1 & 16'hFFFE;
    wire [15:0] ls_input2 = In2 << 1; 

    CLA_16bit adder(.a(In1), .b(In2), .sub(Mode), .sum(add_out), .ppp(ppp), .ggg(ggg),.ovfl(ovfl));

    CLA_16bit lb_adder(.a(ls_input1), .b(ls_input2),.sub(1'b0), .sum(ls_out), .ppp(pp), .ggg(gg), .ovfl(ov));
    XOR i_xor(.out(xor_out), .a(In1), .b(In2) );
    PADDSB paddsb(.a(In1), .b(In2), .sum(paddsb_out));
    SRA sra(.Shift_Out(sra_out), .Shift_Val(In2[3:0]), .Shift_In(In1));  
    SLL sll(.Shift_Out(sll_out), .Shift_Val(In2[3:0]), .Shift_In(In1));  
    ROR ror(.Rot_In(In1), .Rot_Val(In2[3:0]), .Rot_Out(ror_out));
	RED red(.a(In1), .b(In2), .sum(red_out));
    LB lb(.Reg_Val(In1), .Imm(In2[7:0]), .Mode(Mode), .Sum(lb_out)); // Mode: 0 for LLB, 1 for LHB
    	
    always @(ALUOp, In1, In2, sra_out, add_out, xor_out, paddsb_out, sll_out, ror_out, lb_out, ls_out, red_out, Flagin) begin
		Flag_N = Flagin[0];
		Flag_Z = Flagin[2];
		Flag_V = Flagin[1];
        case(ALUOp)
            4'b0000: begin
                ALU_Out = add_out;
                Flag_N = add_out[15];
                Flag_Z = add_out == 16'h0000 ? 1'b1 : 1'b0; 
                Flag_V = ovfl;
            end
            4'b0001: begin
                ALU_Out = add_out;
                Flag_N = add_out[15];
                Flag_Z = add_out == 16'h0000 ? 1'b1 : 1'b0; 
                Flag_V = ovfl;
            end
            4'b0010: begin
                ALU_Out = xor_out;
                Flag_Z = xor_out == 16'h0000 ? 1'b1 : 1'b0; 
            end
            4'b0111: begin
                ALU_Out = paddsb_out;
                Flag_Z = paddsb_out == 16'h0000 ? 1'b1 : 1'b0; 
            end
            4'b0101: begin
                ALU_Out = sra_out;
                Flag_Z = sra_out == 16'h0000 ? 1'b1 : 1'b0; 
            end
            4'b0100: begin
                ALU_Out = sll_out;
                Flag_Z = sll_out == 16'h0000 ? 1'b1 : 1'b0;  
            end
            4'b0110: begin
                ALU_Out = ror_out;
                Flag_Z = ror_out == 16'h0000 ? 1'b1 : 1'b0;  
            end
            // LLB
            4'b1000: begin
                ALU_Out = lb_out;
            end
            // LHB
            4'b1001: begin
                ALU_Out = lb_out;
            end
            // lw, sw
            4'b1010: begin
                ALU_Out = ls_out;
            end
			// red
			4'b0011: begin
                ALU_Out = red_out;
            end
            default: begin
                ALU_Out = 16'h0000;
            end
        endcase
    end
	assign Flag = {Flag_Z, Flag_V, Flag_N};

endmodule