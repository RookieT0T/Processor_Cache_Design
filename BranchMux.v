module BranchMux(
    input wire branch,
    input wire [2:0] ccc,
    input [2:0] Flag,
    output wire branch_out
);
    reg temp;

    // Flag[2] = Z Flag[1] = V Flag[0] = N 
    always @(ccc, Flag) begin
        case (ccc)
            3'b000: temp = ~Flag[2];
            3'b001: temp = Flag[2];
            3'b010: temp = ~(Flag[2] | Flag[0]);
            3'b011: temp = Flag[0];
            3'b100: temp = Flag[2] || (Flag[2] == 0 && Flag[0] == 0);
            3'b101: temp = Flag[2] || Flag[0];
            3'b110: temp = Flag[1];
            default: temp = 1;
        endcase
    end

    assign branch_out = temp & branch;
endmodule
