module	NumberConverter	(	
					input	logic	clk,
					input	logic	resetN,
					input	logic	[9:0] number,
					output	logic	[3:0] d1,// output the top left corner 
					output	logic	[3:0] d2,
					output	logic [3:0] d3,
					
);


always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
		number <=0;
	else 	begin
		d3 <= (int')number/4'd100;
		d1 <= (int')number % 4'd10;
		d2 <= ((int')number/ 4'd10) % 4'd10;
	end
end

endmodule
