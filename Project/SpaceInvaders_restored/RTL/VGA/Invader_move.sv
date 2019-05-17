module	Invader_move	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input	logic	idleN,  //Speed up the movent of the invaders 
					input logic oneSec, 
					input logic chgDir,
					
					output	logic	[10:0]	topLeftX,// output the top left corner 
					output	logic	[10:0]	topLeftY
					
);


parameter int INIT_X = 20;
parameter int INIT_Y = 20;
parameter int INIT_X_S = 60;
parameter int INIT_Y_S = 20;


const int	MULTIPLIER	=	64;
// multiplier is used to work with integers in high resolution 
// we devide at the end by multiplier which must be 2^n 
const int	x_FRAME_SIZE	=	639 * MULTIPLIER;
const int	y_FRAME_SIZE	=	479 * MULTIPLIER;


int Xspeed, topLeftX_tmp; // local parameters 
int Yspeed, topLeftY_tmp;



enum logic [2:0] {idle ,
						movRGT ,
						movDTL ,
						movLFT ,
						movDTR }
		prt_st , nxt_st ;

//  calculation x Axis speed 
always_ff @(posedge clk or negedge resetN)
begin : fsm_sync
	if (!resetN)
		prt_st <= idle ;
	else
		prt_st <= nxt_st ;
end
	

always_comb

begin
	// default output
	Xspeed = 0 ;
	Yspeed = 0 ;
	nxt_st = prt_st ;
	
	case (prt_st)
	
		idle : begin
			if (idleN == 1'b1)
				nxt_st = movRGT ;
		end
			
		movRGT : begin
			Xspeed = INIT_X_S ;
			if (topLeftX_tmp >= x_FRAME_SIZE - 1200 || chgDir == 1'b1) 
				nxt_st = movDTL ;
		end
			
		movDTL : begin
			Yspeed = INIT_Y_S ;
			if (oneSec == 1'b1)
				nxt_st = movLFT ; 
		end
		
		movLFT : begin
			Xspeed = -INIT_X_S ;
			if (topLeftX_tmp <= 0 || chgDir == 1'b1)
				nxt_st = movDTR ;
		end 
		
		movDTR : begin
			Yspeed = INIT_Y_S ;
			if (oneSec ==1'b1)
				nxt_st = movRGT ;
		end
			
			
	endcase
end


// position calculate 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		topLeftX_tmp	<= INIT_X * MULTIPLIER;
		topLeftY_tmp	<= INIT_Y * MULTIPLIER;
	end
	else begin
		if (startOfFrame == 1'b1) begin// perform only 30 times per second 
					topLeftX_tmp <= topLeftX_tmp + Xspeed ;
					topLeftY_tmp <= topLeftY_tmp + Yspeed ; 
		end
	end
end

//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_tmp / MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_tmp / MULTIPLIER ;    


endmodule