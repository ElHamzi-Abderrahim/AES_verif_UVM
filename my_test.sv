

class my_test extends uvm_test;
    `uvm_component_utils(my_test)
    
    my_env env;

  	sequence_ENC_256KEY test_256key_enc ;
  	sequence_ENC_128KEY test_128key_enc ;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
      env = my_env::type_id::create("env", this);
      `uvm_info("TEST CLASS", "Build Phase!", UVM_MEDIUM)
    endfunction
    
    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      `uvm_info("TEST_CLASS", "Run Phase!", UVM_MEDIUM)
      phase.raise_objection(this);

    #10;
      repeat(7) begin
      #10;
      test_256key_enc = sequence_ENC_256KEY::type_id::create("test_256key_enc");
      test_256key_enc.start(env.agent.sequencer);
    end 
      phase.drop_objection(this);

    endtask

  endclass