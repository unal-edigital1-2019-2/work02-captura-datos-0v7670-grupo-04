`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:46:19 11/04/2019 
// Design Name: 
// Module Name:    test_cam 
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
module test_cam(
    input wire clk,           // board clock: 100 MHz 
    input wire rst,         	// reset button

	// VGA input/output  
    output wire VGA_Hsync_n,  // horizontal sync output
    output wire VGA_Vsync_n,  // vertical sync output
    output wire [3:0] VGA_R,	// 4-bit VGA red output
    output wire [3:0] VGA_G,  // 4-bit VGA green output
    output wire [3:0] VGA_B,  // 4-bit VGA blue output
	
	//CAMARA input/output
	
	output wire CAM_xclk,		// System  clock imput
	output wire CAM_pwdn,		// power down mode 
	output wire CAM_reset,		// clear all registers of cam
	
	// Entradas para el modulo captura de datos
   // generado por los estudiantes
	 
	 input    wire Href,
    input    wire Vsync,
    input    wire Pclk,
    input    wire [DW-1:0] datos_in



);

 


//***********************************************************************
// modulo de captura de datos generado por estudiantes
//***********************************************************************

// Registros necesarios para el modulo captura de datos
reg fila;
reg  fb;
reg  [DW-1:0] f_data_in565;
reg  [(2*DW)-1:0] s_data_in565;


// Modulo que nos permite recivir los bytes (RGB 565) que genera la camara
// y guardar en la ram (RGB 332)
always @ (posedge Pclk)
begin
//Guardamos 1 byte y damos paso a el registro del segundo byte 
//por medio de un contador (fb)
if (fb==0 && Href==1)
begin
f_data_in565<=datos_in;
fb<=fb+1;
end
//Guardamos el 2do byte y lo contatenamos para tener el registro 
//del pixel en formato RGB 565.
//Inmediatamente extraemos los bits mas significativos para tener 
//el pixel en formato RGB 332 y lo enviamos a la ram
if (fb==1 && Href==1)
begin
fb<=0;
s_data_in565 = {f_data_in565,datos_in};
 DP_RAM_data_in = {s_data_in565 [14:12],s_data_in565 [9:7], s_data_in565 [4:3]};
end
end


// Modulo que controla la direccion de escritura
always @ (negedge Pclk)begin
// Cuando la camara envia la señal Vsync 
//la direccion de escritura es el pixel cero
if (Vsync==1 && Href==0)begin
DP_RAM_addr_in<=0;
end
//Cada 2 pulsos de Pclk la direccion aumenta en 1.
if (Href==1 && fb==0)begin
DP_RAM_addr_in<=DP_RAM_addr_in+1;
end
end

// Modulo que activa señal (permiso) de escritura cuando la camara de la señal Vsync
always @ (posedge Vsync)
begin
if (Href==0)
begin
 DP_RAM_regW<=1;
end
end


// Modulo que desactiva la señal de escritura
// Contador de filas 
always @ (posedge Href)
begin
if (DP_RAM_regW==1)begin
fila<=fila+1;
end
end
//se desactiva señal (permiso) de escritura despues de 480 filas
always @ (negedge Href)
begin
if (fila==479)begin
DP_RAM_regW<=0;
fila<=0;
end
end


//***********************************************************************
//***********************************************************************
//***********************************************************************



// Conexin dual por ram


reg [AW-1: 0] DP_RAM_addr_in; 
reg  [DW-1: 0] DP_RAM_data_in;
reg  DP_RAM_regW;
reg  [AW-1: 0] DP_RAM_addr_out;


// TAMAÑO DE ADQUISICIN DE LA CAMARA 
parameter CAM_SCREEN_X = 160;
parameter CAM_SCREEN_Y = 120;

localparam AW = 15; // LOG2(CAM_SCREEN_X*CAM_SCREEN_Y)
localparam DW = 8;

// El color es RGB 332
localparam RED_VGA =   8'b11100000;
localparam GREEN_VGA = 8'b00011100;
localparam BLUE_VGA =  8'b00000011;


// Clk 
wire clk32M;  
wire clk25M;
wire clk24M;

 
	
// Conexin VGA Driver
wire [DW-1:0]data_mem;	   // Salida de dp_ram al driver VGA
wire [DW-1:0]data_RGB332;  // salida del driver VGA al puerto
wire [9:0]VGA_posX;		   // Determinar la pos de memoria que viene del VGA
wire [8:0]VGA_posY;		   // Determinar la pos de memoria que viene del VGA


/* ****************************************************************************
la pantalla VGA es RGB 444, pero el almacenamiento en memoria se hace 332
por lo tanto, los bits menos significactivos deben ser cero
**************************************************************************** */
assign VGA_R = {data_RGB332[7:5],1'b0};
assign VGA_G = {data_RGB332[4:2],1'b0};
assign VGA_B = {data_RGB332[1:0],2'b00};



/* ****************************************************************************
Asignacin de las seales de control xclk pwdn y reset de la camara 
**************************************************************************** */

assign CAM_xclk=  clk24M;
assign CAM_pwdn=  0;			// power down mode 
assign CAM_reset=  0;



/* ****************************************************************************
  Este bloque se debe modificar segn sea le caso. El ejemplo esta dado para
  fpga Spartan6 lx9 a 32MHz.
  usar "tools -> Core Generator ..."  y general el ip con Clocking Wizard
  el bloque genera un reloj de 25Mhz usado para el VGA  y un relo de 24 MHz
  utilizado para la camara , a partir de una frecuencia de 32 Mhz
**************************************************************************** */
//assign clk32M =clk; en nuestro caso clk100M
clk_100MHZ_to_25M_24M
  clk25_24(
  .CLK_IN1(clk),
  .CLK_OUT1(clk25M),
  .CLK_OUT2(clk24M),
  .RESET(rst)
 );


/* ****************************************************************************
buffer_ram_dp buffer memoria dual port y reloj de lectura y escritura separados
Se debe configurar AW  segn los calculos realizados en el Wp01
se recomiendia dejar DW a 8, con el fin de optimizar recursos  y hacer RGB 332
**************************************************************************** */
buffer_ram_dp #( AW,DW)
	DP_RAM(  
	.clk_w(clk), 
	.addr_in(DP_RAM_addr_in), 
	.data_in(DP_RAM_data_in),
	.regwrite(DP_RAM_regW), 
	
	.clk_r(clk25M), 
	.addr_out(DP_RAM_addr_out),
	.data_out(data_mem)
	);
	

/* ****************************************************************************
VGA_Driver640x480
**************************************************************************** */
VGA_Driver640x480 VGA640x480
(
	.rst(rst),
	.clk(clk25M), 				// 25MHz  para 60 hz de 640x480
	.pixelIn(data_mem), 		// entrada del valor de color  pixel RGB 332 
	.pixelOut(data_RGB332), // salida del valor pixel a la VGA 
	.Hsync_n(VGA_Hsync_n),	// seal de sincronizacin en horizontal negada
	.Vsync_n(VGA_Vsync_n),	// seal de sincronizacin en vertical negada 
	.posX(VGA_posX), 			// posicin en horizontal del pixel siguiente
	.posY(VGA_posY) 			// posicin en vertical  del pixel siguiente

);

 
/* ****************************************************************************
Lgica para actualizar el pixel acorde con la buffer de memoria y el pixel de 
VGA si la imagen de la camara es menor que el display  VGA, los pixeles 
adicionales seran iguales al color del ltimo pixel de memoria 
**************************************************************************** */
always @ (VGA_posX, VGA_posY) begin
		if ((VGA_posX>CAM_SCREEN_X-1) || (VGA_posY>CAM_SCREEN_Y-1))
			DP_RAM_addr_out=CAM_SCREEN_X*CAM_SCREEN_Y;
		else
			DP_RAM_addr_out=VGA_posX+VGA_posY*CAM_SCREEN_Y;
end


endmodule
