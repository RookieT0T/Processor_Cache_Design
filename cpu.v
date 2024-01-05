module cpu(clk, rst_n, hlt, pc);
	input clk;
	input rst_n;
	output hlt;
	output [15:0] pc;
	
	// wires in IF/ID, some of them in EX/MEM and MEM/WB
	wire ppp, ggg, ovfl;
	wire [15:0] pcplus2, pcplus2_IF2D, pcplus2_EX2M, pcplus2_M2WB;
	wire [15:0] newAddr; 			// new address of PC
	wire [15:0] curAddr;			// current address of PC
	wire wen, haltNotBranch;
	wire [15:0] instruction;
	wire [15:0] instruction_Stall, instruction_IF2D;
	wire IF_ID_Wen;
	
	// wires in ID/EX, some of them in EX/MEM and MEM/WB
	wire set_ctrl_zero, PC_Write, IF_ID_Write;
	wire [3:0] Opcode, Rd, Rt, Rs, tempoRs, tempoRt, Rs_D2EX, Rt_D2EX, Rt_EX2M, Rd_D2EX, Rd_EX2M, Rd_M2WB;
	wire [2:0] BranchCCC;
	wire readReg; 					// signal indicating LLB & LHB
	wire SW;	  					// signal indicating SW
	wire writeToReg, writeToRegD, writeToReg_D2EX, writeToReg_EX2M, writeToReg_M2WB;
	wire [3:0] ALUOp, ALUOp_D2EX;
	wire Branch;
	wire BranchReg;
	wire MemRead, MemRead_D2EX, MemRead_EX2M;
	wire MemtoReg, MemtoReg_D2EX, MemtoReg_EX2M, MemtoReg_M2WB;
	wire MemWrite, MemWrite_D2EX, MemWrite_EX2M;
	wire ALUSrc, ALUSrc_D2EX;
	wire HALT, HALT_D2EX, HALT_EX2M, HALT_M2WB;
	wire PCS, PCS_D2EX, PCS_EX2M, PCS_M2WB;
	wire pp,gg,ov;
	wire BranchFinal;
	wire [15:0] targetaddr, newAddr_D2EX;
	wire [15:0] readData1, readData2, readData1_D2EX, readData2_D2EX;
	wire [15:0] immediate, immediate_D2EX;
	wire [15:0] pcplus2_D2EX;
	wire [11:0] control_line;
	
	// wires in EX/MEM, some of them in MEM/WB
	wire flagRegEn;
	wire XtoX_A, XtoX_B;
	wire MtoX_A, MtoX_B;
	wire MtoM;
	wire [15:0] ALUin1, ALUin2, dataRt, dataRt_EX2M;
	wire [2:0] Flag, flag_out;
	wire [15:0] ALU_Out, ALU_Out_EX2M, ALU_Out_M2WB;
	
	// wires in MEM/WB
	wire [15:0] dataMemOut, dataMemIn, dataMemOut_M2WB;
	// wire enable;
	
	// wires in WB
	wire [15:0] writeData;
	
	// wires in cache interface
	wire insStall, memStall, cacheStall;
	
	// +++++++++++++++++++++++++++++++++ Cache Interface +++++++++++++++++++++++++++++++++++++++++++
	assign cacheStall = ~memStall;
	cacheAccess iCA(.clk(clk), .rst(~rst_n), .memAddress(ALU_Out_EX2M), .insAddress(curAddr), .memDataIn(dataMemIn), .memDataOut(dataMemOut), .insDataOut(instruction), 
					.memWrite(MemWrite_EX2M), .memRead(MemRead_EX2M), .insStall(insStall), .memStall(memStall));
					
	// +++++++++++++++++++++++++++++++++ Cache Interface +++++++++++++++++++++++++++++++++++++++++++				
					
					
	
	// ++++++++++++++++++++++++++++++++++++++++ IF/ID ++++++++++++++++++++++++++++++++++++++++++++++
	
	// PC + 2
	CLA_16bit branchadder1(.a(16'h0002), .b(curAddr), .sum(pcplus2), .sub(1'b0), .ppp(ppp), .ggg(ggg), .ovfl(ovfl));
	
	// MUX selecting input address to PC Reg
	assign newAddr = (BranchFinal) ? newAddr_D2EX : pcplus2;

	// PC Register
	assign haltNotBranch = (instruction_Stall[15:12] == 4'b1111 & BranchFinal == 1'b0);		// halt is fetched but branch is not taken in decide stage, disable PC to stop fetching more instructions
	assign wen = ~(haltNotBranch | PC_Write | insStall | memStall);
	PCRegister iPCReg(.clk(clk), .rst(~rst_n), .wen(wen), .newAddr(newAddr), .curAddr(curAddr));
	
	// Instruction Memory
	// memory_ins insMemory(.data_out(instruction), .data_in(16'h0000), .addr(curAddr), .enable(1'b1), .wr(1'b0), .clk(clk), .rst(~rst_n));
	
	// IF/ID Register
	assign instruction_Stall = (BranchFinal | insStall) ? 16'hA000 : instruction; 						// Insert NOP, but disable writeToReg later in ID/EX
	assign IF_ID_Wen = ~IF_ID_Write & ~memStall;
	IF2ID iIF2D(.clk(clk), .rst_n(~rst_n), .Instr(instruction_Stall), .PC_Inc(pcplus2), .Instr_Out(instruction_IF2D), .PC_Inc_Out(pcplus2_IF2D), .wen(IF_ID_Wen));
	
	// ++++++++++++++++++++++++++++++++++++++++ IF/ID ++++++++++++++++++++++++++++++++++++++++++++++
	
	
	
	// ++++++++++++++++++++++++++++++++++++++++ ID/EX ++++++++++++++++++++++++++++++++++++++++++++++
	
	// Hazard detection unit
	HazardDetection iHazardD(.ID_EX_MemRead(MemRead_D2EX), .ID_EX_Rt(Rt_D2EX), .IF_ID_Rs(Rs), .IF_ID_Rt(Rt), .IF_ID_MemWrite(MemWrite), .PC_Write(PC_Write), .IF_ID_Write(IF_ID_Write), .set_ctrl_zero(set_ctrl_zero));

	// Decode into control signals
	assign Opcode = instruction_IF2D[15:12];
	assign Rd = instruction_IF2D[11:8];
	assign tempoRt = instruction_IF2D[3:0];
	assign tempoRs = instruction_IF2D[7:4];
	assign BranchCCC = instruction_IF2D[11:9];
	assign Rs = (readReg) ? Rd : tempoRs;
	assign Rt = (SW | MemRead) ? Rd : tempoRt; // set lw rt = rd (for correction of hazard detection)
	control iControl(.opCode(Opcode), .ALUOp(ALUOp), .Branch(Branch), .BranchReg(BranchReg), .MemRead(MemRead), .MemtoReg(MemtoReg), .MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(writeToReg), .HALT(HALT), .PCS(PCS), .readReg(readReg), .SW(SW));
	
	
	// Branch forwarding
	wire bForward;
	wire [2:0]FlagFinal;
	branchForwarding ibForwarding(.aluOpcode(ALUOp_D2EX), .branch(Branch), .forwarding(bForward));
	assign FlagFinal = bForward ? Flag : flag_out;
	
	// New address of PC
	CLA_16bit branchadder2(.a(pcplus2_IF2D), .b(immediate << 1), .sum(targetaddr), .sub(1'b0), .ppp(pp), .ggg(gg), .ovfl(ov)); 	// target address of branch
	BranchMux iBranchMux(.branch(Branch), .ccc(BranchCCC), .Flag(FlagFinal), .branch_out(BranchFinal));
	assign newAddr_D2EX = BranchFinal ? (BranchReg ? readData1 : targetaddr) : pcplus2_IF2D;	// newAddr_D2EX will be passed to PC in IF/ID
	
	// Register file
	RegisterFile iRegisterFile(.clk(clk), .rst(~rst_n), .SrcReg1(Rs), .SrcReg2(Rt), .DstReg(Rd_M2WB), .WriteReg(writeToReg_M2WB), .DstData(writeData), .SrcData1(readData1), .SrcData2(readData2));
	
	// Immediate
	Sign_extend iSignExtend (.instruction(instruction_IF2D), .sign_extended(immediate));
	
	// Mux of control signals
	assign writeToRegD = (Rd == 4'h0) ? 1'b0 : writeToReg;	// deassert writeToReg when pipeline registers are reset
	assign control_line = (set_ctrl_zero) ? 12'h8000 : {ALUOp,ALUSrc,MemRead,MemWrite,writeToRegD,MemtoReg,PCS,HALT,1'b0};
	
	// ID/EX Register
	D2EX iD2EX(.ALUSrc(control_line[7]), .ALUOp(control_line[11:8]), .readData1(readData1), .readData2(readData2), .Immediate(immediate), .Rs(Rs), .Rt(Rt), .MemRead(control_line[6]), .MemWrite(control_line[5]), 
				.RegWrite(control_line[4]), .MemtoReg(control_line[3]), .PCS(control_line[2]), .HALT(control_line[1]), .clk(clk), .rst_n(~rst_n), .Rd(Rd), .PC_Inc(pcplus2_IF2D), .ALUSrc_Out(ALUSrc_D2EX), 
				.ALUOp_Out(ALUOp_D2EX), .readData1_Out(readData1_D2EX), .readData2_Out(readData2_D2EX), .Immediate_Out(immediate_D2EX), .Rs_Out(Rs_D2EX), .Rt_Out(Rt_D2EX), 
				.MemRead_Out(MemRead_D2EX), .MemWrite_Out(MemWrite_D2EX), .RegWrite_Out(writeToReg_D2EX), .MemtoReg_Out(MemtoReg_D2EX), .PCS_Out(PCS_D2EX), .HALT_Out(HALT_D2EX), 
				.Rd_Out(Rd_D2EX), .PC_Inc_Out(pcplus2_D2EX), .wen(cacheStall));
	
	// ++++++++++++++++++++++++++++++++++++++++ ID/EX +++++++++++++++++++++++++++++++++++++++++++++++
	
	
	
	// ++++++++++++++++++++++++++++++++++++++++ EX/MEM ++++++++++++++++++++++++++++++++++++++++++++++
	
	// Forwarding unit
	Forwarding iForwarding(.EX_MEM_RegWrite(writeToReg_EX2M), .EX_MEM_WriteRegister(Rd_EX2M), .ID_EX_Rs(Rs_D2EX), .ID_EX_Rt(Rt_D2EX), .XtoX_A(XtoX_A), .XtoX_B(XtoX_B), .MEM_WB_RegWrite(writeToReg_M2WB), 
						   .MEM_WB_WriteRegister(Rd_M2WB), .MtoX_A(MtoX_A), .MtoX_B(MtoX_B), .EX_MEM_MemWrite(MemWrite_EX2M), .EX_MEM_Rt(Rt_EX2M), .MtoM(MtoM));
	
	// Forwarding mux
	Forwarding_mux iForwardMux(.XtoX_A(XtoX_A), .XtoX_B(XtoX_B), .MtoX_A(MtoX_A), .MtoX_B(MtoX_B), .ID_EX_Rs(readData1_D2EX), .ID_EX_Rt(readData2_D2EX), .EX_MEM_ALUOut(ALU_Out_EX2M), .MEM_WB_WriteData(writeData), .ALUin1(ALUin1), 
							   .ALUin2(ALUin2), .ALUSrc(ALUSrc_D2EX), .immediate(immediate_D2EX), .dataRt(dataRt));
	
	// ALU & Flag register
	assign flagRegEn = (Rd_D2EX == 4'h0) ? 1'b0 : 1'b1;
	flag_register iflag_register(.clk(clk),.rst(~rst_n),.flag_in(Flag),.flag_out(flag_out), .wen(flagRegEn));
	ALU iALU(.ALU_Out(ALU_Out), .In1(ALUin1), .In2(ALUin2), .ALUOp(ALUOp_D2EX), .Flag(Flag), .Flagin(flag_out));
	
	// EX/MEM Register
	EX2M iEX2M(.MemRead(MemRead_D2EX), .MemWrite(MemWrite_D2EX), .RegWrite(writeToReg_D2EX), .MemtoReg(MemtoReg_D2EX), .PCS(PCS_D2EX), .HALT(HALT_D2EX), .clk(clk), .rst_n(~rst_n), 
				.ALU_Out(ALU_Out), .Rt(Rt_D2EX), .Rd(Rd_D2EX), .PC_Inc(pcplus2_D2EX), .MemRead_Out(MemRead_EX2M), .MemWrite_Out(MemWrite_EX2M), .RegWrite_Out(writeToReg_EX2M), .MemtoReg_Out(MemtoReg_EX2M), 
				.PCS_Out(PCS_EX2M), .HALT_Out(HALT_EX2M), .ALU_Out_Out(ALU_Out_EX2M), .Rt_Out(Rt_EX2M), .Rd_Out(Rd_EX2M), .PC_Inc_Out(pcplus2_EX2M), .dataRt(dataRt), .dataRt_Out(dataRt_EX2M), .wen(cacheStall));
	
	
	// ++++++++++++++++++++++++++++++++++++++++ EX/MEM ++++++++++++++++++++++++++++++++++++++++++++++
	
	
	
	// ++++++++++++++++++++++++++++++++++++++++ MEM/WB ++++++++++++++++++++++++++++++++++++++++++++++
	
	// Data memory
	// assign enable = MemRead_EX2M | MemWrite_EX2M;
	assign dataMemIn = (MtoM) ? writeData : dataRt_EX2M;	// MEM to MEM mux
	// memory_data datMemory(.data_out(dataMemOut), .data_in(dataMemIn), .addr(ALU_Out_EX2M), .enable(enable), .wr(MemWrite_EX2M), .clk(clk), .rst(~rst_n));
	
	// MEM/WB Register
	M2WB iM2WB(.RegWrite(writeToReg_EX2M), .MemtoReg(MemtoReg_EX2M), .PCS(PCS_EX2M), .HALT(HALT_EX2M), .clk(clk), .rst_n(~rst_n), .ALU_Out(ALU_Out_EX2M), .DataMem(dataMemOut), .Rd(Rd_EX2M), 
			   .PC_Inc(pcplus2_EX2M), .RegWrite_Out(writeToReg_M2WB), .MemtoReg_Out(MemtoReg_M2WB), .PCS_Out(PCS_M2WB), .HALT_Out(HALT_M2WB), .ALU_Out_Out(ALU_Out_M2WB), .DataMem_Out(dataMemOut_M2WB), 
			   .Rd_Out(Rd_M2WB), .PC_Inc_Out(pcplus2_M2WB), .wen(cacheStall));
	
	// ++++++++++++++++++++++++++++++++++++++++ MEM/WB ++++++++++++++++++++++++++++++++++++++++++++++
	
	
	
	// MUX selecting ALU_Out, dataMem, newAddr of PC to be written into register
	assign writeData = MemtoReg_M2WB ? dataMemOut_M2WB : PCS_M2WB ? pcplus2_M2WB : ALU_Out_M2WB;
		
	assign hlt = HALT_M2WB;
	assign pc = curAddr;
	
endmodule