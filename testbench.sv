
`include "uvm_macros.svh"
 	import uvm_pkg::*;
	//import processing_check_pack::* ;

`include "my_interface.sv"
`include "my_transaction.sv"
`include "my_sequence.sv"
`include "my_driver.sv"
`include "my_monitor.sv"
`include "my_agent.sv"
`include "my_scoreboard.sv"
`include "my_env.sv"
`include "my_test.sv"


// The top module that contains the DUT and interface.
// This module starts the test.
module top;

  

  parameter CLK_HALF_PERIOD = 5 ;
  parameter CLK_PERIOD 		= CLK_HALF_PERIOD*2 ;
  
  logic clk ;
   
  // Instantiate the interface
  my_interface dut_if(.clk(clk));
  
  // Instantiate the DUT and connect it to the interface

	aes_core dut(
      .clk		(dut_if.clk),
      .reset_n	(dut_if.reset_n),
      .encdec	(dut_if.encdec),
      .init		(dut_if.init),
      .next		(dut_if.next),
      .ready	(dut_if.ready),
      .key		(dut_if.key),
      .keylen	(dut_if.keylen),
      .block	(dut_if.block),
      .result	(dut_if.result),
      .result_valid(dut_if.result_valid)
    );

  // Clockgenerator
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  
  initial begin 
    dut_if.init 	= 0 ;
    dut_if.next 	= 0 ;
    dut_if.keylen 	= 0 ;
    dut_if.encdec 	= 0 ;
    dut_if.reset_n 	= 0 ;
    #5 ;
    dut_if.reset_n 	= 1 ;
  end
  
  initial begin
    // Place the interface into the UVM configuration database
    uvm_config_db#(virtual my_interface)::set(null, "*", "dut_vif", dut_if);

    
    
    // Start the test
    run_test("my_test");
  end
  
   initial begin
    #3000;
     $display("END OF SIMUTION, CONGRATULATIONS :)");
    $finish();
  end
  
  // Dump waves
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, top);
  end
  
endmodule