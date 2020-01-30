`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:08:57 10/01/2019 
// Design Name: 
// Module Name:    relog 
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
module relog(
    input clk,
    output reg clk1
    );
	 wire PW;
reg [27:0]count;
always @(posedge clk)
if (PW==1)
begin
if (count<50000000)
begin
count=count+1;
end
else
begin
clk1=~clk1;
count=0;
end
end
endmodule
