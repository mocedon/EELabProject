module	controller (	
					
					// General inputs
					input logic clk ,
					input logic resetN,
					
					input logic spcKey ,
					input logic oneSec ,
					input logic rndNum ,
					
					input logic [10:0] pixelX ,
					input logic [10:0] pixelY ,
				
					// Player inputs
					input logic plrReq ,
					
					// Invader inputs
					input logic invReq ,
					input logic [10:0]invOSX ,
					input logic [10:0]invOSY ,
					
					// Lrrr inputs
					input logic lrrReq ,
					
					// Bolt inputs
					input logic [3:0] btpReq ,
					input logic [3:0] btiReq ,
					
					
					// Block inputs
					input logic blkReq ;
					input logic [10:0] blkOSX ,
					input logic [10:0} blkOSY ,
					
					
					
					input logic cheatput,
					
					
					
					// Player outputs
					output logic plrExs ,
					output logic plrVer ,
					output logic plrHit ,
					
					// Invader outputs
					output logic [7:0][15:0] invExs ,
					output logic [7:0][15:0] invHit ,
					
					//Lrrr outputs
					output logic lrrExs ,
					output logic lrrVer ,
					output logic lrrHit ,
					
					// Bolt outputs
					output logic [3:0] btpExs ,
					output logic [3:0] btiExs ,
					output logic [10:0] btxLoc ,
					output logic [10:0] btyLoc ,
					
					// Block outputs
					output logic blkExs[3:0][31:0] ,
					output logic blkHit[3:0][31:0] ,
					
					// On screen info 
					output logic stgMsg ,
					output logic scrMsg ,
					output logic edgMsg ,
					output logic [2:0][3:0] scrNum ,
					output logic [2:0] scrLiv ,
					output logic [3:0] sndOut
					
);


const int R_BORDER = 635 ;
const int L_BORDER = 5 ;
const int B_BORDER = 400 ;

int pltLives = 3 ;
int lrrLives = 20 ;
int score = 0 ;
int numOfInv = 128 ; 

enum logic [2:0] {
						StartGame ,
						RegularGame ,
						EndGame 
						}
		prt_st , nxt_st ;

//  calculation x Axis speed 
always_ff @(posedge clk or negedge resetN)
begin : fsm_sync
	if (!resetN)
		prt_st <= StartGame ;
	else
		prt_st <= nxt_st ;
end
	

always_comb

begin
	// default output
	plrExs = 1'b0 ;
	plrVer = 1'b0 ;
	plrHit = 1'b0 ;
	invExs = {128{1'b0}} ;
	invHit = {128{1'b0}} ;
	lrrExs = 1'b0 ;
	lrrVer = 1'b0 ; 
	lrrHit = 1'b0 ;
	btpExs = {4{1'b0}} ;
	btiExs = {4{1'b0}} ;
	btxLoc = {11{1'b0}} ;
	btyLoc = {11{1'b0}} ;
	blkExs =	{128{1'b0}} ;
	blkHit =	{128{1'b0}} ;
	stgMsg = 1'b0 ;
	scrMsg = 1'b0 ;
	edgMsg = 1'b0 ;
	scrNum = {12{1'b0}} ;
	scrLiv = {3{1'b0}} ;
	sndOut = {3{1'b0}} ;
	nxt_st = prt_st ;
	
	case (prt_st)
	
		StartGame : begin
			stgMsg = 1'b1 ;
			if (spcKey == 1'b1)
				nxt_st = RegularGame ;
		end
			
		RegularGame : begin
			// Player hit detection
			
			// Invader hit detection, border hit and start moving
			
			// Lrrr hit detection and manifestation
			
			// Player shooting detection
			
			// Invader shooting randomly
			
			// Block hit detection 
			
			if (numOfInv == 0 || cheatput == 1'b1)
				nxt_st = EndGame ;

		end
		
		EndGame : begin
			edgMsg = 1'b1 ;
			if (spcKey == 1;b1)
				nxt_st = StartGame;

		end 
			
	endcase
end




//always_ff@(posedge clk or negedge resetN)
//begin
//	if(!resetN)	
//		
//	//else 
//	//begin 
//	
//		
//	//end
//end 
endmodule 
