`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:57:37 09/10/2016 
// Design Name: 
// Module Name:    Maquina_Lectura 
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
module Maquina_Lectura(input wire clk, reset, 
DAT,DIR,DAT2,cambio_estado,cambio_estado2, 	//entradas para controlar el envio de datos, vienen de entradas de control
En_clk, Lectura, inicializa,					// senales de la maquina principal, la primera lectura del clk o timer, segunda habilita la lect
input wire [7:0] D_Seg,D_Min,D_Hora, Dato_L,  						//entradas de direcciones de maquina principal y datos del RTC  
output wire [7:0] Seg_LC,Min_LC,Hora_LC,Ano_LC, Mes_LC, Dia_LC,// salidas de los datos de lectura del clk
Seg_LT,Min_LT,Hora_LT, 														 /// salidas de lectura del timer
output wire  Term_Lect,E_Lect,Tr_Lect,clk_timerL, 					// senales de control para la maquina principal y la de control
output wire[7:0] Dir_L  ); 													// direccion de lectura del timer

localparam [3:0] 	s0 = 4'b0000, // Variables del control de la maquina de estados
						s1 = 4'b0001,
						s2 = 4'b0010,
						s3 = 4'b0011,
						s4 = 4'b0100,
						s5 = 4'b0101,
						s6 = 4'b0110,
						s7 = 4'b0111,
						s8 = 4'b1000;
// contador de la maquina
reg [3:0] ctrl_maquina, ctrl_maquina_next;

///asignacion de registros auxiliares para cada salida del bloque///

reg clk1_timer2,clk1_timer2_next;
reg [7:0] Dato_Dir_reg, Dato_Dir_next;
reg [7:0] Seg_C_reg,Seg_C_next,Min_C_reg,Min_C_next,Hora_C_reg,Hora_C_next;
reg [7:0] Seg_T_reg,Seg_T_next,Min_T_reg,Min_T_next,Hora_T_reg,Hora_T_next;
reg [7:0] Dia_reg, Dia_next,Mes_reg,Mes_next,Ano_reg,Ano_next;
reg Term_Lect_reg,Tr_Lect_reg,Tr_Lect_next; 
reg En_Lect_reg, En_Lect_next;

// inicializacion y refresco de los registros a utlizar de las variables de salida

always @( posedge clk, posedge reset)begin
	if (reset)begin
			ctrl_maquina <= 0;
			En_Lect_reg <= 0;
			Tr_Lect_reg <=0;
			Dato_Dir_reg <= 0;
			Seg_C_reg <= 0;
			Min_C_reg <= 0;
			Hora_C_reg <= 0;
			Seg_T_reg <= 0;
			Min_T_reg <= 0;
			Hora_T_reg <= 0;
			Mes_reg <= 0;
			Dia_reg <= 0;
			Ano_reg <= 0;
			clk1_timer2 <=0;
	end
	else begin
			ctrl_maquina <= ctrl_maquina_next;
			En_Lect_reg <= En_Lect_next;
			Dato_Dir_reg <= Dato_Dir_next;
			Tr_Lect_reg <= Tr_Lect_next;
			Seg_C_reg <= Seg_C_next;
			Min_C_reg <= Min_C_next;
			Hora_C_reg <= Hora_C_next;
			Seg_T_reg <= Seg_T_next;
			Min_T_reg <= Min_T_next;
			Hora_T_reg <= Hora_T_next;
			Dia_reg <= Dia_next;
			Mes_reg <= Mes_next;
			Ano_reg <= Ano_next;
			clk1_timer2 <= clk1_timer2_next;
			end 
	end
	
/////////// Maquina de estados//////////////////

always@*
       begin
        ctrl_maquina_next = ctrl_maquina;
		  En_Lect_next = En_Lect_reg;
        Dato_Dir_next = Dato_Dir_reg;
		  Seg_C_next = Seg_C_reg;
			Min_C_next = Min_C_reg;
			Hora_C_next = Hora_C_reg;
			Seg_T_next = Seg_T_reg;
			Min_T_next = Min_T_reg;
			Hora_T_next = Hora_T_reg;
			Term_Lect_reg = 0;
			Dia_next = Dia_reg;
			Tr_Lect_next = Tr_Lect_reg;
			Mes_next = Mes_reg;
			Ano_next = Ano_reg;
			clk1_timer2_next = clk1_timer2;
     if(~inicializa)
		begin	
	  case (ctrl_maquina)
			
			
					////////// Estado general, espera la senal de lectura para empezar el proceso////////////
					
					
            s0 : begin
				//	
				  if (Lectura && ~inicializa) begin
						Term_Lect_reg = 0;
                  ctrl_maquina_next = s1;
						clk1_timer2_next = 0;
						Dato_Dir_next = 8'b11111111;
						En_Lect_next = 1;end
               else begin
						ctrl_maquina_next = s0; 
                  En_Lect_next = 0;
						end end

			//////////// Estado de escritura del comando de transferencia del clock o el timer a la RAM			

			s1 : begin
						if (DIR) 
							Dato_Dir_next = 8'b11110001;
						else if (DAT) begin
							Tr_Lect_next = 1;
							Dato_Dir_next = 8'b00000000; end
						else if (cambio_estado) begin
							 ctrl_maquina_next = s2;
							 Tr_Lect_next = 0;
							  En_Lect_next = 0; end
						else begin
							 En_Lect_next =  1;
							ctrl_maquina_next = ctrl_maquina_next;  end	end						
			s2 : begin		
							if (DIR) 
								Dato_Dir_next = 8'b11110010;
							else if (DAT) begin
								Tr_Lect_next = 1;
								Dato_Dir_next = 8'b00000000;end
							else if (cambio_estado) begin
								 Tr_Lect_next = 0;
								 ctrl_maquina_next = s3;
								  En_Lect_next = 0; end
							else begin
								 En_Lect_next =  1;
								ctrl_maquina_next = ctrl_maquina_next;  end							
								end 
								
             	//////////// Estado de lectura del dato de segundos, tanto del clock como del timer
		//////////// Recibe de la maquina principal la direccion (clock o timer) donde lee y envia el valor a la salida
		
				 s3 : begin
					Seg_T_next = Seg_T_reg;
               Seg_C_next = Seg_C_reg;
					if (DIR) 
						Dato_Dir_next = D_Seg;
               else if (DAT2) begin 
						if(En_clk)
							Seg_C_next = Dato_L;
						else
							Seg_T_next = Dato_L;end
					else if (cambio_estado2) begin	
						 ctrl_maquina_next = s4;
						  En_Lect_next = 0; end
					else begin
						 En_Lect_next =  1;
                  ctrl_maquina_next = ctrl_maquina_next;  end
				end
						
			//////////// Estado de lectura del dato de minutosos, tanto del clock como del timer
		//////////// Recibe de la maquina principal la direccion (clock o timer) donde lee y envia el valor a la salida	 
      	
				s4 : begin
			        Min_C_next = Min_C_reg;
					  Min_T_next = Min_T_reg;
					if (DIR) 
						Dato_Dir_next = D_Min;
               else if (DAT2) begin 
						if(En_clk)
							Min_C_next = Dato_L;
						else
							Min_T_next = Dato_L;end
					else if (cambio_estado2 ) begin	
						 ctrl_maquina_next = s5;
						  En_Lect_next = 0; end
					else begin
						 En_Lect_next = 1;
                  ctrl_maquina_next = ctrl_maquina_next;  end	
				end
				
		//////////// Estado de lectura del dato de hora, tanto del clock como del timer
		//////////// Recibe de la maquina principal la direccion (clock o timer) donde lee y envia el valor a la salida
  
				s5 : begin
			        Hora_C_next = Hora_C_reg;
					  Hora_T_next = Hora_T_reg;
					if (DIR) 
						Dato_Dir_next = D_Hora;
               else if (DAT2)	 begin 
						if(En_clk)
							Hora_C_next = Dato_L;
						else
							Hora_T_next = Dato_L;end
					else if (cambio_estado2 ) begin	 
						 ctrl_maquina_next = s6;
						  En_Lect_next = 0; end
					else begin
						 En_Lect_next =  1;
                  ctrl_maquina_next = ctrl_maquina_next;  end	
				end
			
			//////////// Estado de lectura del dato de dia del y envia el valor a la salida
			
			s6 : begin
               Dia_next = Dia_reg;
					if(En_clk) begin
						if (DIR) 
							Dato_Dir_next = 8'b00100100;
						else if (DAT2)
							Dia_next = Dato_L ;
						else if (cambio_estado2) begin	 
							 ctrl_maquina_next = s7;
							  En_Lect_next = 0; end
						else begin
							 En_Lect_next =  1;
							ctrl_maquina_next = ctrl_maquina_next;  end	end
					else begin	 
							 ctrl_maquina_next = s7;
							  En_Lect_next = 0;
							  end		
				end
				 
				 //////////// Estado de lectura del dato de mes del y envia el valor a la salida	
				 
				 s7 : begin			
					Mes_next = Mes_reg;
					if(En_clk) begin
						if (DIR) 
							Dato_Dir_next = 8'b00100101;
						else if (DAT2) 
							Mes_next = Dato_L;
						else if (cambio_estado2) begin	 
							 ctrl_maquina_next = s8;
							  En_Lect_next = 0; end
						else begin
							 En_Lect_next =  1;
							ctrl_maquina_next = ctrl_maquina_next;  end	
							end 
					else begin	 
						 ctrl_maquina_next = s8;
						  En_Lect_next = 0;
						  end 
					end

	//////////// Estado de lectura del dato de ano del y envia el valor a la salida	
	
				s8 : begin
				 Ano_next = Ano_reg;
				 if(En_clk) begin
						if (DIR) 
							Dato_Dir_next = 8'b00100110;
						else if (DAT2)
							Ano_next = Dato_L ;
						else if (cambio_estado2) begin
							 Term_Lect_reg = 0;	
							 ctrl_maquina_next = s3;
							 clk1_timer2_next = 1;
							  En_Lect_next = 0; end
						else begin
							 En_Lect_next =  1;
							ctrl_maquina_next = ctrl_maquina_next;  end	
							end 
					else begin	 
						 ctrl_maquina_next = s0;
						 clk1_timer2_next = 0;
						 Term_Lect_reg = 1;	
						 En_Lect_next = 0;
						  end	
					end
					
					//////////Estado de default
					
					default : ctrl_maquina_next = s0;
         endcase
		end
		else begin
		ctrl_maquina_next = s0; 
		Term_Lect_reg = 1;
		En_Lect_next = 0; 
		end
	end
	//////////////// Asignacion de las variables de salida//////////////	
	assign Seg_LC = Seg_C_reg;
	assign Min_LC = Min_C_reg;
	assign Hora_LC = Hora_C_reg;
	assign Seg_LT = Seg_T_reg;
	assign Min_LT = Min_T_reg;
	assign Hora_LT = Hora_T_reg;
	assign Dia_LC = Dia_reg;
	assign Mes_LC = Mes_reg;
	assign Ano_LC = Ano_reg;
	assign Dir_L = Dato_Dir_reg;
	assign E_Lect = En_Lect_reg;
	assign Tr_Lect = Tr_Lect_reg;
	
 /// Bandera que indica que se termino el proceso de escritura	
	assign Term_Lect = Term_Lect_reg; 
	assign clk_timerL = clk1_timer2;
endmodule 
