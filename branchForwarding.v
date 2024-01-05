module branchForwarding(aluOpcode, branch, forwarding);
	input [3:0] aluOpcode;
	input branch;
	output forwarding;
	
	assign forwarding = branch & (aluOpcode == 4'h0 | aluOpcode == 4'h1 | aluOpcode == 4'h2 | aluOpcode == 4'h7 | aluOpcode == 4'h5 | aluOpcode == 4'h6 | aluOpcode == 4'h4);

endmodule