module tb_blockEnable6to64;

  reg [5:0] test_setBits;
  wire [63:0] test_blockEnable;
  
  // Instantiate the blockEnable6to64 module
  blockEnable6to64 uut (
    .setBits(test_setBits),
    .blockEnable(test_blockEnable)
  );

  // Testcase 0
  initial begin
    test_setBits = 6'b000000;
    #10; // Wait for 10 time units
    $display("Testcase 0: setBits = %d, blockEnable = %b", test_setBits, test_blockEnable);

  // Testcase 1
    test_setBits = 6'b000001;
    #10;
    $display("Testcase 1: setBits = %d, blockEnable = %b", test_setBits, test_blockEnable);

  // Testcase 2
    test_setBits = 6'b001010;
    #10;
    $display("Testcase 2: setBits = %d, blockEnable = %b", test_setBits, test_blockEnable);

  // Testcase 3
    test_setBits = 6'b100000;
    #10;
    $display("Testcase 3: setBits = %d, blockEnable = %b", test_setBits, test_blockEnable);

  // Testcase 4
    test_setBits = 6'b111111;
    #10;
    $display("Testcase 4: setBits = %d, blockEnable = %b", test_setBits, test_blockEnable);

  // Testcase 5
  
    test_setBits = 6'b010101;
    #10;
    $display("Testcase 5: setBits = %d, blockEnable = %b", test_setBits, test_blockEnable);

	$stop();
  end

endmodule
