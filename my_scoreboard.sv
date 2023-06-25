
import "DPI-C" function void aes_encrypt_dpi(input int nk , output bit [127:0] ct, input bit [127:0] pt, input bit [255:0] key) ;

class my_scoreboard extends uvm_scoreboard;
	
	`uvm_component_utils(my_scoreboard)
	
	
    my_transaction recieved_transactions[$];
     
  
	uvm_analysis_imp #(my_transaction, my_scoreboard) analysis_export ;
	
	function new(string name="my_scoreboard", uvm_component parent=null) ;
		super.new(name, parent) ;
	endfunction
	
	
	function void build_phase(uvm_phase phase);
      	super.build_phase(phase) ;
      	analysis_export = new("analysis_export", this) ;
      	`uvm_info("SCOREBOARD CLASS", "Build Phase!", UVM_MEDIUM)
      
	endfunction
	
  bit [127 : 0] Expected_result ;
  
	virtual function void write(input my_transaction trans) ;
        recieved_transactions.push_front(trans) ;
	endfunction: write
	
  
  	function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      `uvm_info("SCB_CLASS", "Connect Phase!", UVM_HIGH)
  	endfunction: connect_phase
  
  
	virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
      `uvm_info("Scoreboard_CLASS", "Run Phase!", UVM_MEDIUM)
  
      forever begin
      	 my_transaction recieved_trans ;
        wait((recieved_transactions.size() != 0));
        recieved_trans = recieved_transactions.pop_back();
        aes_encrypt_dpi(1, Expected_result , recieved_trans.block , recieved_trans.key) ;
        ////if (Expected_result != recieved_trans.result) 
          //begin
            //$display("[ SCOREBOARD ] Faill TEST ") ; 
                   //recieved_trans.block, recieved_trans.result) ;
          $display("[ SCOREBOARD ]The key = 0x%0h, plain_text = 0x%0h, 	design_res   = 0x%0h,",recieved_trans.key, 
                   recieved_trans.block, recieved_trans.result) ;
          $display("[ SCOREBOARD ]										     expected_res = 0x%0h,", Expected_result ) ;
          $display("_________________________________________________________________") ;
          //end
      end 
	endtask : run_phase

	//virtual function void check_phase(uvm_phase phase);
		

  
endclass : my_scoreboard