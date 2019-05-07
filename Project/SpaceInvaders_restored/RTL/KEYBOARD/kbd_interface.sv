// (c) Technion IIT, Department of Electrical Engineering 2018 
// Written By David Bar-On  June 2018 

module kbd_interface 	
 ( 
   input	   logic  clk,
	input	   logic  resetN, 
	input	   logic  kbd_dat,
	input	   logic  kbd_clk,
   output  logic [8:0]	keyCode,	
   output  logic 	make,	
   output  logic 	brake	
	 
  ) ;

// internaal wires 
 logic [7:0]din  ; 
 logic din_new ; 
 logic kbdclk_filt ; 

// sub modules 
///intantiation

lpf #(.FILTER_SIZE (2))  
U1
 (
   .resetN(resetN),  
	.clk (clk),
	.in (kbd_clk),
	.out_filt(kbdclk_filt)
	) ; 
	

bitrec U2(
	.resetN(resetN),  
	.clk (clk),
	.kbd_dat(kbd_dat),
	.kbd_clk(kbdclk_filt),
	.dout_new (din_new), 	
	.dout (din) 
) ; 
	
	
	byterec U3(
	.resetN(resetN),  
	.clk (clk),
	.din  (din), 
	.din_new (din_new), 	
	.keyCode (keyCode), 
   .make(make),
   .brakk(brake)
) ; 
	


endmodule


