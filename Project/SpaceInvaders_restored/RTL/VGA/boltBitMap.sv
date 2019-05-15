

module	boltBitMap	(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[3:0][10:0] offsetX,// offset from top left  position 
					input logic	[3:0][10:0] offsetY,
					input	logic	[3:0]inRect, //input that the pixel is within a bracket 
					input logic blType,

					output	logic	drwReq, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout  //rgb value from the bitmap 
);
// generating a smiley bitmap 

localparam  int OBJECT_WIDTH_X = 4;
localparam  int OBJECT_HEIGHT_Y = 16;

localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 
int bitMapChoose ;
int boltNum ;

logic [0:1][0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [7:0] object_colors = {
{
{8'h7B, 8'h7B, 8'h7B, 8'h7B},
{8'h7B, 8'h7B, 8'h7B, 8'h7B},
{8'h7B, 8'h7B, 8'h7B, 8'h7B},
{8'h7B, 8'h7B, 8'h7B, 8'h7B},
{8'h7B, 8'hFF, 8'hFF, 8'h7B},
{8'h7B, 8'hFF, 8'hFF, 8'h7B},
{8'h7B, 8'hFF, 8'hFF, 8'h7B},
{8'h7B, 8'hFF, 8'hFF, 8'h7B},
{8'h7B, 8'hFF, 8'hFF, 8'h7B},
{8'h7B, 8'hFF, 8'hFF, 8'h7B},
{8'h7B, 8'hFF, 8'hFF, 8'h7B},
{8'h7B, 8'hFF, 8'hFF, 8'h7B},
{8'h7B, 8'h7B, 8'h7B, 8'h7B},
{8'h7B, 8'h7B, 8'h7B, 8'h7B},
{8'h7B, 8'h7B, 8'h7B, 8'h7B},
{8'h7B, 8'h7B, 8'h7B, 8'h7B},
}  
,
{
{8'hBB, 8'hBB, 8'hBB, 8'hBB},
{8'hBB, 8'hBB, 8'hBB, 8'hBB},
{8'hBB, 8'hBB, 8'hBB, 8'hBB},
{8'hBB, 8'hBB, 8'hBB, 8'hBB},
{8'hBB, 8'hFF, 8'hFF, 8'hBB},
{8'hBB, 8'hFF, 8'hFF, 8'hBB},
{8'hBB, 8'hFF, 8'hFF, 8'hBB},
{8'hBB, 8'hFF, 8'hFF, 8'hBB},
{8'hBB, 8'hFF, 8'hFF, 8'hBB},
{8'hBB, 8'hFF, 8'hFF, 8'hBB},
{8'hBB, 8'hFF, 8'hFF, 8'hBB},
{8'hBB, 8'hFF, 8'hFF, 8'hBB},
{8'hBB, 8'hBB, 8'hBB, 8'hBB},
{8'hBB, 8'hBB, 8'hBB, 8'hBB},
{8'hBB, 8'hBB, 8'hBB, 8'hBB},
{8'hBB, 8'hBB, 8'hBB, 8'hBB},
}
};

// pipeline (ff) to get the pixel color from the array 	 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=	8'h00;
	end
	else begin
		bitMapChoose <= int'(blType) ;
		boltNum <= ((int'(inRect[0])) + (2 * int'(inRect[0])) + (3 * int'(inRect[0])) + (4 * int'(inRect[0]))) ;
		if (inRect == 1'b1)  // inside an external bracket 
			RGBout <= object_colors[bitMapChoose][offsetY[boltNum]][offsetX[boltNum]];	//get RGB from the colors table  
		else 
			RGBout <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
	end 
end

// decide if to draw the pixel or not 
assign drwReq = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   

endmodule