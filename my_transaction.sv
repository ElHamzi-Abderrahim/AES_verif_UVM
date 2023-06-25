class my_transaction extends uvm_sequence_item;

	`uvm_object_utils(my_transaction)
	bit    			reset_n;
	bit   			encdec;
	bit   			init;
	bit   			next;
	rand bit [127 : 0]  block;
	rand bit [255 : 0]  key;
	bit   			keylen ;
	
	bit [127 : 0] 	result;
  	bit   			ready;
    bit [127:0] 	cipher_text;
	
  constraint c_key { key >= 256'h0 		; key < 256'hffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff;}//
  constraint c_plain_text { block >= 128'h0 	; block < 128'hffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff;} //

	function new (string name = "");
		super.new(name);
      	//`uvm_info("TEST_SEQ", "Inside Constructor!", UVM_MEDIUM)
	endfunction

endclass : my_transaction
