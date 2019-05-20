module	BossBitMap	(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] offsetX,// offset from top left  position 
					input logic	[10:0] offsetY,
					input	logic	InsideRectangle, //input that the pixel is within a bracket 

					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout  //rgb value from the bitmap 
);	
// generating a bolt bitmap 						
localparam  int OBJECT_WIDTH_X = 32;
localparam  int OBJECT_HEIGHT_Y = 32;
localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 						 

logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors = {
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hB6, 8'hFF, 8'hFF, 8'h6D, 8'h6D, 8'hFF, 8'hFF, 8'hDB, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h44, 8'hB2, 8'h92, 8'h44, 8'h44, 8'h92, 8'hFF, 8'h6D, 8'h44, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h44, 8'h48, 8'h68, 8'h68, 8'h88, 8'h69, 8'h69, 8'h64, 8'h44, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h44, 8'h68, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h68, 8'h68, 8'h44, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDA, 8'hB6, 8'hB6, 8'h6D, 8'h68, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h68, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h6E, 8'h49, 8'h29, 8'h25, 8'h48, 8'h8C, 8'h8C, 8'h8C, 8'hB0, 8'hD5, 8'hB0, 8'h8C, 8'hB0, 8'hD5, 8'h6C, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h6D, 8'h29, 8'h29, 8'h29, 8'h48, 8'h8C, 8'h8C, 8'h8C, 8'hB0, 8'hF5, 8'hF9, 8'hB5, 8'hD1, 8'hF5, 8'hD5, 8'hB1, 8'h49, 8'h92, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDA, 8'h29, 8'h25, 8'h29, 8'h25, 8'h68, 8'hAC, 8'h8C, 8'h8C, 8'hD5, 8'hF9, 8'hD5, 8'h6C, 8'hF9, 8'hF9, 8'h90, 8'hB1, 8'hB1, 8'h05, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6E, 8'h29, 8'h25, 8'h04, 8'h44, 8'h8C, 8'h8C, 8'h8C, 8'hB0, 8'hF9, 8'hD5, 8'hB1, 8'hD5, 8'hF5, 8'hD5, 8'hB5, 8'h6D, 8'h25, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h29, 8'h2E, 8'h2A, 8'h25, 8'h88, 8'h8C, 8'h8C, 8'h8C, 8'hAC, 8'hD5, 8'hB0, 8'h8C, 8'hB0, 8'hD5, 8'h8C, 8'h49, 8'h72, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h92, 8'h29, 8'h4E, 8'h2A, 8'h48, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h91, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h92, 8'h49, 8'h4E, 8'h25, 8'h8C, 8'hB0, 8'h8C, 8'hB0, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h48, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h29, 8'h4A, 8'h2A, 8'h48, 8'h8C, 8'h8C, 8'hB0, 8'h68, 8'h8C, 8'h8C, 8'h8C, 8'h48, 8'h6D, 8'h49, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h6E, 8'h29, 8'h4E, 8'h4A, 8'h4A, 8'h29, 8'h48, 8'h68, 8'h8C, 8'h8C, 8'h8C, 8'h68, 8'h48, 8'h29, 8'h2A, 8'h29, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h92, 8'h29, 8'h69, 8'h6D, 8'h4E, 8'h4A, 8'h4A, 8'h29, 8'h48, 8'h48, 8'h48, 8'h48, 8'h48, 8'h28, 8'h29, 8'h4D, 8'h6D, 8'h49, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6E, 8'h48, 8'h8C, 8'h8C, 8'h6C, 8'h6D, 8'h69, 8'h68, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h6C, 8'h8C, 8'h8C, 8'h8C, 8'h68, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h29, 8'h68, 8'h8C, 8'h8C, 8'h8C, 8'h68, 8'h68, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h88, 8'h68, 8'h68, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h25, 8'h68, 8'h8C, 8'h8C, 8'h68, 8'h44, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h68, 8'h48, 8'h8C, 8'h48, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h29, 8'h48, 8'h8C, 8'h8C, 8'h8C, 8'h44, 8'h68, 8'h8C, 8'h8C, 8'h68, 8'h68, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h44, 8'h68, 8'h68, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h25, 8'h68, 8'h88, 8'h8C, 8'h68, 8'h44, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h44, 8'h8C, 8'h88, 8'h49, 8'hDF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h29, 8'h44, 8'h8C, 8'h8C, 8'h8C, 8'h48, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h68, 8'h44, 8'h8C, 8'h8C, 8'h48, 8'hDA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h92, 8'h29, 8'h48, 8'h8C, 8'h8C, 8'h68, 8'h48, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h44, 8'h8C, 8'h8C, 8'h68, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h49, 8'h25, 8'h8C, 8'h8C, 8'h8C, 8'h68, 8'h44, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h68, 8'h24, 8'h68, 8'h8C, 8'h68, 8'h48, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h4D, 8'h44, 8'h68, 8'h68, 8'h68, 8'h48, 8'h44, 8'h8C, 8'h8C, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h8C, 8'h68, 8'h24, 8'h44, 8'h68, 8'h24, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h49, 8'h29, 8'h25, 8'h44, 8'h44, 8'h24, 8'h68, 8'h8C, 8'h8C, 8'h88, 8'h24, 8'h00, 8'h68, 8'h8C, 8'h8C, 8'h8C, 8'h24, 8'h25, 8'h04, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h49, 8'h29, 8'h29, 8'h29, 8'h44, 8'h8C, 8'h8C, 8'h8C, 8'h69, 8'h4D, 8'h24, 8'h8C, 8'h8C, 8'h8C, 8'h48, 8'h6D, 8'h92, 8'h49, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h92, 8'h49, 8'h48, 8'h8C, 8'h8C, 8'h68, 8'h69, 8'h6D, 8'h68, 8'h8C, 8'h8C, 8'h8C, 8'h68, 8'h48, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h48, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h68, 8'h68, 8'h48, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h68, 8'h44, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h91, 8'h68, 8'h88, 8'h8C, 8'h8C, 8'h8C, 8'h48, 8'h48, 8'h48, 8'h68, 8'h68, 8'h68, 8'h48, 8'h91, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h92, 8'h69, 8'h44, 8'h44, 8'h44, 8'h69, 8'hDB, 8'hB6, 8'h92, 8'h92, 8'h92, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hDF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF }
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
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   

endmodule
