module insCache(clk, rst, metaIn, dataIn, blockEn, wordEn, metaWrite1, metaWrite2, dataWrite1, dataWrite2, metaOut1, metaOut2, dataOut1, dataOut2, hit);
	input clk, rst, metaWrite1, metaWrite2, dataWrite1, dataWrite2, hit; 
	input [7:0] metaIn;
	input [15:0] dataIn;
	input [63:0] blockEn;
	input [7:0] wordEn;
	output [7:0] metaOut1, metaOut2;
	output [15:0] dataOut1, dataOut2;
	
	// metadata array
	MetaDataArray metaData(.clk(clk), .rst(rst), .DataIn(metaIn), .Write1(metaWrite1), .Write2(metaWrite2), .BlockEnable(blockEn), .DataOut1(metaOut1), .DataOut2(metaOut2), .hit(hit));
	
	// data array
	DataArray dataArray(.clk(clk), .rst(rst), .DataIn(dataIn), .WriteW1(dataWrite1), .WriteW2(dataWrite2), .BlockEnable(blockEn), .WordEnable(wordEn), .DataOutW1(dataOut1), .DataOutW2(dataOut2));
		
endmodule