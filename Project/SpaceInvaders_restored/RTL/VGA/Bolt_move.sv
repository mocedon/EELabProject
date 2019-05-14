module	Bolt_move	(	
 
					input	   logic	clk,
					input	   logic	resetN,
					input	   logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input    logic shootCmd,
					input    logic [10:0]init_x,
					input    logic [10:0]init_y,
					
					output	logic	[10:0]	topLeftX, 
					output	logic	[10:0]	topLeftY
					
);


// a module used to generate a ball trajectory.  
parameter int DIRECTION =  -1;
parameter int OFFSET_X = 0;
parameter int OFFSET_Y = 0;
parameter int SPEED_Y = 10;


const int	MULTIPLIER	=	64;
// multiplier is used to work with integers in high resolution 
// we devide at the end by multiplier which must be 2^n 



int topLeftY_tmp, topLeftX_tmp;


// position calculate 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		topLeftX_tmp <= 0 ;
		topLeftY_tmp <= 0 ;
	end
	else begin 
		if (shootCmd== 1'b0) begin
			topLeftX_tmp <= (int'(init_x) + OFFSET_X) * MULTIPLIER ;
			topLeftY_tmp <= (int'(init_y) + OFFSET_Y) * MULTIPLIER ;
		end				
		else
		if (startOfFrame == 1'b1) begin // perform only 30 times per second 
			topLeftY_tmp <= topLeftY_tmp + (SPEED_Y * MULTIPLIER * DIRECTION) ;
			topLeftX_tmp <= topLeftX_tmp  ;
		end
	end
end

//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_tmp / MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_tmp / MULTIPLIER ;    


endmodule
