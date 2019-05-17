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
localparam  int OBJECT_WIDTH_X = 64;
localparam  int OBJECT_HEIGHT_Y = 64;
localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 						 

logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors = {
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h64, 8'h68, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h91, 8'h64, 8'h68, 8'h64, 8'h69, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h69, 8'h64, 8'h64, 8'h68, 8'h8D, 8'h91, 8'h8D, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h68, 8'h68, 8'h8C, 8'h91, 8'hB6, 8'h8D, 8'h69, 8'h69, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h91, 8'h64, 8'h64, 8'h64, 8'h64, 8'h68, 8'h68, 8'h68, 8'h88, 8'h68, 8'h68, 8'h68, 8'h88, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h64, 8'h69, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD2, 8'hCD, 8'hCD, 8'hC9, 8'hC9, 8'hC8, 8'h64, 8'h64, 8'h68, 8'h68, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h8C, 8'h68, 8'hB1, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD1, 8'hCD, 8'hC9, 8'hC8, 8'hE8, 8'hE8, 8'hE8, 8'hC8, 8'hC8, 8'hC4, 8'hA8, 8'h68, 8'h68, 8'h68, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h8C, 8'h68, 8'hA8, 8'hCD, 8'hCD, 8'hD2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD1, 8'hC8, 8'hE8, 8'hE8, 8'hE8, 8'hC8, 8'hC4, 8'hA4, 8'h84, 8'h84, 8'h80, 8'h80, 8'h60, 8'h68, 8'h8C, 8'h88, 8'h68, 8'h68, 8'h68, 8'h88, 8'h68, 8'h68, 8'h68, 8'h88, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h68, 8'h88, 8'h88, 8'hC8, 8'hE8, 8'hE8, 8'hC8, 8'hC9, 8'hCD, 8'hD6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hC8, 8'hC4, 8'hE8, 8'hC4, 8'hA4, 8'h84, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h64, 8'h6C, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h8C, 8'h8C, 8'h6C, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h6C, 8'h64, 8'h84, 8'hA4, 8'hC4, 8'hE8, 8'hE8, 8'hE8, 8'hC8, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hC8, 8'hC8, 8'hC8, 8'hA4, 8'hA4, 8'hA4, 8'hA4, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h68, 8'h8C, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'hD4, 8'hF8, 8'hF8, 8'h48, 8'h24, 8'hD4, 8'hB4, 8'hB0, 8'hB0, 8'hB0, 8'h48, 8'h48, 8'hD4, 8'hD4, 8'hD4, 8'h84, 8'h80, 8'h80, 8'h80, 8'hA4, 8'hE8, 8'hE8, 8'hC9, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hC9, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'h84, 8'h80, 8'h80, 8'h80, 8'h80, 8'h60, 8'h68, 8'h6C, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h8C, 8'hF8, 8'hF8, 8'h68, 8'h24, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hD8, 8'h68, 8'h68, 8'hF8, 8'hF8, 8'hB4, 8'h64, 8'h80, 8'h80, 8'h84, 8'hC8, 8'hE8, 8'hC9, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hAD, 8'h80, 8'hA4, 8'hA4, 8'hA4, 8'hC8, 8'hE8, 8'h84, 8'h80, 8'h80, 8'h80, 8'h80, 8'h84, 8'h8C, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h68, 8'h8C, 8'hD8, 8'hD4, 8'hB4, 8'hF8, 8'hF8, 8'hD4, 8'hB0, 8'hF8, 8'hD8, 8'hD4, 8'hF8, 8'hD8, 8'h8C, 8'h68, 8'h80, 8'h80, 8'hC4, 8'hE8, 8'hC9, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h80, 8'h80, 8'h80, 8'h80, 8'hA4, 8'hE8, 8'h84, 8'h80, 8'h80, 8'h80, 8'h80, 8'h88, 8'h8C, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h8C, 8'hB0, 8'h8C, 8'h8C, 8'h68, 8'h68, 8'h8C, 8'hB4, 8'hD4, 8'hB0, 8'h8C, 8'h68, 8'h68, 8'h80, 8'hA4, 8'hE8, 8'hC8, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h8D, 8'h80, 8'h80, 8'h80, 8'h84, 8'hE8, 8'hA4, 8'h80, 8'h80, 8'h80, 8'h64, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'hE8, 8'hC8, 8'hD6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h84, 8'h80, 8'h80, 8'h80, 8'hC8, 8'hC8, 8'h80, 8'h80, 8'h64, 8'h6C, 8'h6C, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h8C, 8'h6C, 8'h88, 8'hB1, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h80, 8'h80, 8'h80, 8'h84, 8'hE8, 8'hA4, 8'h64, 8'h6C, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h8D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hAD, 8'h80, 8'h80, 8'h80, 8'hA4, 8'hC8, 8'h88, 8'h6C, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h68, 8'h68, 8'h91, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hAD, 8'h80, 8'h80, 8'h80, 8'hC4, 8'hC8, 8'h68, 8'h6C, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h88, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h6C, 8'h91, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hAD, 8'h80, 8'h80, 8'h84, 8'hC8, 8'hA8, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h88, 8'h68, 8'h88, 8'h68, 8'h68, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h84, 8'h80, 8'h84, 8'hC8, 8'hA8, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'hB5, 8'hD9, 8'hB5, 8'hB0, 8'h8C, 8'h8C, 8'h8C, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h6C, 8'h8C, 8'h8D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h85, 8'h60, 8'h84, 8'hC8, 8'hA8, 8'h88, 8'h6C, 8'h68, 8'h68, 8'h88, 8'h88, 8'h88, 8'h88, 8'h68, 8'hB0, 8'hFD, 8'hFD, 8'hFD, 8'hD9, 8'hFD, 8'hDD, 8'hB5, 8'hB5, 8'hD5, 8'hB5, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h89, 8'h80, 8'h80, 8'h60, 8'h80, 8'hA4, 8'hA8, 8'h88, 8'h68, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h68, 8'hB5, 8'hB5, 8'h8C, 8'h8C, 8'hD9, 8'hB5, 8'h90, 8'hD9, 8'hD9, 8'h8C, 8'h68, 8'h88, 8'h88, 8'h68, 8'h68, 8'hB1, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h84, 8'h80, 8'h80, 8'h80, 8'h80, 8'h64, 8'h29, 8'h29, 8'h49, 8'h48, 8'h68, 8'h8C, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h8C, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h68, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h80, 8'h80, 8'h80, 8'h80, 8'hA4, 8'hC8, 8'h49, 8'h29, 8'h25, 8'h25, 8'h29, 8'h48, 8'h68, 8'h8C, 8'h8C, 8'h68, 8'h88, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h68, 8'h8D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB2, 8'h80, 8'h80, 8'h80, 8'hA4, 8'hC8, 8'hA8, 8'h88, 8'h68, 8'h48, 8'h48, 8'h48, 8'h29, 8'h25, 8'h24, 8'h48, 8'h68, 8'h8C, 8'h8C, 8'h6C, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h6C, 8'h68, 8'h68, 8'h8D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h60, 8'h80, 8'h80, 8'hA4, 8'hC8, 8'h88, 8'h68, 8'h6C, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h48, 8'h24, 8'h25, 8'h24, 8'h48, 8'h68, 8'h68, 8'h88, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h88, 8'h88, 8'h88, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h6C, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h89, 8'h80, 8'h80, 8'hA4, 8'hC8, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h88, 8'h8C, 8'h88, 8'h68, 8'h68, 8'h48, 8'h24, 8'h24, 8'h24, 8'h44, 8'h48, 8'h48, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB2, 8'h80, 8'h80, 8'hA4, 8'hE8, 8'hA8, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h8C, 8'h8C, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h84, 8'h80, 8'h84, 8'hE8, 8'hA8, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h68, 8'h68, 8'h88, 8'h68, 8'h68, 8'h68, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h68, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h91, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB2, 8'h80, 8'h80, 8'hC8, 8'hC8, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h68, 8'h6C, 8'h96, 8'h96, 8'h72, 8'h6E, 8'h6D, 8'h6D, 8'h6D, 8'h68, 8'h88, 8'h68, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h8C, 8'h68, 8'h68, 8'h91, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h84, 8'h80, 8'hA4, 8'hE8, 8'hA8, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h6D, 8'h9A, 8'h72, 8'h4D, 8'h72, 8'h72, 8'h4E, 8'h68, 8'h88, 8'h68, 8'h88, 8'h68, 8'h68, 8'h6C, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h8D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h80, 8'h80, 8'hC8, 8'hE8, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h91, 8'h9A, 8'h96, 8'h96, 8'h96, 8'h76, 8'h76, 8'h72, 8'h72, 8'h72, 8'h4E, 8'h6D, 8'h6C, 8'h6D, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h8C, 8'h68, 8'h68, 8'h68, 8'h88, 8'h68, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hAD, 8'h80, 8'h84, 8'hE8, 8'hE8, 8'h88, 8'h6C, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h6C, 8'h96, 8'hBF, 8'hBF, 8'hBF, 8'hBF, 8'hBF, 8'hBF, 8'h76, 8'h76, 8'h76, 8'h72, 8'h93, 8'h92, 8'h6D, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h8C, 8'h68, 8'h68, 8'h8D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h84, 8'h80, 8'hA4, 8'hE8, 8'hC8, 8'h68, 8'h68, 8'h68, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h6D, 8'h76, 8'h9A, 8'h9A, 8'h9A, 8'h9A, 8'h76, 8'h76, 8'h76, 8'h72, 8'h93, 8'h92, 8'h93, 8'h72, 8'h6D, 8'h68, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h6C, 8'h68, 8'h68, 8'h68, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h80, 8'h80, 8'hC4, 8'hE8, 8'hA8, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h6C, 8'h68, 8'h68, 8'h6C, 8'h68, 8'h68, 8'h88, 8'h68, 8'h6D, 8'h72, 8'h72, 8'h76, 8'h72, 8'h76, 8'h77, 8'h76, 8'h72, 8'h93, 8'h93, 8'h93, 8'h93, 8'h92, 8'h89, 8'h6D, 8'h52, 8'h4D, 8'h68, 8'h88, 8'h68, 8'h8C, 8'h68, 8'h68, 8'h8C, 8'h68, 8'h68, 8'h8C, 8'h68, 8'h8D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h80, 8'h80, 8'hC8, 8'hE8, 8'hA8, 8'h68, 8'h68, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h88, 8'h68, 8'h6D, 8'h6D, 8'h72, 8'h72, 8'h72, 8'h72, 8'h6E, 8'h92, 8'h92, 8'h92, 8'h6E, 8'h6D, 8'h88, 8'h6D, 8'h4E, 8'h4D, 8'h68, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h88, 8'h68, 8'h68, 8'h91, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hAD, 8'h80, 8'h80, 8'hC8, 8'hE8, 8'h84, 8'h68, 8'h68, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h6C, 8'h6C, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h68, 8'h68, 8'h68, 8'h6C, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h89, 8'h80, 8'h84, 8'hE8, 8'hC8, 8'h80, 8'h64, 8'h68, 8'h88, 8'h68, 8'h68, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h8C, 8'h68, 8'h68, 8'h6C, 8'h6C, 8'h8C, 8'h68, 8'h68, 8'h68, 8'h88, 8'h68, 8'h68, 8'h88, 8'h88, 8'h88, 8'h68, 8'h68, 8'h88, 8'h88, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h6C, 8'h68, 8'h8D, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h84, 8'h80, 8'h84, 8'hE8, 8'hA4, 8'h80, 8'h80, 8'h68, 8'h8C, 8'h68, 8'h68, 8'h6C, 8'h6C, 8'h68, 8'h68, 8'h88, 8'h68, 8'h68, 8'h68, 8'h8C, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h8C, 8'h68, 8'h68, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h8C, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h6C, 8'h91, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h80, 8'h80, 8'hA4, 8'hE8, 8'h84, 8'h80, 8'h80, 8'h64, 8'h68, 8'h8C, 8'h68, 8'h68, 8'h88, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h68, 8'h68, 8'h8C, 8'h88, 8'h8C, 8'h88, 8'h8C, 8'h68, 8'h68, 8'h68, 8'h6C, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h8C, 8'h68, 8'h6C, 8'h6C, 8'h68, 8'h68, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB2, 8'h80, 8'h80, 8'hA4, 8'hE8, 8'h84, 8'h80, 8'h80, 8'h80, 8'h80, 8'h64, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'hFF, 8'hFF, 8'hFF, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h6C, 8'h6C, 8'h8D, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h89, 8'h80, 8'h80, 8'hC4, 8'hC8, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h84, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h6C, 8'h88, 8'h88, 8'h88, 8'h68, 8'h68, 8'h8C, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'hFF, 8'hFF, 8'hFF, 8'h91, 8'h68, 8'h68, 8'h68, 8'h6C, 8'h68, 8'h68, 8'h68, 8'h68, 8'h91, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h84, 8'h80, 8'h80, 8'hC8, 8'hC8, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h84, 8'h68, 8'h6C, 8'h88, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h6C, 8'h88, 8'h88, 8'h88, 8'h88, 8'h68, 8'h6C, 8'h68, 8'hB6, 8'hFF, 8'hFF, 8'h91, 8'h68, 8'h68, 8'h6C, 8'h8C, 8'h6C, 8'h68, 8'h68, 8'h68, 8'h8D, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h84, 8'h80, 8'h80, 8'hC8, 8'hC4, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h68, 8'h6C, 8'h68, 8'h68, 8'h68, 8'h8C, 8'h8C, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h68, 8'h68, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h68, 8'hB2, 8'hFF, 8'hFF, 8'h8D, 8'h68, 8'h68, 8'h6D, 8'hB1, 8'hFF, 8'hFF, 8'h91, 8'h91, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h80, 8'h80, 8'h84, 8'hE8, 8'hA4, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h64, 8'h6C, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h68, 8'h68, 8'h68, 8'h88, 8'h68, 8'h68, 8'h88, 8'h68, 8'h68, 8'h68, 8'h88, 8'h88, 8'h8C, 8'h68, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB1, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h80, 8'h80, 8'h84, 8'hE8, 8'h84, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h68, 8'h8C, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h68, 8'h68, 8'h6C, 8'h88, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'hB1, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h80, 8'h80, 8'hA4, 8'hE8, 8'h84, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h64, 8'h6C, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h8C, 8'h6C, 8'h6C, 8'h8C, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h6C, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h80, 8'h80, 8'hA4, 8'hC8, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h64, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h88, 8'h88, 8'h68, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB2, 8'h80, 8'h80, 8'hA4, 8'hC8, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h84, 8'h68, 8'h6C, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h6C, 8'h68, 8'h60, 8'h80, 8'h80, 8'h64, 8'h68, 8'h8C, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h6C, 8'h68, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB2, 8'h80, 8'h80, 8'hC4, 8'hC8, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h68, 8'h6C, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h8C, 8'h68, 8'h80, 8'h80, 8'h80, 8'h80, 8'h68, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB2, 8'h80, 8'h80, 8'hC8, 8'hC8, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h68, 8'h6C, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h8C, 8'h8C, 8'h68, 8'h68, 8'h88, 8'h68, 8'h64, 8'h80, 8'h80, 8'h80, 8'h68, 8'h8C, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h8C, 8'h68, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB2, 8'h80, 8'h84, 8'hE8, 8'hC8, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h68, 8'h8C, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h8C, 8'h8C, 8'h68, 8'h88, 8'h68, 8'h68, 8'h64, 8'h80, 8'h80, 8'h60, 8'h68, 8'h8C, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h80, 8'h84, 8'hE8, 8'hC8, 8'h80, 8'h80, 8'h80, 8'h80, 8'h84, 8'hA4, 8'hA4, 8'hA4, 8'hA4, 8'h68, 8'h6C, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h68, 8'h6C, 8'h68, 8'h84, 8'hA4, 8'hA4, 8'h84, 8'h68, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h68, 8'h6C, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h84, 8'h84, 8'hE8, 8'hC8, 8'hA4, 8'hC4, 8'hC8, 8'hC8, 8'hE8, 8'hE8, 8'hE8, 8'hE8, 8'hC8, 8'h68, 8'h6C, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h6C, 8'h88, 8'hC8, 8'hE8, 8'hE8, 8'hA8, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h8D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hC8, 8'hC8, 8'hE8, 8'hC8, 8'hC8, 8'hE8, 8'hE8, 8'hE8, 8'hC8, 8'hC8, 8'hCD, 8'hCD, 8'hA9, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h88, 8'h8C, 8'h6C, 8'h88, 8'h6C, 8'h88, 8'hC9, 8'hCD, 8'hCD, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h6C, 8'h68, 8'h68, 8'hB1, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hCD, 8'hE8, 8'hE8, 8'hC8, 8'hC9, 8'hD1, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h91, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'hB2, 8'hFF, 8'hFF, 8'hFF, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h6C, 8'h91, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hC8, 8'hE8, 8'hC9, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h68, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h91, 8'hFF, 8'hFF, 8'hFF, 8'h6C, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h91, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD2, 8'hE4, 8'hCD, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h8D, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h88, 8'h88, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h8C, 8'hB6, 8'hFF, 8'h8D, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h91, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hCD, 8'hC8, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h68, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'hB1, 8'hFF, 8'hFF, 8'hB2, 8'h8D, 8'h8C, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h91, 8'hB1, 8'h8D, 8'h8C, 8'h68, 8'h68, 8'h91, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hAD, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h68, 8'h68, 8'h68, 8'h88, 8'h68, 8'h68, 8'h68, 8'h88, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'hB2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB1, 8'h8D, 8'h6C, 8'h68, 8'h68, 8'h68, 8'h6C, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB1, 8'h8C, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h8D, 8'hB1, 8'h8D, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h91, 8'h91, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB1, 8'h8D, 8'h68, 8'h68, 8'h68, 8'h68, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hB1, 8'h8D, 8'h8C, 8'h6C, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'hB1, 8'h91, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF }
};


// pipeline (ff) to get the pixel color from the array 	 
																   
																   
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=	8'h00;
	end
	else begin
		if (InsideRectangle == 1'b1 )  // inside an external bracket 
			RGBout <= object_colors[offsetY][offsetX];	//get RGB from the colors table  
		else 
			RGBout <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
	end 
end
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   

endmodule