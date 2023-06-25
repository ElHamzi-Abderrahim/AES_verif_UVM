

class my_agent extends uvm_agent;
    `uvm_component_utils(my_agent)
    
    my_driver 	driver;
  	uvm_sequencer#(my_transaction) sequencer;
	my_monitor 	monitor;
    
    function new(string name, uvm_component parent);
		super.new(name, parent);
      `uvm_info("AGENT_CLASS", "Inside Constructor!", UVM_MEDIUM)
    endfunction
    
  
    function void build_phase(uvm_phase phase);
		driver 		= my_driver::type_id::create("driver", this);
		sequencer 	= uvm_sequencer #(my_transaction)::type_id::create("sequencer", this);
		monitor 	= my_monitor::type_id::create("monitor", this) ;
    endfunction : build_phase 
    
  
    // In UVM connect phase, we connect the sequencer to the driver.
    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase) ;
		driver.seq_item_port.connect(sequencer.seq_item_export);
		//monitor.analysis_port.connect(analysis_port); // connect child comp. to parent via analysis_port
    endfunction : connect_phase
    
  
    task run_phase(uvm_phase phase);
      super.run_phase(phase) ;
    endtask : run_phase

endclass