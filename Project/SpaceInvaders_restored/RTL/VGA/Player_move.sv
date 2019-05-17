					   
module	Player_move	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input logic plrHit,
					input logic right,
					input logic left,
					output	logic	[10:0]	topLeftX,// output the top left corner 
					output	logic	[10:0]	topLeftY 
					
);

																											

parameter int INITIAL_X = 320;
parameter int INITIAL_Y = 450;
parameter int X_SPEED = 128;

const int	MULTIPLIER	=	64;
// multiplier is used to work with integers in high resolution 
						
					
// we devide at the end by multiplier which must be 2^n 
const int	x_FRAME_SIZE	=	639 * MULTIPLIER;
const int	y_FRAME_SIZE	=	479 * MULTIPLIER;


int Xspeed; // local parameters 
int topLeftY_tmp, topLeftX_tmp;
int offset = 58 * MULTIPLIER;


//  key press module 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
		Xspeed	<= 0 ;
	else 	begin
			if (right)
					Xspeed <= X_SPEED ;
			else if (left)
					Xspeed <= -X_SPEED ;
			else
					Xspeed <= 0 ;
			end
	end

// position calculate 

always_ff@(posedge clk or negedge resetN or posedge plrHit)
begin
	if(!resetN || plrHit==1'b1)
	begin
		topLeftX_tmp	<= INITIAL_X * MULTIPLIER;
		topLeftY_tmp	<= INITIAL_Y * MULTIPLIER;
	end
	else begin
		if (startOfFrame == 1'b1) begin // perform only 30 times per second
			if ((topLeftX_tmp < x_FRAME_SIZE - offset-2*Xspeed)&&(topLeftX_tmp >(-1)*Xspeed )) // test if this works
					topLeftX_tmp  <= topLeftX_tmp + Xspeed; 
			end
	end
end

//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_tmp / MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_tmp / MULTIPLIER ;    


endmodule
