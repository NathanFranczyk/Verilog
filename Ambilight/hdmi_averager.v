`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:54:13 02/14/2019 
// Design Name: 
// Module Name:    hdmi_averager 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module hdmi_averager(
	  input  [7:0] red,
	  input  [7:0] green,
	  input  [7:0] blue,
	  input  vsync,
	  input  hsync,
	  input  clk, //Use the lvds clk?
	  output  [7:0] avg_red,
	  output  [7:0] avg_green,
	  output  [7:0] avg_blue,
	  input tmds_clk
    );
	//bin the borders in 128 pixel blocks
	//every 128 tmds timers, move onto the next bin
	
	
endmodule
