module	MonsterBitMap	(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] offsetX,// offset from top left  position 
					input logic	[10:0] offsetY,
					input	logic	InsideRectangle, //input that the pixel is within a bracket 
					input logic	[7:0][15:0] mat,
					
					
					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout  //rgb value from the bitmap 
);							
localparam  int OBJECT_WIDTH_X = 32;
localparam  int OBJECT_HEIGHT_Y = 32;
localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 						 

logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors = {
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h69, 8'h69, 8'h69, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h69, 8'h85, 8'hA9, 8'hC9, 8'hC9, 8'hC9, 8'hA9, 8'h85, 8'h64, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h85, 8'hC9, 8'hED, 8'hED, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hC9, 8'h89, 8'h45, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h49, 8'hA9, 8'hED, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hC9, 8'hA9, 8'h45, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h89, 8'hED, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hC9, 8'h85, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h65, 8'hED, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hC9, 8'hA9, 8'h69, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h69, 8'hC9, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hC9, 8'hC9, 8'h69, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h85, 8'hED, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hC9, 8'hC9, 8'h65, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'hC9, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hC9, 8'hC9, 8'h64, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h69, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hC9, 8'hC9, 8'h69, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h89, 8'hED, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hC9, 8'hC9, 8'h69, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h65, 8'hC9, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hC9, 8'hA9, 8'h69, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h45, 8'hC9, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hC9, 8'hC9, 8'hA9, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h49, 8'hA9, 8'hED, 8'hED, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hED, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hC9, 8'hC9, 8'h85, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h65, 8'hC9, 8'hA9, 8'hA9, 8'hA9, 8'hA9, 8'hA9, 8'hC9, 8'h89, 8'hC9, 8'hA9, 8'hA9, 8'hA9, 8'hC9, 8'hED, 8'hA9, 8'hC9, 8'hC9, 8'hC9, 8'h65, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h49, 8'h72, 8'h24, 8'h6D, 8'h96, 8'h72, 8'h69, 8'hC9, 8'h49, 8'h72, 8'h92, 8'h29, 8'h49, 8'h6D, 8'h69, 8'h89, 8'hC9, 8'hC9, 8'hC9, 8'h65, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h4D, 8'hBF, 8'hBB, 8'hBF, 8'hBF, 8'hBF, 8'h6D, 8'hC9, 8'h69, 8'hBF, 8'hDF, 8'hBF, 8'hBF, 8'hE3, 8'h76, 8'h89, 8'hED, 8'hC9, 8'hA9, 8'h69, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'hBB, 8'hBF, 8'hBF, 8'h72, 8'h89, 8'hED, 8'hA9, 8'h69, 8'h96, 8'hBB, 8'hBB, 8'h96, 8'h69, 8'hC9, 8'hCD, 8'hC9, 8'hC9, 8'h69, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h45, 8'h6D, 8'h49, 8'h89, 8'hCD, 8'hCD, 8'hED, 8'hC9, 8'h85, 8'h65, 8'h89, 8'h89, 8'hC9, 8'hCD, 8'hCD, 8'hC9, 8'hC9, 8'h69, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h69, 8'h64, 8'hA9, 8'hED, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hA9, 8'h89, 8'h89, 8'h89, 8'hA9, 8'hCD, 8'hCD, 8'hC9, 8'hC9, 8'h65, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h49, 8'hA9, 8'hED, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hED, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hC9, 8'hC9, 8'h64, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h8D, 8'hA9, 8'hED, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hED, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hC9, 8'hC9, 8'h85, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h69, 8'hC9, 8'hA9, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hA9, 8'hA9, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hC9, 8'h89, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h69, 8'hA9, 8'hA9, 8'hCD, 8'h89, 8'hCD, 8'hC9, 8'hA9, 8'hED, 8'hA9, 8'h00, 8'h00, 8'h64, 8'hED, 8'hCD, 8'hCD, 8'hCD, 8'hC9, 8'hA9, 8'h69, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h89, 8'h89, 8'hC9, 8'hC9, 8'h89, 8'hED, 8'hA9, 8'hA9, 8'hED, 8'h44, 8'h20, 8'h44, 8'h85, 8'hED, 8'hCD, 8'hCD, 8'hCD, 8'hC9, 8'hA9, 8'h69, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'hC9, 8'h89, 8'hCD, 8'hA9, 8'h89, 8'hED, 8'hA9, 8'hA9, 8'hED, 8'h65, 8'hA9, 8'hCD, 8'hED, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hC9, 8'hA9, 8'h69, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h85, 8'hED, 8'h85, 8'hCD, 8'h89, 8'hA9, 8'hED, 8'h89, 8'hA9, 8'hCD, 8'h65, 8'hA9, 8'hC9, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hC9, 8'h69, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h49, 8'hA9, 8'h89, 8'h89, 8'hED, 8'h89, 8'hC9, 8'hED, 8'h89, 8'hC9, 8'hC9, 8'h65, 8'hA9, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hA9, 8'h49, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h85, 8'hC9, 8'h64, 8'hC9, 8'hCD, 8'h65, 8'hED, 8'hA9, 8'h85, 8'hC9, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hED, 8'hC9, 8'h64, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h69, 8'h49, 8'h65, 8'h64, 8'h64, 8'h89, 8'h64, 8'hA9, 8'hC9, 8'hCD, 8'hCD, 8'hCD, 8'hED, 8'hED, 8'hA9, 8'h65, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h64, 8'h85, 8'hA9, 8'hC9, 8'hCD, 8'hED, 8'hCD, 8'hC9, 8'hA9, 8'h69, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h45, 8'h64, 8'h64, 8'h44, 8'h69, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF }
};


// pipeline (ff) to get the pixel color from the array 	 
																   											   
always_ff@(posedge clk or negedge resetN)
begin
		if(!resetN) begin
			RGBout <=	8'h00;
		end
		else begin
		if (InsideRectangle == 1'b1&& mat[offsetY>>5][offsetX>>5]==1'b1)  // inside an external bracket 
			RGBout <= object_colors[offsetY][offsetX];	//get RGB from the colors table  
		else 
			RGBout <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
	end 
end
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   

endmodule