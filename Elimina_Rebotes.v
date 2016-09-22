`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:29:12 09/21/2016 
// Design Name: 
// Module Name:    Elimina_Rebotes 
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
module Elimina_Rebotes(input wire btn_reset, clk,
btn_disminuye,btn_aumenta,btn_derecha,btn_izquierda, // ingreso y desplazamiento de datos
btn_escribir, 		// 			boton para escribir despues de configurar los datos
switch_CT,			//				switch que determina que esta escribiendo o configurando
switch_config, 	//				switch para configurar los datos
btn_doce_24,				//				switch que determina el formato de hora
output reg	dism,aument,derec,izqda,		// salidas con rebote eliminado    
escrib, sw_CT, sw_conf, DOCE_24);			// salidas con rebote eliminado  


localparam un_tercio_s = 30000000;
localparam treinta_mil_ns = 3000000;
//reg dism,aument,derec,izqda,	escrib, sw_CT, sw_conf, DOCE_24
reg [24:0] contador1,contador1_next;
reg [21:0] contador2,contador2_next;

always @( posedge clk, posedge btn_reset)
	if (btn_reset)begin
			contador1 <= 0;
			contador2<= 0;
	end
	else begin
			contador1 <= contador1_next;
			contador2 <= contador2_next;
	end
	
always @* begin
		contador1_next = contador1;
		if (contador1 == un_tercio_s) begin
			dism = btn_disminuye;
			aument = btn_aumenta;
			derec = btn_derecha;
			izqda = btn_izquierda;
			contador1_next = 0; end
		else
			contador1_next = contador1_next + 1;
		end	
		
always @* begin
		contador2_next = contador2;
		if (contador2 == treinta_mil_ns) begin
			escrib = btn_escribir;
			sw_CT = switch_CT;
			sw_conf = switch_config;
			DOCE_24 = btn_doce_24;
			contador2_next = 0; end
		else
			contador2_next = contador2_next + 1;
			escrib = escrib;
			sw_CT = sw_CT;
		end		
		
endmodule
