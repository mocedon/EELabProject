//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 


module	controller (	
					input		logic	clk,
					input		logic	resetN,
					input 	logic	drawReq1,
					input 	logic	drawReq2,
					
					output	logic	collide // indicates pixel inside the bracket
);


always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
		
		collide	<=	1'b0;
	
	else 
	begin 
	
		
		if (drawReq1 == 1'b1 && drawReq2 == 1'b1)
			collide <= 1'b1 ;
		else
			collide <= 1'b0 ;
		
	end
end 
endmodule 