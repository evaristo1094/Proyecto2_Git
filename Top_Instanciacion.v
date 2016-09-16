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
module Top_Instanciacion(input wire CLK,Reset,WR1,CT,input wire [7:0] clk_seg1,clk_min1,clk_hora1,tim_seg1,
tim_min1,tim_hora1,Mes1,Dia1,Ano1,output wire [7:0] Mes2,Dia2,Ano2,Seg2,Min2,Hora2,output wire WRO,CSO,ADO,RDO, 
inout wire [7:0] Bus_Dato_Dir);

tri [7:0]  Bus_Dato_Di;  
wire Term_Esc,Term_Lect, Escribe, Lee,DAT1,DIR1,cambio_est,clk_timer,E_esc,E_Lect,En_tristate;
wire[7:0] Dir_hora, Dir_minuto,Dir_segundo, segundo, minuto,hora,Mes_L,Seg_L,Min_L,Ano_L,Hora_L,Dia_L;	 
wire [7:0]Dato_Le,Dato_Dire,Dir_L;
reg [7:0]Dato_Direc,Dato_Direc_next;
Maquina_Principal instance_name4 (   .T_Esc(Term_Esc),    .clk(CLK),    .reset(Reset),    .T_Lect(Term_Lect), 
    .C_T(CT),     .Esc_Lee(WR1),     .clk_seg(clk_seg1),     .clk_min(clk_min1),     .clk_hora(clk_hora1), 
    .tim_seg(tim_seg1),    .tim_min(tim_min1),    .tim_hora(tim_hora1),    .Escribe(Escribe),    .Lee(Lee), 
    .segundo(segundo),    .minuto(minuto),    .hora(hora),    .Dir_hora(Dir_hora),    .Dir_minuto(Dir_minuto), 
    .Dir_segundo(Dir_segundo), .clk_timer(clk_timer)  );
	 
Entradas_De_Control instance_name (    .clk(CLK),    .reset(Reset),    .En_Esc(E_esc),    .En_Lect(E_Lect), 
    .CS(CS),    .WR(WR),    .RD(RD),    .AD(AD),    .DIR1(DIR1),    .DAT1(DAT1),   .cambio_est(cambio_est),
	 .En_tristate(En_tristate));
	 
Maquina_Escritura instance_name2 (    .clk(CLK),     .reset(Reset),     .En_clk(clk_timer),     .DAT(DAT1), 
    .DIR(DIR1),     .Escritura(Escribe),     .D_Seg(Dir_segundo),     .D_Min(Dir_minuto),     .D_Hora(Dir_hora), 
    .cambio_estado(cambio_est),     .Seg(segundo),     .Min(minuto),     .Hora(hora),     .Ano(Ano1), 
    .Mes(Mes1),     .Dia(Dia1),     .Term_Esc(Term_Esc),     .E_esc(E_esc),  	 .Dato_Dire(Dato_Dire));
	 
Maquina_Lectura instance_name3 (    .clk(CLK),     .reset(Reset),     .DAT(DAT1),     .DIR(DIR1), 
    .En_clk(clk_timer),     .Lectura(Lee),     .cambio_estado(cambio_est),     .D_Seg(Dir_segundo), 
    .D_Min(Dir_minuto),   .D_Hora(Dir_hora),    .Seg_L(Seg_L),    .Min_L(Min_L),    .Hora_L(Hora_L),    
	 .Ano_L(Ano_L),    .Mes_L(Mes_L),     .Dia_L(Dia_L),     .Term_Lect(Term_Lect),     .E_Lect(E_Lect),   
	 .Dir_L(Dir_L),		.Dato_L(Dato_Le));
assign WRO = WR;
assign CSO = CS;
assign ADO = AD;
assign RDO = RD;
assign Mes2 = Mes_L;
assign Dia2 = Dia_L;
assign Ano2 = Ano_L;
assign Seg2 = Seg_L;
assign Min2 = Min_L;
assign Hora2 = Hora_L;
always@(posedge CLK, posedge Reset) begin
	if (Reset)
		Dato_Direc <=0;
	else
		Dato_Direc <= Dato_Direc_next;
	end	
always@*
		begin
			//Dato_DirL2 = Dato_DirL;
			if (E_esc)
				Dato_Direc_next = Dato_Dire;
			else 
				Dato_Direc_next = Dir_L;
		end	
assign Bus_Dato_Dir = (En_tristate) ? Dato_Direc : 8'bzzzzzzzz;
assign Bus_Dato_Di =  Bus_Dato_Dir;
assign Dato_Le = Bus_Dato_Di;
endmodule
