//Tag Array of 128  blocks
//Each block will have 1 byte
//BlockEnable is one-hot
//WriteEnable is one on writes and zero on reads


// DataIn = [7:2]tag [1]way [0]not used
module MetaDataArray(input clk, input rst, input [7:0] DataIn, input Write1, input Write2, input [63:0] BlockEnable, output [7:0] DataOut1, output [7:0] DataOut2, input hit);
	wire way_to_LRU = DataIn[1]; // 1 to way2, 0 to way1
	wire [7:0] DataIn1;
	wire [7:0] DataIn2, DataOut1_D, DataOut2_D;
	assign DataIn1 = hit ? {DataOut1_D[7:2], way_to_LRU, DataOut1_D[0]} : {DataIn[7:2], way_to_LRU, 1'b1};
	assign DataIn2 = hit ? {DataOut2_D[7:2], ~way_to_LRU, DataOut2_D[0]} : {DataIn[7:2], ~way_to_LRU, 1'b1};
	wire Write_real1;
	assign Write_real1 = hit | (~hit & Write1);
	// hit : modify tag LRU and valid
	// miss : do nothing
	// miss & write : modify way 0 or 1, tag
	MBlock Mblk1[63:0]( .clk(clk), .rst(rst), .Din(DataIn1), .WriteEnable(hit | (~hit & Write1)), .Enable(BlockEnable), .Dout(DataOut1_D));
	MBlock Mblk2[63:0]( .clk(clk), .rst(rst), .Din(DataIn2), .WriteEnable(hit | (~hit & Write2)), .Enable(BlockEnable), .Dout(DataOut2_D));
	
	assign DataOut1 = DataOut1_D;
	assign DataOut2 = DataOut2_D;
	
endmodule

// [7:2]tag [1]LRU [0]valid
module MBlock( input clk,  input rst, input [7:0] Din, input WriteEnable, input Enable, output [7:0] Dout);
	MCell mc[7:0]( .clk(clk), .rst(rst), .Din(Din[7:0]), .WriteEnable(WriteEnable), .Enable(Enable), .Dout(Dout[7:0]));
endmodule

module MCell( input clk,  input rst, input Din, input WriteEnable, input Enable, output Dout);
	wire q;
	assign Dout = Enable ? q : 'bz;
	dff dffm(.q(q), .d(Din), .wen(Enable & WriteEnable), .clk(clk), .rst(rst));
endmodule
