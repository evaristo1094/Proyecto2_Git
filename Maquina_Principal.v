`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:39:55 09/12/2016 
// Design Name: 
// Module Name:    Maquina_Principal 
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
module Maquina_Principal(input wire T_Esc, clk, reset, T_Lect,C_T,Esc_Lee, Btn_Inicializa, input wire [7:0] clk_seg,
clk_min,clk_hora,tim_seg,tim_min,tim_hora, output wire Escribe, Lee,	clk_timer, Inicializador_MP,
output reg [7:0] segundo, minuto, hora,Dir_hora,Dir_minuto,Dir_segundo
    );
localparam [1:0] 	s0 = 2'b00, // Variables del control de la maquina de estados
						s1 = 2'b01,
						s2 = 3'b10,
						s3 = 2'b11;
		
reg [1:0] ctrl_maquina, ctrl_maquina_next;						
reg E_Esc_reg,E_Esc_next,Inicializador_MP_reg,Inicializador_MP_next;
reg E_Lect_reg, E_Lect_next,clk_timer_next,clk_timer_reg;
reg Bandera_escritura,Bandera_escritura_next;
// creacion de los registros a utlizar para controlar las variables
always @( posedge clk, posedge reset)
	if (reset)begin
			ctrl_maquina <= 0;
			E_Esc_reg <= 0;
			E_Lect_reg <= 0;
			clk_timer_reg <= 0;
			Inicializador_MP_reg <=0;
			Bandera_escritura <=0;
	end
	else begin
			ctrl_maquina <= ctrl_maquina_next;
			E_Esc_reg <= E_Esc_next;
			E_Lect_reg <= E_Lect_next;
			clk_timer_reg <= clk_timer_next;
			Inicializador_MP_reg <= Inicializador_MP_next;
			Bandera_escritura <=Bandera_escritura_next;
	end
// Maquina de estados
always@*
       begin
        ctrl_maquina_next = ctrl_maquina;
		  E_Esc_next = E_Esc_reg;
		  E_Lect_next = E_Lect_reg;
		  clk_timer_next = clk_timer_reg;
		  segundo = 0;
		  minuto = 0;
		  hora = 0;
		  Inicializador_MP_next = Inicializador_MP_reg;
		  Dir_segundo = 0;
		  Dir_minuto = 0;
		  Dir_hora = 0;
		  Bandera_escritura_next = Bandera_escritura;
	//////////////////// Maquina de estados ////////////////////////	 
      case (ctrl_maquina)
            s0 : begin
				// Estado inicial, si se activa la opcion de escritura va al esta de escritura, 
				// sino se mentiene leyendo datos
					if (Btn_Inicializa) begin
						Inicializador_MP_next = 1;
						E_Esc_next = 0;
						E_Lect_next = 0; end
					else if (Esc_Lee && ~Bandera_escritura) begin
						Inicializador_MP_next = 0;
						E_Lect_next = 0; 
                  ctrl_maquina_next = s1; end
               else begin
						 clk_timer_next = clk_timer_next;
						 E_Esc_next = 0;
						 E_Lect_next = E_Lect_next;
						 Inicializador_MP_next = 0;
                   ctrl_maquina_next = s2; end
						end
				s1 : begin
				//Estado de escritura, hay dos posibles datos a escribir, los del timer o los del Clock
				//C_T si es verdadera escribe en clock, sino en timer.. Esta determina los valores a enviar a escribir
				// los del timer o los del clock, envia direcciones de min, hora, seg y datos de los mismos
				// los otros datos y direcciones ingresan directamente a la de escritura o son fijos ya.						
						if (~T_Esc) begin
							E_Esc_next = 1;
							if (C_T) begin
								//Datos y direcciones del clock
								E_Esc_next = 1;
								clk_timer_next = 1; // Variable que indica que esta escribiendo
								segundo = clk_seg;   //Datos RAM Clock
								minuto = clk_min;
								hora = clk_hora;
								Dir_hora = 8'b00100011;  //Dir RAM Clock
								Dir_minuto = 8'b00100010;
								Dir_segundo = 8'b00100001;
								end
							else begin
								//Datos y direcciones del timer
								clk_timer_next = 0;
								segundo = tim_seg;    //Datos RAM Clock
								minuto = tim_min;
								E_Esc_next = 1;
								hora = tim_hora;
								Dir_hora = 8'b01000011;  //Dir RAM timer
								Dir_minuto = 8'b01000010;
								Dir_segundo = 8'b01000001;
								end end
						else begin
							 ctrl_maquina_next = s2;
							 Bandera_escritura_next = 1;
							 E_Lect_next = 1;
							 E_Esc_next = 0;
							end	
							end
				s2: begin
			//Estado de lectura, hay dos posibles datos a leer, los del timer o los del Clock
				//C_T si es verdadera lee en clock, sino en timer.. Esta determina las direcciones a leer
				// los del timer o los del clock, envia direcciones de min, hora, seg 
				// las otras direcciones ingresan directamente a la de lectura o son fijos ya.	
					E_Lect_next = 1;
					if (~T_Lect) begin
						if (C_T) begin
							clk_timer_next = 1;  // Variable que indica que variables esta leyendo
							Dir_hora = 8'b00100011; //Dir RAM Clock
							Dir_minuto = 8'b00100010;
							Dir_segundo = 8'b00100001;
							end
						else begin
							clk_timer_next = 0;
							Dir_hora = 8'b01000011; //Dir RAM timer
							Dir_minuto = 8'b01000010;
							Dir_segundo = 8'b01000001;
							end end
               else if (Esc_Lee)begin
                   ctrl_maquina_next = s0;
						 E_Lect_next = 0;
						end	
					else begin
                   ctrl_maquina_next = s3;
						 Bandera_escritura_next = 0;
						 E_Lect_next = 0;
						end	
						end
					s3: ctrl_maquina_next = s0;	
				default : ctrl_maquina_next = s0;	
			endcase
		end
  //////////// Variables de control de las maquinas de escritura y lectura/////////////
		assign Lee = E_Lect_reg;   
		assign Escribe = E_Esc_reg;
		assign clk_timer = clk_timer_reg;
		assign Inicializador_MP = Inicializador_MP_reg; 
endmodule
