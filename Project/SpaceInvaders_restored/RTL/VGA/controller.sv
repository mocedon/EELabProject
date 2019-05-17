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
					
					input logic cheatput,
					
					
					// Player outputs
					output logic plrExs ,
					output logic plrHit ,
					
					// Invader outputs
					output logic [7:0][15:0] invExs ,
					output logic [7:0][15:0] invHit ,
					
					//Lrrr outputs
					output logic lrrExs ,
					output logic lrrHit ,
					
					// Bolt outputs
					output logic [3:0] btpExs ,
					output logic [3:0] btiExs ,
					
					// On screen info 
					output logic stgMsg ,
					output logic scrMSG ,
					output logic edgMsg ,
					output logic [9:0] scrNum ,
					output logic [2:0] scrLiv 
					
);


const int R_BORDER = 635 ;
const int L_BORDER = 5 ;
const int B_BORDER = 400 ;

int pltLives = 3 ;
int lrrLives = 20 ;


always_ff@(posedge clk or negedge resetN)
begin
	//if(!resetN)	6
		
	//else 
	//begin 
	
		
	//end
end 
endmodule 
