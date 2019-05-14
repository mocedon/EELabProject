module	Player_move	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input logic SPCPress,
					input logic init_x[10:0],
					input logic init_y[10:0],
					input logic boltReturn[3:0],
					output	logic	[10:0]	topLeftX1, 
					output	logic	[10:0]	topLeftY1, 
					output	logic	[10:0]	topLeftX2, 
					output	logic	[10:0]	topLeftY2, 
					output	logic	[10:0]	topLeftX3, 
					output	logic	[10:0]	topLeftY3, 
					output	logic	[10:0]	topLeftX4, 
					output	logic	[10:0]	topLeftY4, 
					output   logic [ 3:0]   boltFired
);


// a module used to generate a ball trajectory.  
parameter int dIECTION =  -1;
parameter int OFFSET_X = 20;
parameter int OFFSET_Y = 0;
parameter int SPEED_Y = 30;


const int	MULTIPLIER	=	64;
// multiplier is used to work with integers in high resolution 
// we devide at the end by multiplier which must be 2^n 
const int	x_FRAME_SIZE	=	639 * MULTIPLIER;
const int	y_FRAME_SIZE	=	479 * MULTIPLIER;

localparam logic prvKeySt ;


int topLeftY_tmp1, topLeftX_tmp1;
int topLeftY_tmp2, topLeftX_tmp2;
int topLeftY_tmp3, topLeftX_tmp3;
int topLeftY_tmp4, topLeftX_tmp4;


//  key press module 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		boltFired <= 4'b0000 ;
		prvKeySt <= 1'b0 ;
	end
	else 	begin
		if (SPCPress == 1'b1 && prvKeySt ==1'b0) begin
			if (boltFired[0] == 1'b0)
				boltFired[0] <= 1'b1 ;
			else if (boltFired[1] == 1'b0)
				boltFired[1] <= 1'b1 ;
			else if(boltFired[2] == 1'b0)
				boltFired[2] <= 1'b1 ;
			else if (boltFired[3] == 1'b0)
				boltFired[3] <= 1'b1 ;
		end	
	end
end


// position calculate 

always_ff@(posedge clk or negedge resetN or posedge plrHit)
begin
	if(!resetN)
	begin
		topLeftX_tmp1	<= INITIAL_X * MULTIPLIER;
		topLeftY_tmp1	<= INITIAL_Y * MULTIPLIER;
		topLeftX_tmp2	<= INITIAL_X * MULTIPLIER;
		topLeftY_tmp2	<= INITIAL_Y * MULTIPLIER;
		topLeftX_tmp3	<= INITIAL_X * MULTIPLIER;
		topLeftY_tmp3	<= INITIAL_Y * MULTIPLIER;
		topLeftX_tmp4	<= INITIAL_X * MULTIPLIER;
		topLeftY_tmp4	<= INITIAL_Y * MULTIPLIER;
	end
	else begin
		if (startOfFrame == 1'b1) begin // perform only 30 times per second 
			if (boltFired[0] == 1'b0 || boltReturn[0] == 1'b1) begin
				topLeftX_tmp1 <= topLeftX1 * MULTIPLIER ;
				topLeftY_tmp1 <= topLeftY1 * MULTIPLIER ;
			end
			else begin
				topLeftY_tmp1 <= topLeftY_tmp1 + (SPEED_Y * MULTIPLIER * DIRECTION) ;
				topLeftX_tmp1 <= topLeftX_tmp1  ;
			end
			
			if (boltFired[1] == 1'b0 || boltReturn[1] == 1'b1) begin
				topLeftX_tmp2 <= topLeftX2 * MULTIPLIER ;
				topLeftY_tmp2 <= topLeftY2 * MULTIPLIER ;
			end
			else begin
				topLeftY_tmp2 <= topLeftY_tmp2 + (SPEED_Y * MULTIPLIER * DIRECTION) ;
				topLeftX_tmp2 <= topLeftX_tmp2  ;
			end
			
			if (boltFired[2] == 1'b0 || boltReturn[2] == 1'b1) begin
				topLeftX_tmp3 <= topLeftX3 * MULTIPLIER ;
				topLeftY_tmp3 <= topLeftY3 * MULTIPLIER ;
			end
			else begin
				topLeftY_tmp3 <= topLeftY_tmp3 + (SPEED_Y * MULTIPLIER * DIRECTION) ;
				topLeftX_tmp3 <= topLeftX_tmp3  ;
			end
			
			if (boltFired[3] == 1'b0 || boltReturn[3] == 1'b1) begin
				topLeftX_tmp4 <= topLeftX4 * MULTIPLIER ;
				topLeftY_tmp4 <= topLeftY4 * MULTIPLIER ;
			end
			else begin
				topLeftY_tmp4 <= topLeftY_tmp4 + (SPEED_Y * MULTIPLIER * DIRECTION) ;
				topLeftX_tmp4 <= topLeftX_tmp4  ;
			end
		end
	end
end

//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_tmp / MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_tmp / MULTIPLIER ;    


endmodule
