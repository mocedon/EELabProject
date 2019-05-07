//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 



module	boxBitMap	(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] offsetX,// offset from top left  position 
					input logic	[10:0] offsetY,
					input	logic	InsideRectangle, //input that the pixel is within a bracket 

					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout  //rgb value from the bitmap 
);
// generating a smiley bitmap 

localparam  int OBJECT_WIDTH_X = 8;
localparam  int OBJECT_HEIGHT_Y = 16;

localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 

logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [7:0] object_colors = {
{8'h7B, 8'h7B, 8'h7B, 8'h7B, 8'h7B, 8'h7B, 8'h7B, 8'h7B},
{8'h7B, 8'h7B, 8'h7B, 8'h7B, 8'h7B, 8'h7B, 8'h7B, 8'h7B},
{8'h7B, 8'h7B, 8'h7B, 8'h7B, 8'h7B, 8'h7B, 8'h7B, 8'h7B},
{8'h7B, 8'h7B, 8'h7B, 8'h7B, 8'h7B, 8'h7B, 8'h7B, 8'h7B},
{8'h7B, 8'h7B, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h7B, 8'h7B},
{8'h7B, 8'h7B, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h7B, 8'h7B},
{8'h7B, 8'h7B, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h7B, 8'h7B},
{8'h7B, 8'h7B, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h7B, 8'h7B},
{8'h7B, 8'h7B, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h7B, 8'h7B},
{8'h7B, 8'h7B, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h7B, 8'h7B},
{8'h7B, 8'h7B, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h7B, 8'h7B},
{8'h7B, 8'h7B, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h7B, 8'h7B},
{8'h7B, 8'h7B, 8'h7B, 8'h7B, 8'h7B, 8'h7B, 8'h7B, 8'h7B},
{8'h7B, 8'h7B, 8'h7B, 8'h7B, 8'h7B, 8'h7B, 8'h7B, 8'h7B},
{8'h7B, 8'h7B, 8'h7B, 8'h7B, 8'h7B, 8'h7B, 8'h7B, 8'h7B},
{8'h7B, 8'h7B, 8'h7B, 8'h7B, 8'h7B, 8'h7B, 8'h7B, 8'h7B},
};

// pipeline (ff) to get the pixel color from the array 	 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=	8'h00;
	end
	else begin
		if (InsideRectangle == 1'b1 )  // inside an external bracket 
			RGBout <= object_colors[offsetY >> 1][offsetX >> 1];	//get RGB from the colors table  
		else 
			RGBout <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
	end 
end

// decide if to draw the pixel or not 
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   

endmodule