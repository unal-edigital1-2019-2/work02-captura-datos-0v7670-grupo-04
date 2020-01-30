`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:50:12 10/01/2019 
// Design Name: 
// Module Name:    anodos 
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
module anodos (zi, an);
 input [3:0] zi;
 output reg [7:0] an;

 parameter [7:0] cero   = 8'b01111111;
 parameter [7:0] uno    = 8'b10111111;
 parameter [7:0] dos    = 8'b11011111;
 parameter [7:0] tres   = 8'b11101111;
 parameter [7:0] cuatro = 8'b11110111;
 parameter [7:0] cinco  = 8'b11111011;
 parameter [7:0] seis   = 8'b11111101;
 parameter [7:0] siete  = 8'b11111110;
 
 parameter [7:0] guion  = 8'b000000000;

always @ (zi)
 begin
  case(zi)
    0: an = cero;
    1: an = uno;
    2: an = dos;
    3: an = tres;
    4: an = cuatro;
    5: an = cinco;
     6: an = seis;
     7: an = siete;
     
     default: an = guion;
  endcase
 end
 
endmodule
