module	controller (	
					
					// General inputs
					input logic clk ,
					input logic resetN,
					
					input logic spcKey ,
					input logic oneSec ,
					input logic [6:0] rndNum ,
					
					input logic srtFrm ,
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

					input logic blkReq,
					input logic [10:0] blkOSX ,
					input logic [10:0] blkOSY ,
					
					// On screen info
					input logic stgReq,
					input logic scrReq,
					input logic edgReq,
					
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
					output logic [3:0][31:0] blkExs ,
					output logic [3:0][31:0] blkHit ,
					
					// On screen info 
					output logic stgMsg ,
					output logic scrMsg ,
					output logic edgMsg ,
					output logic [9:0] scrNum ,
					output logic [1:0] scrLiv ,
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


int plrLiv = 3   ;
int lrrLiv = 20  ;
int invLiv = 128 ;

int pScore = 0   ;
 
logic prvKey ;
logic btpCmd ;
logic btiCmd ;
logic btiUpd ;

logic plrDwn ;
logic lrrDwn ;
logic invDwn ;
logic scrInc ;

logic invNew ;
//logic blkNew ;

logic	plrDwnT ;
logic	invDwnT ;
logic	lrrDwnT ;
logic scrIncT ;
logic	[BOLT_MAX-1:0] btpExsT ;
logic	[BOLT_MAX-1:0] btiExsT ;


enum logic [2:0] {
						StartGame ,
						InitGame ,
						RegularGame ,
						EndGame 
						}
		prt_st , nxt_st ;

always_ff @(posedge clk or negedge resetN)
begin : fsm_sync
	if (!resetN) begin
		prt_st <= StartGame ;
		invExs = 128'h0 ;
		invHit = 128'h0 ;
		blkExs = 128'h0 ;
		blkHit = 128'h0 ;
		
		plrLiv = 3   ;
		lrrLiv = 20  ;
		invLiv = 128 ;
		pScore = 0   ;
	end
	else begin
	
		pixX = pixelX ;
		pixY = pixelY ;
		invX = invOSX>>5  ;
		invY = invOSY>>5  ;
//		blkX = blkOSX  ;
//		blkY = blkOSY  ;
		invI = rndNum>>4  ;
		invJ = rndNum % 16 ;
			
		prvKey = spcKey ;
		
		if (scrInc == 1'b1)
			scrIncT <= scrInc ;

		if (plrDwn == 1'b1)
			plrDwnT <= plrDwn ;
			
		if (lrrDwn == 1'b1)
			lrrDwnT <= lrrDwn ;
			
		if (invDwn == 1'b1) begin
			invDwnT <= invDwn ;
			invExs[invY][invX] <= 1'b0 ;
			invHit[invY][invX] <= 1'b1 ;
		end
			
			btpExsT <= btpExs ;
			btiExsT <= btiExs ;
		
		if (srtFrm == 1'b1) begin
			if (scrIncT == 1'b1) 
				pScore <= pScore + 5 ;
			
			if (plrDwnT == 1'b1)
				plrLiv <= plrLiv - 1 ;
			
			if (lrrDwnT == 1'b1)
				lrrLiv <= lrrLiv - 1 ;
			
			if (invDwnT == 1'b1)
				invLiv <= invLiv - 1 ;
			
			plrDwnT <= 1'b0 ;
			lrrDwnT <= 1'b0 ;
			invDwnT <= 1'b0 ;
			scrIncT <= 1'b0 ;
			
		end
	
		if (invNew == 1'b1)
			invExs <= {{128{1'b1}}} ;
			
//		if (blkNew == 1'b1)
//			blkExs <= {{128{1'b1}}} ;
			
			
		if (btiUpd == 1'b1) begin
			btxLoc <= pixX + (invJ<<5) ;
			btyLoc <= pixY + (invI<<5) ;
		end			
					
		prt_st <= nxt_st ;
	end
end
	

always_comb

begin
	// default output
	plrHit = 1'b0 ;
	plrDwn = 1'b0 ;
	plrExs = 1'b0 ;
	invStr = 1'b0 ;
	invChg = 1'b0 ;
	invDwn = 1'b0 ;
	invNew = 1'b0 ;
	lrrHit = 1'b0 ;
	lrrDwn = 1'b0 ;
	lrrExs = 1'b0 ;
//	blkNew = 1'b0 ;
	btpExs = 4'h0 ;
	btpCmd = 1'b0 ;
	btiExs = 4'h0 ;
	btiCmd = 1'b0 ;
	btiUpd = 1'b0 ;
	stgMsg = 1'b0 ;
	scrMsg = 1'b0 ;
	scrInc = 1'b0 ;
	edgMsg = 1'b0 ;
	sndOut = 4'b0000 ;
	scrLiv = 2'h0 ;
	scrNum = 12'h0 ;
	
	nxt_st = prt_st ;
	
	case (prt_st)
	

	
		StartGame : begin
			if (stgReq == 1'b1)
				stgMsg = 1'b1 ;
			
			if (spcKey == 1'b1) begin
//				sndOut = 4'd7;
//				#100;
//				sndOut = 4'd7;
//				#100;
//				sndOut = 4'd2;
//				#100;
//				sndOut = 4'd3;
//				#100;
//				sndOut = 4'd9;
//				#100;
//				sndOut = 4'd9;
//				#100;
//				sndOut = 4'd5;
//				#100;
//				sndOut = 4'd7;
//				#100;
				nxt_st = InitGame ;
			end
		end
		
		
		InitGame : begin 
			invNew = 1'b1 ;
//			blkNew = 1'b1 ;
			if (oneSec == 1'b1)
				nxt_st = RegularGame ;
		end
		
			
		RegularGame : begin
			if (plrReq == 1'b1)
				plrExs = 1'b1 ;
			if (scrReq == 1'b1)
				scrMsg = 1'b1 ;
			invStr = 1'b1 ;
			scrNum = pScore ;
			scrLiv = plrLiv ;

			
		// Player shooting detection
			if (spcKey == 1'b1 && prvKey == 1'b0)
				btpCmd = 1'b1 ;
				
			for (int i = 0 ; i < BOLT_MAX ; i++) begin
				if (btpCmd == 1'b1 && btpExs[i] == 1'b0)begin
					btpExs[i] = 1'b1 ;
					btpCmd = 1'b0 ;
				end
				
				if (btpExsT[i] == 1'b1)
					btpExs[i] = 1'b1 ;
					
				if (btpReq[i] == 1'b1 && pixY == T_BORDER)
					btpExs[i] = 1'b0 ;
					
			end
			
				
				
		// Invader shooting randomly
			if (invExs[invI][invJ] == 1'b1)
					btiCmd = 1'b1 ;
					
			for (int i = 0 ; i < BOLT_MAX ; i++) begin	
				if (btiCmd == 1'b1 && btiExs[i] == 1'b0) begin
					btiExs[i] = 1'b1 ;
					btiCmd = 1'b0 ;
					btiUpd = 1'b1 ; //Check if needed to be piped
				end
				
				if (btiExsT[i] == 1'b1)
					btiExs[i] = 1'b1 ;
					
				if (btiReq[i] == 1'b1 && pixY == B_BORDER)
					btiExs[i] = 1'b0 ;
					
			end
				

			
		// Player hit detection
			for (int i = 0 ; i < BOLT_MAX ; i++) begin
				if(plrReq == 1'b1 && btiReq[i]) begin
					plrDwn = 1'b1 ;
					plrHit = 1'b1 ;
					btiExs[i] = 1'b0 ;
				end
				
			end
				
			if (plrReq == 1'b1 && lrrReq == 1'b1) begin
				plrDwn = 1'b1 ;
				plrHit = 1'b1 ;
				lrrHit = 1'b1 ;
				
			end


				
			
		// Invader hit detection, border hit and
			for (int i = 0 ; i < BOLT_MAX ; i++) begin
				if(invReq == 1'b1 && btpReq[i]) begin
					invDwn = 1'b1 ;
					btpExs[i] = 1'b0 ;
					scrInc = 1'b1 ;
				end
			end		
			
			if (invReq == 1'b1 && pixX == R_BORDER)
				invChg = 1'b1 ;
			
			if (invReq == 1'b1 && pixY == F_BORDER)
				nxt_st = EndGame ;
			
				
				
		// Lrrr hit detection and manifestation
			if (invLiv < 64 && lrrReq == 1'b1)
				lrrExs = 1'b1 ;
				
			if (lrrLiv <= 0)
				lrrExs = 1'b0 ;
			
			for (int i = 0 ; i < BOLT_MAX ; i++) begin
				if(lrrReq == 1'b1 && btpReq[i]) begin
					lrrDwn = 1'b1 ;
					lrrHit = 1'b1 ;
					btpExs[i] = 1'b0 ;
					scrInc = 1'b1 ;
					
				end
			end		
		
			
			
		// Block hit detection 
			
		// End game conditions
			if (invLiv == 0 || plrLiv == 0 || cheatput == 1'b1)
				nxt_st = EndGame ;

		end
		
		EndGame : begin
			if (edgReq == 1'b1)
				edgMsg = 1'b1 ;
			invStr = 1'b0 ;
			scrNum = pScore ;

		end 
			
	endcase
end



endmodule 
