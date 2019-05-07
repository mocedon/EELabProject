
module	Invader_move	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input	logic	speedUp,  //Speed up the movent of the invaders 
					input logic oneSec, 
					input logic changeDirection,
					
					output	logic	[10:0]	topLeftX,// output the top left corner 
					output	logic	[10:0]	topLeftY
					
);




parameter int INITIAL_X = 40;
parameter int INITIAL_Y = 60;
parameter int INITIAL_X_SPEED = 30;


const int	MULTIPLIER	=	64;
// multiplier is used to work with integers in high resolution 
// we devide at the end by multiplier which must be 2^n 
const int	x_FRAME_SIZE	=	639 * MULTIPLIER;
const int	y_FRAME_SIZE	=	479 * MULTIPLIER;


int Xspeed, topLeftX_tmp; // local parameters 
int Yspeed, topLeftY_tmp;



//  calculation x Axis speed 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
		Xspeed	<= INITIAL_X_SPEED;
	else 	begin
			
			
				
			if ((topLeftX_tmp <= 0 ) && (Xspeed < 0) ) // hit left border while moving right
				Xspeed <= -Xspeed ; 
			
			if ( (topLeftX_tmp >= x_FRAME_SIZE) && (Xspeed > 0 )) // hit right border while moving left
				Xspeed <= -Xspeed ;
			
	end
end



// position calculate 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		topLeftX_tmp	<= INITIAL_X * MULTIPLIER;
		topLeftY_tmp	<= INITIAL_Y * MULTIPLIER;
	end
	else begin
		if (startOfFrame == 1'b1) begin // perform only 30 times per second 
						
				 
					topLeftX_tmp  <= topLeftX_tmp + Xspeed; 
				
			
				
			end
	end
end

//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_tmp / MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_tmp / MULTIPLIER ;    


endmodule
