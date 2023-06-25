

class my_monitor extends uvm_monitor;

	`uvm_component_utils(my_monitor)
	
	virtual my_interface dut_vif ;
	
	protected my_transaction trans_monit_collected ;
	uvm_analysis_port #(my_transaction) analysis_port ;
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction
	
  
    function void build_phase(uvm_phase phase);

      if (!uvm_config_db #(virtual my_interface)::get(null, "*", "dut_vif", dut_vif))
          `uvm_error("FROM MONITOR", "uvm_config_db::get failed")
      
      analysis_port = new("analysis_port", this) ;
      `uvm_info("MONITOR CLASS", "Build Phase!", UVM_MEDIUM)
      
    endfunction:build_phase
	
  
  
	virtual task run_phase(uvm_phase phase) ;
		super.run_phase(phase);
      	//`uvm_info("MONITOR CLASS", "RUN Phase!", UVM_MEDIUM)
      	trans_monit_collected = my_transaction::type_id::create("trans_monit_collected", this) ;
		forever begin
			do_monitoring();
        end
      		
	endtask:run_phase ;

	virtual protected task do_monitoring();
	//`uvm_info("MONITOR CLASS", "WRITE TRANS TO SCOREBOARD IMP!", UVM_MEDIUM)
		fork 
          begin
            @(posedge dut_vif.init); 
            //`uvm_info("MONITOR CLASS", "WRITE key TO SCOREBOARD IMP!", UVM_MEDIUM)
              trans_monit_collected.key	= dut_vif.key;
          end 
          begin 
          @(posedge dut_vif.result_valid) ;
          trans_monit_collected.block	= dut_vif.block;
          trans_monit_collected.result	= dut_vif.result;
            //`uvm_info("MONITOR CLASS", "WRITE result  TO SCOREBOARD IMP!", UVM_MEDIUM)
            //$display("[ MONITOR_TRANS ]The key = 0x%0h, plain_text = 0x%0h, 	design_res   = 0x%0h,",trans_monit_collected.key,
            //         						trans_monit_collected.block, trans_monit_collected.result) ;
            //$display("[ MONITOR_INTF ]The key = 0x%0h, plain_text = 0x%0h, 	design_res   = 0x%0h,",dut_vif.key,
            //         				dut_vif.block, dut_vif.result) ;
          analysis_port.write(trans_monit_collected) ;
          end 
        join
      	

	endtask: do_monitoring

  	
endclass: my_monitor