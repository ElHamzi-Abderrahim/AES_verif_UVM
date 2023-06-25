

  
class my_env extends uvm_env;
  `uvm_component_utils(my_env)
    
    my_agent agent;
  	my_scoreboard scoreboard;
  
  
    function new(string name, uvm_component parent);
		super.new(name, parent);
      `uvm_info("ENV CLASS", "inside CONSTRUCTOR!", UVM_MEDIUM)
    endfunction
    
  
    function void build_phase(uvm_phase phase);
		agent 		= my_agent::type_id::create("agent", this);
      	scoreboard 	= my_scoreboard::type_id::create("scoreboard", this) ;
      
      `uvm_info("ENV CLASS", "Build Phase!", UVM_MEDIUM)
    endfunction : build_phase
  
	
	function void connect_phase(uvm_phase phase);
		agent.monitor.analysis_port.connect(scoreboard.analysis_export);
      	`uvm_info("ENV CLASS", "RUN Phase!", UVM_MEDIUM)
	endfunction : connect_phase
  
    task run_phase(uvm_phase phase);
      super.run_phase(phase) ;
    endtask

endclass