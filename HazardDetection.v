module HazardDetection(
    input ID_EX_MemRead,
    input [3:0] ID_EX_Rt,
    input [3:0] IF_ID_Rs,
    input [3:0] IF_ID_Rt,
	input IF_ID_MemWrite,
    output PC_Write,
    output IF_ID_Write,
    output set_ctrl_zero
);
    wire temp, mm;
    // 1 = stall
    //assign temp = ID_EX_MemRead ? ( (ID_EX_Rt == IF_ID_Rs || ID_EX_Rt == IF_ID_Rt) ? 1 : 0) : 0;
	 
	// Mem to Mem condition of not incurring a stall
	assign mm = IF_ID_MemWrite & (ID_EX_Rt == IF_ID_Rt) & (ID_EX_Rt != IF_ID_Rs);
    assign temp = ID_EX_MemRead & (ID_EX_Rt != 4'h0) & (ID_EX_Rt == IF_ID_Rs | ID_EX_Rt == IF_ID_Rt) & ~mm;
	
	assign PC_Write = temp;
    assign IF_ID_Write = temp;
    assign set_ctrl_zero = temp;
endmodule