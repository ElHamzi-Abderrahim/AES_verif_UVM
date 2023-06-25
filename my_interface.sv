

interface my_interface(input bit clk);
	logic  				reset_n;
	logic  				encdec;
	logic  				init;
	logic  				next;
	logic  				ready;
	logic	[255 : 0]  	key;
	logic  				keylen;
	logic	[127 : 0]  	block;
	logic	[127 : 0] 	result;
	logic  				result_valid;
endinterface