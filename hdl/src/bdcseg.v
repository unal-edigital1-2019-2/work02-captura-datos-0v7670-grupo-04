`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:47:29 09/24/2019 
// Design Name: 
// Module Name:    bdcseg 
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


module bdcseg (zi, seg);
 input [3:0] zi;
 output reg [6:0] seg;

 parameter [6:0] cero   = 7'b1000000;
 parameter [6:0] uno    = 7'b1111001;
 parameter [6:0] dos    = 7'b0100100;
 parameter [6:0] tres   = 7'b0110000;
 parameter [6:0] cuatro = 7'b0011001;
 parameter [6:0] cinco  = 7'b0010010;
 parameter [6:0] seis   = 7'b0000010;
 parameter [6:0] siete  = 7'b1111000;
 parameter [6:0] ocho   = 7'b0000000;
 parameter [6:0] nueve  = 7'b0010000;
 parameter [6:0] A      = 7'b0001000;
 parameter [6:0] B      = 7'b0000011;
 parameter [6:0] C      = 7'b1000110;
 parameter [6:0] D      = 7'b0100001;
 parameter [6:0] E      = 7'b0000110;
 parameter [6:0] F      = 7'b0001110;
 parameter [6:0] guion  = 7'b0111111;

always @ (zi)
 begin
  case(zi)
    0: seg = cero;
    1: seg = uno;
    2: seg = dos;
    3: seg = tres;
    4: seg = cuatro;
    5: seg = cinco;
     6: seg = seis;
     7: seg = siete;
     8: seg = ocho;
     9: seg = nueve;
     10: seg = A;
     11: seg = B;
     12: seg = C;
     13: seg = D;
     14: seg = E;
     15: seg = F;
     default: seg = guion;
  endcase
 end
 
endmodule






