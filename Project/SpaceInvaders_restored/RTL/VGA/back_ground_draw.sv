

module	back_ground_draw	(	

					input	logic	clk,
					input	logic	resetN,
					input 	logic	[10:0]	pixelX,
					input 	logic	[10:0]	pixelY,

					output	logic	[7:0]	BG_RGB
);

const int	xFrameSize	=	639;
const int	yFrameSize	=	479;
const int	bracketOffset =	10;

logic [2:0] redBits;
logic [2:0] greenBits;
logic [1:0] blueBits;

localparam logic [2:0] DARK_COLOR = 3'b111 ;// bitmap of a dark color
localparam logic [2:0] LIGHT_COLOR = 3'b000 ;// bitmap of a light color


always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
				BG_RGB = 8'hFF ;	 
	end 
	else begin
	
	// defaults 
		BG_RGB = 8'h42 ;
					
			
		if (pixelY <= yFrameSize && pixelY >= 420 ) 
					BG_RGB = 8'hEE ;
				 
		if (pixelY <= 419 && pixelY >= 400 ) 
					BG_RGB = 8'hAE ;
					
		if (pixelY <= 399 && pixelY >= 200 ) 
					BG_RGB = 8'h0E ;
					
		if (pixelY <= 199 && pixelY >= 0 ) 
					BG_RGB = 8'h3E ;
		
	end; 	
end 

endmodule

