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
module Maquina_Lectura(input wire clk, reset, DAT,DIR, En_clk, Lectura,cambio_estado,DAT2, input wire [7:0] 
D_Seg,D_Min,D_Hora, Dato_L, output wire [7:0] Seg_L,Min_L,Hora_L,Ano_L, Mes_L, Dia_L,
output wire  Term_Lect,E_Lect,Tr_Lect, output wire[7:0] Dir_L  );

localparam [2:0] 	s0 = 3'b000, // Variables del control de la maquina de estados
						s1 = 3'b001,
						s2 = 3'b010,
						s3 = 3'b011,
						s4 = 3'b100,
						s5 = 3'b101,
						s6 = 3'b110,
						s7 = 3'b111;
// contador de la maquina
reg [2:0] ctrl_maquina, ctrl_maquina_next;
reg [7:0] Dato_Dir_reg, Dato_Dir_next;
reg [7:0] Seg_C_reg,Seg_C_next,Min_C_reg,Min_C_next,Hora_C_reg,Hora_C_next;
reg [7:0] Dia_reg, Dia_next,Mes_reg,Mes_next,Ano_reg,Ano_next;
reg Term_Lect_reg,Tr_Lect_reg,Tr_Lect_next; 
reg En_Lect_reg, En_Lect_next;
// creacion de los registros a utlizar para controlar las variables
always @( posedge clk, posedge reset)begin
	if (reset)begin
			ctrl_maquina <= 0;
			En_Lect_reg <= 0;
			Tr_Lect_reg <=0;
			Dato_Dir_reg <= 0;
			Seg_C_reg <= 0;
			Min_C_reg <= 0;
			Hora_C_reg <= 0;
			Mes_reg <= 0;
			Dia_reg <= 0;
			Ano_reg <= 0;
	end
	else begin
			ctrl_maquina <= ctrl_maquina_next;
			En_Lect_reg <= En_Lect_next;
			Dato_Dir_reg <= Dato_Dir_next;
			Tr_Lect_reg <= Tr_Lect_next;
			Seg_C_reg <= Seg_C_next;
			Min_C_reg <= Min_C_next;
			Hora_C_reg <= Hora_C_next;
			Dia_reg <= Dia_next;
			Mes_reg <= Mes_next;
			Ano_reg <= Ano_next;
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
			Term_Lect_reg = 0;
			Dia_next = Dia_reg;
			Tr_Lect_next = Tr_Lect_reg;
			Mes_next = Mes_reg;
			Ano_next = Ano_reg;
      case (ctrl_maquina)
			
            s0 : begin
				////////// Estado general, espera la senal de lectura para empezar el proceso////////////
						Dato_Dir_next = 8'b11111111;
				  if (Lectura) begin
						Term_Lect_reg = 0;
                  ctrl_maquina_next = s1;
						En_Lect_next = 1;end
               else 
						ctrl_maquina_next = ctrl_maquina_next; 
                  En_Lect_next = 0;
						end
				s1 : begin
			//////////// Estado de escritura del comando de transferencia del clock o el timer a la RAM
               if(En_clk) begin
						if (DIR) 
							Dato_Dir_next = 8'b11110001;
						else if (DAT) begin
							Tr_Lect_next = 1;
							Dato_Dir_next = 8'b00000001; end
						else if (cambio_estado) begin
							 ctrl_maquina_next = s2;
							 Tr_Lect_next = 0;
							  En_Lect_next = 0; end
						else begin
							 En_Lect_next =  1;
							ctrl_maquina_next = ctrl_maquina_next;  end							
							end 
					else begin
							if (DIR) 
								Dato_Dir_next = 8'b11110010;
							else if (DAT) begin
								Tr_Lect_next = 1;
								Dato_Dir_next = 8'b00000001;end
							else if (cambio_estado ) begin
								Tr_Lect_next = 0;
								ctrl_maquina_next = s2;
								  En_Lect_next = 0; end
							else begin
								 En_Lect_next =  1;
								ctrl_maquina_next = ctrl_maquina_next;  end							
								end end
             s2 : begin
			//////////// Estado de lectura del dato de segundos, tanto del clock como del timer
		//////////// Recibe de la maquina principal la direccion (clock o timer) donde lee y envia el valor a la salida	
               Seg_C_next = Seg_C_reg;
					if (DIR) 
						Dato_Dir_next = D_Seg;
               else if (DAT2)
						Seg_C_next = Dato_L;
					else if (cambio_estado ) begin	
						 ctrl_maquina_next = s3;
						  En_Lect_next = 0; end
					else begin
						 En_Lect_next =  1;
                  ctrl_maquina_next = ctrl_maquina_next;  end
						end
				 s3 : begin
			
			//////////// Estado de lectura del dato de minutosos, tanto del clock como del timer
		//////////// Recibe de la maquina principal la direccion (clock o timer) donde lee y envia el valor a la salida	 
              Min_C_next = Min_C_reg;
				  if (DIR) 
						Dato_Dir_next = D_Min;
               else if (DAT2)
						Min_C_next = Dato_L ;
					else if (cambio_estado ) begin	
						 ctrl_maquina_next = s4;
						  En_Lect_next = 0; end
					else begin
						 En_Lect_next = 1;
                  ctrl_maquina_next = ctrl_maquina_next;  end	
						end
				 s4 : begin
			//////////// Estado de lectura del dato de hora, tanto del clock como del timer
		//////////// Recibe de la maquina principal la direccion (clock o timer) donde lee y envia el valor a la salida
               Hora_C_next = Hora_C_reg;
					if (DIR) 
						Dato_Dir_next = D_Hora;
               else if (DAT2)
						Hora_C_next = Dato_L;
					else if (cambio_estado ) begin	 
						 ctrl_maquina_next = s5;
						  En_Lect_next = 0; end
					else begin
						 En_Lect_next =  1;
                  ctrl_maquina_next = ctrl_maquina_next;  end	
						end
				 s5 : begin
			//////////// Estado de lectura del dato de dia del y envia el valor a la salida		 
               Dia_next = Dia_reg;
					if(En_clk) begin
						if (DIR) 
							Dato_Dir_next = 8'b00100100;
						else if (DAT2)
							Dia_next = Dato_L ;
						else if (cambio_estado ) begin	 
							 ctrl_maquina_next = s6;
							  En_Lect_next = 0; end
						else begin
							 En_Lect_next =  1;
							ctrl_maquina_next = ctrl_maquina_next;  end	end
					else begin	 
							 ctrl_maquina_next = s6;
							  En_Lect_next = 0;
							  end		end
				 s6 : begin
			//////////// Estado de lectura del dato de mes del y envia el valor a la salida	
					Mes_next = Mes_reg;
					if(En_clk) begin
						if (DIR) 
							Dato_Dir_next = 8'b00100101;
						else if (DAT2) 
							Mes_next = Dato_L;
						else if (cambio_estado ) begin	 
							 ctrl_maquina_next = s7;
							  En_Lect_next = 0; end
						else begin
							 En_Lect_next =  1;
							ctrl_maquina_next = ctrl_maquina_next;  end	
							end 
					else begin	 
						 ctrl_maquina_next = s7;
						  En_Lect_next = 0;
						  end end
				 s7 : begin
			//////////// Estado de lectura del dato de ano del y envia el valor a la salida	
				 Ano_next = Ano_reg;
				 if(En_clk) begin
						if (DIR) 
							Dato_Dir_next = 8'b00100110;
						else if (DAT2)
							Ano_next = Dato_L ;
						else if (cambio_estado ) begin
							 Term_Lect_reg = 1;	
							 ctrl_maquina_next = s0;
							  En_Lect_next = 0; end
						else begin
							 En_Lect_next =  1;
							ctrl_maquina_next = ctrl_maquina_next;  end	
							end 
					else begin	 
						 ctrl_maquina_next = s0;
						 Term_Lect_reg = 1;	
						  En_Lect_next = 0;
						  end	
					end
					default : ctrl_maquina_next = s0;
         endcase
		end
	//////////////// Asignacion de las variables de salida//////////////	
	assign Seg_L = Seg_C_reg;
	assign Min_L = Min_C_reg;
	assign Hora_L = Hora_C_reg;
	assign Dia_L = Dia_reg;
	assign Mes_L = Mes_reg;
	assign Ano_L = Ano_reg;
	assign Dir_L = Dato_Dir_reg;
	assign E_Lect = En_Lect_reg;
	assign Tr_Lect = Tr_Lect_reg;
 /// Bandera que indica que se termino el proceso de escritura	
	assign Term_Lect = Term_Lect_reg; 
endmodule 
