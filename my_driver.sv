

class my_driver extends uvm_driver #(my_transaction);

  `uvm_component_utils(my_driver)
  
	my_transaction trans ;
  	virtual my_interface dut_vif;

 	function new(string name, uvm_component parent);
		super.new(name, parent);
		`uvm_info("DRIVER_CLASS", "Inside Constructor!", UVM_MEDIUM)
	endfunction
  
  
	function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Get interface reference from config database
    if(!uvm_config_db#(virtual my_interface)::get(this, "*", "dut_vif", dut_vif)) 
        begin
          `uvm_error("FROM DRIVER", "Failed to get virtual interface from config_db!!")
        end
    endfunction 


    task run_phase(uvm_phase phase);
      super.run_phase(phase) ;
      `uvm_info("FROM DRIVER", "run phase", UVM_MEDIUM)
      // First toggle reset
      forever begin
        trans = my_transaction::type_id::create("trans");
        seq_item_port.get_next_item(trans);
        drive_item(trans) ;
        seq_item_port.item_done();
      end
    endtask
  
	task drive_item(input my_transaction seq);
      
      dut_vif.keylen 		= seq.keylen ;
      dut_vif.result_valid 	= 0 ;
      dut_vif.init 			= seq.init ;
      dut_vif.key 			= seq.key ;
      seq.ready 			= dut_vif.ready ;
      dut_vif.reset_n 		= seq.reset_n ;
      dut_vif.encdec 		= seq.encdec ;
      dut_vif.next 			= seq.next ;

     
      @(negedge dut_vif.ready) ;
      repeat(2) @(negedge dut_vif.clk) ;
      
      dut_vif.init = 0 ;
      @(posedge dut_vif.ready) ;
      @(negedge dut_vif.clk) ;
      dut_vif.next = 1 ;
      
      fork
        begin 
          @(negedge dut_vif.ready);
          repeat(2)@(negedge dut_vif.clk) ;
          dut_vif.next = 0 ;
        end
        dut_vif.block = seq.block ;//128'h6bc1_bee2_2e40_9f96_e93d_7e11_7393_172a
      join
      
      @(posedge dut_vif.ready) ;
      dut_vif.result_valid = 1 ;
  //
      dut_vif.init = 1 ;
      @(negedge dut_vif.clk) ;
      
	endtask;

endclass: my_driver
