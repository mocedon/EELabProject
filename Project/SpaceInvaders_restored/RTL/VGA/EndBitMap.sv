module	GameoverBitMap	(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] offsetX,// offset from top left  position 
					input logic	[10:0] offsetY,
					input	logic	InsideRectangle, //input that the pixel is within a bracket 
					input		logic [2:0] lives,

					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout  //rgb value from the bitmap 
					
);	
// generating a bolt bitmap 						
localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 
localparam  int OBJECT_WIDTH_X = 32;
localparam  int OBJECT_HEIGHT_Y = 32;

logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors = {
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN },
{8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN },
{8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN },
{8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN },
{8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hNaN, 8'hNaN, 8'hFF, 8'hFF, 8'hFF, 8'hNaN, 8'hNaN, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hNaN, 8'hNaN, 8'hNaN, 8'hFF, 8'hFF, 8'hFF, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN },
{8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hNaN, 8'hNaN, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hFF, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN },
{8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN },
{8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN },
{8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN },
{8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hFF, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN },
{8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hFF, 8'hFF, 8'hFF, 8'hNaN, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hNaN, 8'hNaN, 8'hFF, 8'hNaN, 8'hNaN, 8'hFF, 8'hNaN, 8'hNaN, 8'hFF, 8'hFF, 8'hFF, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN },
{8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN },
{8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN },
{8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hFF, 8'hFF, 8'hFF, 8'hNaN, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hNaN, 8'hNaN, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN },
{8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hFF, 8'hNaN, 8'hNaN, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN },
{8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hNaN, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hNaN, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN },
{8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN },
{8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hNaN, 8'hNaN, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN },
{8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hNaN, 8'hNaN, 8'hFF, 8'hFF, 8'hFF, 8'hNaN, 8'hNaN, 8'hFF, 8'hFF, 8'hFF, 8'hNaN, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hNaN, 8'hFF, 8'hFF, 8'hFF, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN },
{8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hFF, 8'hFF, 8'hFF, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hFF, 8'hNaN, 8'hNaN, 8'hNaN, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hNaN, 8'hNaN, 8'hFF, 8'hFF, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN },
{8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN },
{8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN },
{8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN },
{8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN, 8'hNaN },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF }
};

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=	8'h00;
	end
	else begin
	// we might have to use for iterating over lives0:2 rather than the following
		if (InsideRectangle == 1'b1&& lives[int'(offsetX/3)]==1'b1)  // inside an external bracket 
			RGBout <= life_colors[offsetY][offsetX];	//get RGB from the colors table  
		else 
			RGBout <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
		end 
	end 
end
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   

endmodule


