module	controller (	
					
					// General inputs
					input logic clk ,
					input logic resetN,
					
					input logic spcKey ,
					input logic oneSec ,
					input logic [6:0] rndNum ,
					
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
					input logic [BOLT_MAX - 1:0] btpReq ,
					input logic [BOLT_MAX - 1:0] btiReq ,
					
					
					// Block inputs
					input logic blkReq ,
					input logic [10:0] blkOSX ,
					input logic [10:0] blkOSY ,
					
					
					
					input logic cheatput,
					
					
					
					// Player outputs
					output logic plrExs ,
					output logic plrHit ,
					
					// Invader outputs
					output logic invStr ,
					output logic invChg ,
					output logic [7:0][15:0] invExs ,
					output logic [7:0][15:0] invHit ,
					
					//Lrrr outputs
					output logic lrrExs ,
					output logic lrrHit ,
					
					// Bolt outputs
					output logic [BOLT_MAX - 1:0] btpExs ,
					output logic [BOLT_MAX - 1:0] btiExs ,
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

parameter int BOLT_MAX = 4 ;

const int R_BORDER = 635 ;
const int L_BORDER = 5 ;
const int F_BORDER = 400 ;
const int T_BORDER = 5 ;
const int B_BORDER = 465 ;

int pixX , pixY ;
int invX , invY ;
int blkX , blkY ;
int invI , invJ ;


int plrLiv = 3   , prvPlv = 3   ;
int lrrLiv = 20  , prvLlv = 20  ;
int invLiv = 128 , prvIlv = 128 ;

int pScore = 0   , prvScr = 0   ;
 

logic btpCmd ;
logic btiCmd ;

enum logic [2:0] {
						StartGame ,
						InitGame ,
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
		prvPlv = plrLiv ;
		prvLlv = lrrLiv ;
		prvIlv = invLiv ;
		prt_st <= nxt_st ;
end
	

always_comb

begin
	// default output
	plrHit = 1'b0 ;
	invChg = 1'b0 ;
	invHit = {128{1'b0}} ;
	lrrHit = 1'b0 ;
	blkHit =	{128{1'b0}} ;
	stgMsg = 1'b0 ;
	scrMsg = 1'b0 ;
	edgMsg = 1'b0 ;
	sndOut = {3{1'b0}} ;
	
	nxt_st = prt_st ;
	
	case (prt_st)
	
		StartGame : begin
		
			stgMsg = 1'b1 ;
			if (spcKey == 1'b1)
				nxt_st = InitGame ;
		end
		
		
		InitGame : begin 
			plrExs = 1'b1 ;
			invStr = 1'b1 ;
			btpCmd = 1'b0 ;
			btiCmd = 1'b0 ;
			invExs = {128{1'b1}} ;
			blkExs = {128{1'b1}} ;
			nxt_st = RegularGame ;
		end
		
			
		RegularGame : begin
			scrMsg = 1'b1 ;
			scrNum = pScore ;
			scrLiv = plrLiv ;
			
			pixX = int'(pixelX) ;
			pixY = int'(pixelY) ;
			invX = int'(invOSX) >> 5 ;
			invY = int'(invOSY) >> 5 ;
			invX = int'(blkOSX) >> 3 ;
			invY = int'(blkOSY) >> 3 ;
			
		// Player hit detection
			for (int i = 0 ; i < BOLT_MAX ; i++) begin
				if(plrReq == 1'b1 && btiReq[i]) begin
					plrLiv = prvPlv - 1;
					plrHit = 1'b1 ;
					btiExs[i] = 1'b0 ;
					
				end
			end
				
			if (plrReq == 1'b1 && lrrReq == 1'b1) begin
				plrLiv = prvPlv ;
				plrHit = 1'b1 ;
				lrrHit = 1'b1 ;
				
			end
				
				
		// Invader hit detection, border hit and
			for (int i = 0 ; i < BOLT_MAX ; i++) begin
				if(invReq == 1'b1 && btpReq[i]) begin
					invLiv = prvIlv - 1 ;
					invHit[invY][invX] = 1'b1 ;
					invExs[invY][invX] = 1'b0 ;
					btpExs[i] = 1'b0 ;
					pScore = prvScr + 5 ;
					
				end
			end		
			if (invReq == 1'b1 && pixX == R_BORDER)
				invChg = 1'b1 ;
			if (invReq == 1'b1 && pixX == L_BORDER)
				invChg = 1'b1 ;
			if (invReq == 1'b1 && pixY == F_BORDER)
				plrLiv = 0 ;
			
				
				
		// Lrrr hit detection and manifestation
			if (invLiv < 32)
				lrrExs = 1'b1 ;
				
			if (lrrLiv == 0)
				lrrExs = 1'b0 ;
			
			for (int i = 0 ; i < BOLT_MAX ; i++) begin
				if(lrrReq == 1'b1 && btpReq[i]) begin
					lrrLiv = prvLlv - 1 ;
					lrrHit = 1'b1 ;
					
					btpExs[i] = 1'b0 ;
					pScore = prvScr + 5 ;
					
				end
			end		
			
		// Player shooting detection
			if (spcKey == 1'b1)
				btpCmd = 1'b1 ;
			for (int i = 0 ; i < BOLT_MAX ; i++) begin
				if (btpReq[i] == 1'b1 && pixY == T_BORDER)
					btpExs[i] = 1'b0 ;
				if (btpCmd == 1'b1 && btpExs[i] == 1'b0) begin
					btpExs[i] = 1'b1 ;
					btpCmd = 1'b0 ;
				end
			end
			btpCmd = 1'b0 ;
				
				
		// Invader shooting randomly
			invI = rndNum >> 4 ;
			invJ = rndNum % 16 ;
			if (invExs[invI][invJ] == 1'b1)
					btiCmd = 1'b1 ;
			for (int i = 0 ; i < BOLT_MAX ; i++) begin
				if (btiReq[i] == 1'b1 && pixY == B_BORDER)
					btiExs[i] = 1'b0 ;
				if (btiCmd == 1'b1 && btiExs[i] == 1'b0) begin
					btiExs[i] = 1'b1 ;
					btpCmd = 1'b0 ;
				end
			end
			btiCmd = 1'b0 ;
			
			
		// Block hit detection 
			
		// ENd game conditions
			if (invLiv == 0 || plrLiv == 0 || cheatput == 1'b1)
				nxt_st = EndGame ;

		end
		
		EndGame : begin
			edgMsg = 1'b1 ;

		end 
			
	endcase
end



endmodule 
