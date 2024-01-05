module LB(Sum,Reg_Val,Imm,Mode);
input Mode; // 1'b0 for LLB, 1'b1 for LHB
input [7:0] Imm;
input [15:0] Reg_Val;
output [15:0] Sum;

localparam L_Imm = 16'hFF00;
localparam H_Imm = 16'h00FF;

assign Sum = (Mode) ? ((Reg_Val & H_Imm) | (Imm << 8))	: ((Reg_Val & L_Imm) | Imm);
endmodule