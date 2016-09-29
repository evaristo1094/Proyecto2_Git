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
module Maquina_Principal(input wire  clk, reset, 
T_Esc, T_Lect,			//banderas para indicarle a la maquina que se termino de escribir o leer
C_T,						//switch q indica a la maquina si esta escribiendo timer o clk, viene de un swt del top
clk_tim,					//bandera q indica a la maquina si esta leyendo timer o clk, viene de la maq de lect
Esc_Lee,					//boton para saber si escribe o se mantiene leyendo, un btn del top 
inicializa,
input wire [7:0] clk_seg,clk_min,clk_hora,seg_TE,min_TE,hora_TE, 	//datos que vienen del mod en el que el usuario ingresa los valores
output wire Escribe, Lee,	// banderas que van a las maq de esc y lect respectivamente, son enable del proceso
clk_timer,
output reg alarma_on,						// bandera que va a esc y lect para indicar si el proceso es del timer o del clock
output reg [7:0] segundo, minuto, hora,	// datos de escritura del clk
Dir_hora,Dir_minuto,Dir_segundo				// direcciones para la escritura del clk y timer
    );

/// Variables del control de la maquina de estados///
	 
localparam [1:0] 	s0 = 2'b00, 
						s1 = 2'b01,
						s2 = 3'b10,
						s3 = 2'b11;

/// contador del control de la maquina de estados///		

reg [1:0] ctrl_maquina, ctrl_maquina_next;				

/// creacion de registros para las variables de salida ///////
		
reg E_Esc_reg,E_Esc_next;
reg E_Lect_reg, E_Lect_next,clk_timer_next,clk_timer_reg;
reg Bandera_escritura,Bandera_escritura_next;

// inicializacion de los registros a utlizar de las variables

always @( posedge clk, posedge reset)
	if (reset)begin
			ctrl_maquina <= 0;
			E_Esc_reg <= 0;
			E_Lect_reg <= 0;
			clk_timer_reg <= 0;
			Bandera_escritura <=0;
	end
	else begin
			ctrl_maquina <= ctrl_maquina_next;
			E_Esc_reg <= E_Esc_next;
			E_Lect_reg <= E_Lect_next;
			clk_timer_reg <= clk_timer_next;
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
		  Dir_segundo = 0;
		  Dir_minuto = 0;
		  Dir_hora = 0;
		  	alarma_on = 0;
		  Bandera_escritura_next = Bandera_escritura;
	//////////////////// Maquina de estados ////////////////////////	 
      case (ctrl_maquina)
           
	/////Estado inicial, si se activa la opcion de escritura va al estd de escr, sino se mentiene leyendo datos
							
			  s0 : begin
			
					if (Esc_Lee && ~Bandera_escritura) begin
						E_Lect_next = 0; 
                  ctrl_maquina_next = s1; end
               else begin
						 clk_timer_next = clk_timer_next;
						 E_Esc_next = 0;
						 E_Lect_next = E_Lect_next;
                   ctrl_maquina_next = s2; end
				end
						
		//Estado de escritura, hay dos posibles datos a escribir, los del timer o los del Clock
		//C_T si es verdadera escribe en clock, sino en timer.. Esta determina los valores a enviar a escribir
		// los del timer o los del clock, envia direcciones de min, hora, seg y datos de los mismos
		// los otros datos y direcciones ingresan directamente a la de escritura o son fijos ya.	
		
			s1 : begin
								
						if (~T_Esc) begin
							E_Esc_next = 1;
							if (C_T) begin
								//Datos y direcciones del clock
								E_Esc_next = 1;
								clk_timer_next = 1; // Variable que indica que esta escribiendo
								segundo = clk_seg;   //Datos a enviar a la RAM Clock
								minuto = clk_min;
								hora = clk_hora;
								Dir_hora = 8'b00100011;  //Dir RAM Clock
								Dir_minuto = 8'b00100010;
								Dir_segundo = 8'b00100001;
								alarma_on = 0;
								end
							else begin
								//Datos y direcciones del timer
								clk_timer_next = 0;
								alarma_on = 1;
								segundo = seg_TE;    //Datos a enviar a la  RAM Clock
								minuto = min_TE;
								E_Esc_next = 1;
								hora = hora_TE;
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
							
			//Estado de lectura, hay dos posibles datos a leer, los del timer o los del Clock
			//C_T si es verdadera lee en clock, sino en timer.. Esta determina las direcciones a leer
			// los del timer o los del clock, envia direcciones de min, hora, seg 
			// las otras direcciones ingresan directamente a la de lectura o son fijos ya.
			
			s2: begin
		
					E_Lect_next = 1;
					if (~T_Lect && ~inicializa) begin
						alarma_on = 0;
						E_Lect_next = 1;
						if (~clk_tim) begin
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
						
				/// estado no usado	
				
					s3: begin ctrl_maquina_next = s0;
						alarma_on = 0;
			end
			/// estado de default
				default : ctrl_maquina_next = s0;	
			endcase
		end
  //////////// asignacio de las variables de control de las maquinas de escritura y lectura/////////////
		assign Lee = E_Lect_reg;   
		assign Escribe = E_Esc_reg;
		assign clk_timer = clk_timer_reg;
endmodule
