module cache_fill_FSM(clk, rst_n, miss_detected, miss_address, fsm_busy, write_data_array, write_tag_array,memory_address, memory_data, memory_data_out, memory_data_valid, wordEn, state, memoryEn_FSM);
	input clk, rst_n;
	input miss_detected; // active high when tag match logic detects a miss
	input [15:0] miss_address; // address that missed the cache
	input [15:0] memory_data; // data returned by memory (after  delay)
	input memory_data_valid; // active high indicates valid data returning on memory bus
	
	output fsm_busy; // asserted while FSM is busy handling the miss (can be used as pipeline stall signal)
	output write_data_array; // write enable to cache data array to signal when filling with memory_data
	output write_tag_array; // write enable to cache tag array to signal when all words are filled in to data array
	output [15:0] memory_address; // address to read from memory
	output [7:0] wordEn;
	output [15:0] memory_data_out;
	output state;
	output memoryEn_FSM;
	
	wire currS, newS, condition1, condition2, pp, gg, oo, ppp, ggg, ooo;
	wire rstLogic1; 
	wire rstLogic2;
	wire [3:0] currCount, newCount, sum1;
	wire [15:0] currO, newO, sum2, imOffset;
	
	// State
	dff iSFF(.q(currS), .d(newS), .wen(1'b1), .clk(clk), .rst(rst_n)); 		// state flip flip, currS == 0 shows that we are in state of Idle. 
																			//                  currS == 1 shows that we are in state of Wait.
	assign condition1 = ~currS & miss_detected;
	assign condition2 = currS & (currCount != 4'h8);
	assign newS = condition1 | condition2;
	assign memoryEn_FSM = currO[7:4] == 4'b0000;
	
	
	// When to end
	assign rstLogic1 = rst_n | (newCount == 4'h9);					
	CLA_4bit iCLA1(.a(currCount), .b(4'h1), .cin(1'b0), .s(sum1), .g(g), .p(p));	
	assign newCount = currS ? sum1 : 4'h0;
	dff iCFF[3:0](.q(currCount), .d(newCount), .wen({4{memory_data_valid}}), .clk({4{clk}}), .rst({4{rstLogic1}}));
	
	
	// Memory Address
	assign rstLogic2 = rst_n | (~currS & newS);
	CLA_16bit iCLA2(.a(currO), .b(16'h0002), .sub(1'b0), .sum(sum2), .ppp(pp), .ggg(gg), .ovfl(oo));
	assign newO = currS ? sum2 : 16'h0000;		
	dff iAFF[15:0](.q(currO), .d(newO), .wen({16{currS}}), .clk({16{clk}}), .rst({16{rstLogic2}}));

	// calculate the final memory address used to read data from memory
	CLA_16bit iCLA3(.a(currO), .b({miss_address[15:4],4'h0}), .sub(1'b0), .sum(memory_address), .ppp(ppp), .ggg(ggg), .ovfl(ooo));
	assign imOffset = currCount;
	wordEnable iwordEn(.offset(imOffset[2:0]), .wordEnable(wordEn));
	
	// Assign outputs
	assign fsm_busy = (~currS & miss_detected) | currS;
	assign write_data_array = memory_data_valid & newS;																							
	assign write_tag_array = (currCount == 4'h8) & currS;
	assign memory_data_out = memory_data;
	assign state = currS;
	
endmodule	