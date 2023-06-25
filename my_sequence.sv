


class sequence_ENC_256KEY extends uvm_sequence #(my_transaction);

  `uvm_object_utils(sequence_ENC_256KEY)
  my_transaction req_256key ;

  function new (string name = "");
    super.new(name);
  endfunction

  task body;
    repeat(3) begin
      req_256key = my_transaction::type_id::create("req_256key");
      
      start_item(req_256key);
      req_256key.reset_n 	= 1 ;
      req_256key.keylen 	= 1 ;
      req_256key.encdec 	= 1 ;
	  req_256key.init 		= 1 ;
      
      req_256key.randomize();
        if (!req_256key.randomize()) begin
          `uvm_error("SEQUENCE_256KEY", "Randomize failed.");
        end

      finish_item(req_256key);
      
    end
  endtask: body

endclass: sequence_ENC_256KEY



class sequence_ENC_128KEY extends uvm_sequence #(my_transaction);

  `uvm_object_utils(sequence_ENC_128KEY)
   my_transaction req_128key ;

  function new (string name = "");
    super.new(name);
  endfunction

  task body;
    repeat(3) begin
      req_128key = my_transaction::type_id::create("req_128key");
      
      req_128key.reset_n 	= 1 ;
      req_128key.keylen 	= 0 ;
      req_128key.encdec 	= 1 ;
	  req_128key.init 		= 1 ;
      							
      start_item(req_128key);
        req_128key.randomize() with {init == 1; reset_n == 1 ; keylen == 0 ;};
        if (!req.randomize()) begin
          `uvm_error("SEQUENCE_128KEY", "Randomize failed.")
        end
      finish_item(req_128key);
      
    end
  endtask: body

endclass: sequence_ENC_128KEY
