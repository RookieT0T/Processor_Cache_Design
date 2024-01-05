module cacheAccess(clk, rst, memAddress, insAddress, memDataIn, memDataOut, insDataOut, memWrite, memRead, insStall, memStall);
	input clk, rst, memWrite, memRead;
	input [15:0] memAddress, insAddress, memDataIn; 
	output [15:0] memDataOut, insDataOut;
	output insStall, memStall;
	
	// wires shared by instruction memory cache & data memory cache
	wire dataValid;
	wire [15:0] dataOut_Memory;
	
	// wires in data memory cache
	wire dataCacheEn;
	wire dataCacheWay1Act, dataCacheWay2Act;
	wire [5:0] memTag, memSet;
	wire [2:0] memOffset;
	wire [63:0] memBlockEn;
	wire [7:0] memWordEn;
	wire [7:0] memMeta1, memMeta2;
	wire [15:0] memData1, memData2;
	wire dataCacheMiss, dataCacheWayToWrite;
	wire memDataWrite, memTagWrite;
	wire [7:0] memWordEn_FSM1;		// word enable from FSM
	wire [15:0] memAddress_FSM1;	// memory address from FSM
	wire [15:0] dataOut_FSM1;
	wire [7:0] dataCacheMetaIn;
	wire [15:0] dataCacheDataIn;
	wire [7:0] dataCacheWordEn;
	wire dataCacheMetaWrite1, dataCacheMetaWrite2, dataCacheDataWrite1, dataCacheDataWrite2;
	wire state1, memoryEn_FSM1;
	wire FSMen1;
	wire FSM_busy1;
	
	// wires in instruction memory cache
	wire [5:0] insTag, insSet;
	wire [2:0] insOffset;
	wire [7:0] insWordEn;
	wire [63:0] insBlockEn;
	wire insCacheWay1Act, insCacheWay2Act;
	wire insCacheWayToWrite;
	wire insCacheMiss;
	wire [7:0] insCacheMetaIn, insCacheWordEn;
	wire insCacheMetaWrite1, insCacheMetaWrite2, insCacheDataWrite1, insCacheDataWrite2;
	wire [7:0] insMeta1, insMeta2;
	wire [15:0] insData1, insData2;
	wire [7:0] memWordEn_FSM2;
	wire insTagWrite, insDataWrite;
	wire [15:0] dataOut_FSM2, memAddress_FSM2;
	wire FSMen2;
	wire state2, memoryEn_FSM2;
	
	// wires in main memory
	wire memoryEn, wr;
	wire [15:0] memoryAddr;
	
	// +++++++++++++++++++++++++++++ Data Memory Cache ++++++++++++++++++++++++++++ //

	assign dataCacheEn = memWrite | memRead;
	
	// tag, set, offset bits of requested data memory address
	assign memTag = memAddress[15:10];
	assign memSet = memAddress[9:4];
	assign memOffset = memAddress[3:1];
	
	// determine which block and which word is enabled
	wordEnable iwordEn1(.offset(memOffset), .wordEnable(memWordEn));
	blockEnable iblockEn1(.setBits(memSet), .blockEnable(memBlockEn));
	
	// determine which way is activated (hit occurs)
	assign dataCacheWay1Act = memTag == memMeta1[7:2] & memMeta1[0];																	// tag -> [7:2]		LRU -> [1]		valid -> [0] 
	assign dataCacheWay2Act = memTag == memMeta2[7:2] & memMeta2[0];																	// Act only when HIT
	assign dataCacheWayToWrite = ~dataCacheWay1Act & ~dataCacheWay2Act & memMeta2[1]; 									// if LRU of way 2 is 1, write to way 2;	cache miss;	LRU == 1
	assign dataCacheMiss = ~dataCacheWay1Act & ~dataCacheWay2Act & dataCacheEn;
	
	// data memory cache
	assign dataCacheDataIn = dataCacheMiss ? dataOut_FSM1 : memDataIn;
	assign dataCacheMetaIn = {memAddress[15:10], dataCacheWay2Act, 1'b1};														// XXX
	assign dataCacheWordEn = dataCacheMiss ? memWordEn_FSM1 : memWordEn;
	assign dataCacheMetaWrite1 = memTagWrite & ~dataCacheWayToWrite & dataCacheMiss;
	assign dataCacheMetaWrite2 = memTagWrite & dataCacheWayToWrite & dataCacheMiss;
	assign dataCacheDataWrite1 = (memWrite & dataCacheWay1Act) | (memDataWrite & ~dataCacheWayToWrite & dataCacheMiss);	// hit or miss
	assign dataCacheDataWrite2 = (memWrite & dataCacheWay2Act) | (memDataWrite & dataCacheWayToWrite & dataCacheMiss);	// hit or miss
	
	dataCache iDataCache(.clk(clk), .rst(rst), .metaIn(dataCacheMetaIn), .dataIn(dataCacheDataIn), .blockEn(memBlockEn), .wordEn(dataCacheWordEn), .metaWrite1(dataCacheMetaWrite1), 
						.metaWrite2(dataCacheMetaWrite2), .dataWrite1(dataCacheDataWrite1), .dataWrite2(dataCacheDataWrite2), .metaOut1(memMeta1), .metaOut2(memMeta2), .dataOut1(memData1), .dataOut2(memData2), 
						.hit(~dataCacheMiss & dataCacheEn));
	
	// FSM for data memory cache
	assign FSMen1 = dataCacheMiss & (~state2);
	cache_fill_FSM iFSM1(.clk(clk), .rst_n(rst), .miss_detected(FSMen1), .miss_address(memAddress), .fsm_busy(FSM_busy1), .write_data_array(memDataWrite), .write_tag_array(memTagWrite), 
						.memory_address(memAddress_FSM1), .memory_data(dataOut_Memory), .memory_data_out(dataOut_FSM1), .memory_data_valid(dataValid), .wordEn(memWordEn_FSM1), .state(state1),
						.memoryEn_FSM(memoryEn_FSM1));
	assign memStall = FSM_busy1 | dataCacheMiss;
	// update memDataOut
	// cache hit: (~dataCacheMiss & dataCacheWay1Act) ? memData1 : memData2;
	// cache miss: high impedence
	assign memDataOut = (~dataCacheMiss) ? (dataCacheWay1Act & dataCacheEn) ? memData1 : memData2 : {16{1'bz}};
	
	
	// +++++++++++++++++++++++ Instruction Memory Cache ++++++++++++++++++++++++++++ //
	
	//assign memoryBusy = 
	
	// tag, set, offset bits of requested instruction memory address
	assign insTag = insAddress[15:10];
	assign insSet = insAddress[9:4];
	assign insOffset = insAddress[3:1];
	
	// determine which block and which word is enabled
	wordEnable iwordEn2(.offset(insOffset), .wordEnable(insWordEn));
	blockEnable iblockEn2(.setBits(insSet), .blockEnable(insBlockEn));
	
	// determine which way is activated (hit occurs)
	assign insCacheWay1Act = (insTag == insMeta1[7:2]) & insMeta1[0];
	assign insCacheWay2Act = (insTag == insMeta2[7:2]) & insMeta2[0];
	assign insCacheWayToWrite = ~insCacheWay1Act & ~insCacheWay2Act & insMeta2[1];
	assign insCacheMiss = ~insCacheWay1Act & ~insCacheWay2Act;
	
	// instruction memory cache
	assign insCacheMetaIn = {insAddress[15:10], insCacheWay2Act, 1'b1};													// XXX
	assign insCacheWordEn = insCacheMiss ? memWordEn_FSM2 : insWordEn;
	assign insCacheMetaWrite1 = insTagWrite & ~insCacheWayToWrite & insCacheMiss;
	assign insCacheMetaWrite2 = insTagWrite & insCacheWayToWrite & insCacheMiss;
	assign insCacheDataWrite1 = insDataWrite & ~insCacheWayToWrite & insCacheMiss;
	assign insCacheDataWrite2 = insDataWrite & insCacheWayToWrite & insCacheMiss;
	
	
	insCache iInsCache(.clk(clk), .rst(rst), .metaIn(insCacheMetaIn), .dataIn(dataOut_FSM2), .blockEn(insBlockEn), .wordEn(insCacheWordEn), .metaWrite1(insCacheMetaWrite1), .metaWrite2(insCacheMetaWrite2), 
						.dataWrite1(insCacheDataWrite1), .dataWrite2(insCacheDataWrite2), .metaOut1(insMeta1), .metaOut2(insMeta2), .dataOut1(insData1), .dataOut2(insData2), .hit(~insCacheMiss));
	
	// FSM for instruction memory cache
	assign FSMen2 = insCacheMiss & (~state1);
	cache_fill_FSM iFSM2(.clk(clk), .rst_n(rst), .miss_detected(FSMen2), .miss_address(insAddress), .fsm_busy(insStall), .write_data_array(insDataWrite), .write_tag_array(insTagWrite), 
						.memory_address(memAddress_FSM2), .memory_data(dataOut_Memory), .memory_data_out(dataOut_FSM2), .memory_data_valid(dataValid), .wordEn(memWordEn_FSM2), .state(state2),
						.memoryEn_FSM(memoryEn_FSM2));
	
	assign insDataOut = (~insCacheMiss) ? (insCacheWay1Act) ? insData1 : insData2 : {16{1'bz}};
	
	
	// +++++++++++++++++++++++++ Main Memory ++++++++++++++++++++++++++++ //
	assign memoryEn = (insCacheMiss | dataCacheMiss | memWrite) & ( (memoryEn_FSM2 & state2) | (memoryEn_FSM1 & state1));
	assign memoryAddr = (insCacheMiss) ? memAddress_FSM2 : (dataCacheMiss) ? memAddress_FSM1 : memAddress;
	assign wr = memWrite & (~dataCacheMiss);
	memory4c mainMemory(.data_out(dataOut_Memory), .data_in(memDataIn), .addr(memoryAddr), .enable(memoryEn), .wr(wr), .clk(clk), .rst(rst), .data_valid(dataValid));
	
endmodule