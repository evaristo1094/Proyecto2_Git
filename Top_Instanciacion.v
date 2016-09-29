`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:48:33 09/12/2016 
// Design Name: 
// Module Name:    Top_Instanciacion 
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
module Top_Instanciacion(input wire CLK,Reset,
WR1,	   		// pulso de un switch para escribir los datos al RTC
CT,				// senal de switch para saber si se esta escribiendo el reloj (1) o el timer (0)
doce_24,			// switch para determinar si se escribe en formato 12h(1) o 24h(0)
inicializar,	// switch para inicializar el RTC
input wire [7:0] clk_seg1,clk_min1,clk_hora1,Mes1,Dia1,Ano1,T_seg,T_min,T_hora, // datos a escribir al RTC
output wire [7:0] Mes2,Dia2,Ano2,Seg2,Min2,Hora2,Seg2_T,Min2_T,Hora2_T, //datos de lectura del RTC va al VGA
output wire WRO,CSO,ADO,RDO,alarma_ON, //senales de control del RTC
inout wire [7:0] Bus_Dato_Dir); //bus de direcciones y datos del RTC

tri [7:0]  Bus_Dato_Di;  
wire Term_Esc,Term_Lect, Escribe, Lee,DAT1,DIR1,cambio_est,clk_timer,E_esc,E_Lect,En_tristate,Tr_Lect;
wire DAT_LECT,clk_timerL,alarma_on;
reg Tr_L;
wire[7:0] Dir_hora, Dir_minuto,Dir_segundo, segundo, minuto,hora,Mes_LC,Seg_LC,Min_LC,Ano_LC,Hora_LC,Dia_LC,
Hora_LT,Seg_LT,Min_LT;	 
wire [7:0]Dato_Le,Dato_Dire,Dir_L;
reg [7:0]Dato_Direc,Dato_Direc_next;
Maquina_Principal instance_name4 (   .T_Esc(Term_Esc),    .clk(CLK),    .reset(Reset),    .T_Lect(Term_Lect), 
    .C_T(CT),     .Esc_Lee(WR1),     .clk_seg(clk_seg1),     .clk_min(clk_min1),     .clk_hora(clk_hora1), 
    .Escribe(Escribe),    .Lee(Lee),     .segundo(segundo),    .minuto(minuto),    .hora(hora),    
	 .Dir_hora(Dir_hora),    .Dir_minuto(Dir_minuto),     .Dir_segundo(Dir_segundo), .clk_timer(clk_timer),
	  .clk_tim(clk_timerL),		.inicializa(inicializar),	.alarma_on(alarma_on),	.seg_TE(T_seg),	.min_TE(T_min),	
	  .hora_TE(T_hora)  );
	 
Entradas_De_Control instance_name (    .clk(CLK),    .reset(Reset),    .En_Esc(E_esc),    .En_Lect(E_Lect), 
    .CS(CS),    .WR(WR),    .RD(RD),    .AD(AD),    .DIR1(DIR1),    .DAT1(DAT1),   .cambio_est(cambio_est),
	 .cambio_est2(cambio_est2),		.En_tristate(En_tristate),		.DAT_LECT(DAT_LECT));
	 
Maquina_Escritura instance_name2 (    .clk(CLK),     .reset(Reset),     .En_clk(clk_timer),     .DAT(DAT1), 
    .DIR(DIR1),     .Escritura(Escribe),     .D_Seg(Dir_segundo),     .D_Min(Dir_minuto),     .D_Hora(Dir_hora), 
    .cambio_estado(cambio_est),     .Seg(segundo),     .Min(minuto),     .Hora(hora),     .Ano(Ano1), 
    .Mes(Mes1),     .Dia(Dia1),  .inicializador(inicializar),   .Term_Esc(Term_Esc),     .E_esc(E_esc),  	
	 .Dato_Dire(Dato_Dire),	 .doce_24C(doce_24));
	 
Maquina_Lectura instance_name3 (    .clk(CLK),     .reset(Reset),     .DAT(DAT1),     .DIR(DIR1), 
    .En_clk(clk_timer),     .Lectura(Lee),     .cambio_estado(cambio_est), .cambio_estado2(cambio_est2),     .D_Seg(Dir_segundo), 
    .D_Min(Dir_minuto),   .D_Hora(Dir_hora),    .Seg_LC(Seg_LC),    .Min_LC(Min_LC),    .Hora_LC(Hora_LC),    
	 .Ano_LC(Ano_LC),    .Mes_LC(Mes_LC),     .Dia_LC(Dia_LC),     .Term_Lect(Term_Lect),     .E_Lect(E_Lect),   
	 .Dir_L(Dir_L),		.Dato_L(Dato_Le), 	.Tr_Lect(Tr_Lect), 		.DAT2(DAT_LECT),	.clk_timerL(clk_timerL),
	 .Seg_LT(Seg_LT),				.Min_LT(Min_LT),			.Hora_LT(Hora_LT),		.inicializa(inicializar));




assign WRO = WR;
assign CSO = CS;
assign ADO = AD;
assign RDO = RD;
assign Mes2 = Mes_LC;
assign Dia2 = Dia_LC;
assign Ano2 = Ano_LC;
assign Seg2 = Seg_LC;
assign Min2 = Min_LC;
assign Hora2_T = Hora_LT;
assign Seg2_T = Seg_LT;
assign Min2_T = Min_LT;
assign Hora2 = Hora_LC;
assign alarma_ON = alarma_on;

always@(posedge CLK, posedge Reset) begin
	if (Reset)begin
		Dato_Direc <=0;
		Tr_L <=0; end
	else  begin
		Dato_Direc <= Dato_Direc_next;
		Tr_L <= Tr_Lect; end
	end	
always@*
		begin
			if (E_esc )
				Dato_Direc_next = Dato_Dire;
			else 
				Dato_Direc_next = Dir_L;
		end	
assign Bus_Dato_Dir = (En_tristate | Tr_L ) ? Dato_Direc : 8'bzzzzzzzz;
assign Bus_Dato_Di =  Bus_Dato_Dir;
assign Dato_Le = Bus_Dato_Di;
endmodule
