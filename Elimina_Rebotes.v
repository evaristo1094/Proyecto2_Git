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
sw_inicializador, //				switch que ejecuta la inicializacion del RTC
output reg	dism,aument,derec,izqda,		// salidas con rebote eliminado    
output wire escrib, sw_CT, sw_conf, DOCE_24,inicializador);			// salidas con rebote eliminado  


localparam un_tercio_s = 20000000;
localparam treinta_mil_ns = 3000000;
reg escrib_reg, sw_CT_reg, sw_conf_reg, DOCE_24_reg,escrib_next, sw_CT_next, sw_conf_next, DOCE_24_next;
reg inicializador_reg, inicializador_next;
reg [24:0] contador1,contador1_next;
reg [21:0] contador2,contador2_next;

always @( posedge clk, posedge btn_reset)
	if (btn_reset)begin
			contador1 <= 0;
			contador2<= 0;
			escrib_reg <= 0;
			sw_CT_reg <= 0;
			sw_conf_reg <=0;
			DOCE_24_reg <=0;
			inicializador_reg <=0;
	end
	else begin
			contador1 <= contador1_next;
			contador2 <= contador2_next;
			escrib_reg <= escrib_next;
			sw_CT_reg <= sw_CT_next;
			sw_conf_reg <= sw_conf_next;
			DOCE_24_reg <= DOCE_24_next;
			inicializador_reg <= inicializador_next;
	end
	
always @* begin
		contador1_next = contador1;
		if (contador1 == un_tercio_s) begin
			dism = btn_disminuye;
			aument = btn_aumenta;
			derec = btn_derecha;
			izqda = btn_izquierda;
			contador1_next = 0; end
		else	begin
			contador1_next = contador1_next + 25'b1;
			dism = 0;
			aument = 0;
			derec = 0;
			izqda = 0; end
		end	
		
always @* begin
			contador2_next = contador2;
			escrib_next = 	escrib_reg;
			sw_CT_next = sw_CT_reg;
			sw_conf_next = sw_conf_reg;
			DOCE_24_next = DOCE_24_reg; 
			inicializador_next = inicializador_reg;
		if (contador2 == treinta_mil_ns) begin
			escrib_next = btn_escribir;
			sw_CT_next = switch_CT;
			sw_conf_next = switch_config;
			DOCE_24_next = btn_doce_24;
			contador2_next = 0; 
			inicializador_next = sw_inicializador;end
		else begin
			contador2_next = contador2_next + 2'b1;
			escrib_next = 	escrib_reg;
			sw_CT_next = sw_CT_reg;
			sw_conf_next = sw_conf_reg;
			DOCE_24_next = DOCE_24_reg;
			inicializador_next = inicializador_reg;			end
		end		
assign escrib = escrib_reg;
assign sw_CT = sw_CT_reg;
assign sw_conf = sw_conf_reg;
assign DOCE_24 = DOCE_24_reg;	
assign inicializador =inicializador_reg;
endmodule
