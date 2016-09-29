`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:57:40 09/26/2016 
// Design Name: 
// Module Name:    Inst_Mux_Usuario 
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
module Inst_Mux_Usuario( input wire btn_dism, btn_aum, btn_der, btn_izq,btn_RESET,CLK,switch_configuracion,apagar_alarma,
switch_Clk_timer,boton_doce_24,sw_escribir,sw_inicializador,output wire curs_seg,curs_min,curs_hora,curs_dia,curs_mes,curs_ano,
curs_T_seg,curs_T_min,curs_T_hora, WRO,RDO,CSO,ADO,activring,
output wire [7:0] s_VGA, mi_VGA,h_VGA, d_VGA, me_VGA,an_VGA,s_T_VGA,m_T_VGA,h_T_VGA,
inout wire [7:0] Bus_Dato_Dir
    );
	 
wire [7:0] seg_C,min_C,hora_C,dia,mes,ano,segundo,minuto,hora,hora_TVGA,seg_TVGA,min_TVGA; 
wire [7:0] Seg2,Min2,Hora2,Dia2,Mes2,Ano2,Seg2_T,Min2_T,Hora2_T,seg_T,min_T,hora_T;
wire [3:0] hora_1,hora_2,min_1,min_2,seg_1,seg_2; 
wire dism,aument,izqda,derec,sw_conf,sw_CT,DOCE_24,escrib;
wire cursor_seg,cursor_min,cursor_hora,cursor_dia,cursor_mes,cursor_ano,
cursor_T_seg,cursor_T_min,cursor_T_hora;     
wire [7:0] seg_VGA,min_VGA,hora_VGA,dia_VGA,mes_VGA,ano_VGA,seg_T_VGA,min_T_VGA,hora_T_VGA;
Mux_VGA instance_name1 (
    .En_Escr(sw_conf), 
    .En_clock(sw_CT), 
    .seg_usu(seg_C), 
    .min_usu(min_C), 
    .hora_usu(hora_C), 
    .dia_usu(dia), 
    .mes_usu(mes), 
    .ano_usu(ano), 
    .seg_T_usu(seg_TVGA), 
    .min_T_usu(min_TVGA), 
    .hora_T_usu(hora_TVGA), 
    .seg_RTC(Seg2), 
    .min_RTC(Min2), 
    .hora_RTC(Hora2), 
    .dia_RTC(Dia2), 
    .mes_RTC(Mes2), 
    .ano_RTC(Ano2), 
    .seg_T_RTC(segundo), 
    .min_T_RTC(minuto), 
    .hora_T_RTC(hora), 
    .seg_VGA(seg_VGA), 
    .min_VGA(min_VGA), 
    .hora_VGA(hora_VGA), 
    .dia_VGA(dia_VGA), 
    .mes_VGA(mes_VGA), 
    .ano_VGA(ano_VGA), 
    .seg_T_VGA(seg_T_VGA), 
    .min_T_VGA(min_T_VGA), 
    .hora_T_VGA(hora_T_VGA)
    );

Ingreso_Datos instance_name2 (
    .clk(CLK), 
    .reset(btn_RESET), 
    .C_T(sw_CT), 
    .disminuye(dism), 
    .aumenta(aument), 
    .escribe(sw_conf), 
    .corre_der(derec), 
    .corre_izq(izqda), 
    .doce_24(DOCE_24), 
    .seg_C(seg_C), 
    .min_C(min_C), 
    .hora_C(hora_C), 
    .dia(dia), 
    .mes(mes), 
    .ano(ano), 
    .seg_T(seg_T), 
    .min_T(min_T), 
    .hora_T(hora_T), 
    .cursor_seg(cursor_seg), 
    .cursor_min(cursor_min), 
    .cursor_hora(cursor_hora), 
    .cursor_mes(cursor_mes), 
    .cursor_dia(cursor_dia), 
    .cursor_ano(cursor_ano), 
    .cursor_T_seg(cursor_T_seg), 
    .cursor_T_min(cursor_T_min), 
    .cursor_T_hora(cursor_T_hora),
	 .hora_TVGA(hora_TVGA),
	 .seg_TVGA(seg_TVGA),
	 .min_TVGA(min_TVGA)
    );

Elimina_Rebotes instance_name3 (
    .btn_reset(btn_RESET), 
    .clk(CLK), 
	 .sw_inicializador(sw_inicializador),
    .btn_disminuye(btn_dism), 
    .btn_aumenta(btn_aum), 
    .btn_derecha(btn_izq), 
    .btn_izquierda(btn_der), 
    .btn_escribir(sw_escribir), 
    .switch_CT(switch_Clk_timer), 
    .switch_config(switch_configuracion), 
    .btn_doce_24(boton_doce_24), 
    .dism(dism), 
    .aument(aument), 
    .derec(derec), 
    .izqda(izqda), 
    .escrib(escrib), 
    .sw_CT(sw_CT), 
    .sw_conf(sw_conf), 
    .DOCE_24(DOCE_24),
	 .inicializador(inicializador)
    );
Top_Instanciacion instance_name4 (
    .CLK(CLK), 
    .Reset(btn_RESET), 
    .WR1(escrib), 
    .CT(sw_CT), 
    .doce_24(DOCE_24), 
    .inicializar(inicializador), 
    .clk_seg1(seg_C), 
    .clk_min1(min_C), 
    .clk_hora1(hora_C), 
    .Mes1(mes), 
    .Dia1(dia), 
    .Ano1(ano), 
    .Mes2(Mes2), 
    .Dia2(Dia2), 
    .Ano2(Ano2), 
    .Seg2(Seg2), 
    .Min2(Min2), 
    .Hora2(Hora2), 
    .Seg2_T(Seg2_T), 
    .Min2_T(Min2_T), 
    .Hora2_T(Hora2_T), 
    .WRO(WRO), 
    .CSO(CSO), 
    .ADO(ADO), 
    .RDO(RDO), 
    .Bus_Dato_Dir(Bus_Dato_Dir),
	 .alarma_ON(alarma_ON),
	 .T_seg(seg_T),
	 .T_min(min_T),
	 .T_hora(hora_T)
    );
indicador_ring instance_name5 (
    .alarma_on(alarma_ON), 
    .HRTC(Hora2_T), 
    .MRTC(Min2_T), 
    .SRTC(Seg2_T), 
    .activring(activring), 
    .hora_1(hora_1), 
    .hora_2(hora_2), 
    .min_1(min_1), 
    .min_2(min_2), 
    .seg_1(seg_1), 
    .seg_2(seg_2),
	 .clk(CLK),
	 .reset(btn_RESET),
	 .apagar_alarma(apagar_alarma)
    );
assign curs_seg = cursor_seg; 
assign curs_min = cursor_min;
assign curs_hora = cursor_hora; 
assign curs_mes = cursor_mes; 
assign curs_dia = cursor_dia;
assign curs_ano = cursor_ano; 
assign curs_T_seg = cursor_T_seg; 
assign curs_T_min = cursor_T_min; 
assign curs_T_hora = cursor_T_hora;
assign s_VGA = seg_VGA;
assign mi_VGA = min_VGA;
assign h_VGA = hora_VGA;
assign d_VGA = dia_VGA;
assign me_VGA = mes_VGA;
assign an_VGA = ano_VGA;
assign s_T_VGA = seg_T_VGA;
assign m_T_VGA = min_T_VGA;
assign h_T_VGA = hora_T_VGA;
assign segundo = {seg_1,seg_2};
assign minuto = {min_1,min_2};
assign hora = {hora_1,hora_2};
endmodule
