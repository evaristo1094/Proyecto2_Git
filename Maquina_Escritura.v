`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:00:30 09/07/2016 
// Design Name: 
// Module Name:    Maquina_Escritura 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//gshehrweherh
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Maquina_Escritura(input wire clk, reset, En_clk, DAT,DIR,Escritura, cambio_estado, 
input wire [7:0] Seg,Min,Hora,Ano, Mes, Dia,D_Seg,D_Min,D_Hora,output wire  Term_Esc,E_esc, output wire [7:0] Dato_Dire );

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
//Registros Auxiliares a utilizar
reg [7:0] Dato_Dir_reg, Dato_Dir_next;
reg Term_Esc_reg;
reg En_Esc_reg, En_Esc_next;
// creacion de los registros a utlizar para controlar las variables
always @( posedge clk, posedge reset)
	if (reset)begin
			ctrl_maquina <= 0;
			Dato_Dir_reg <= 0;
			En_Esc_reg <= 0;
	end
	else begin
			ctrl_maquina <= ctrl_maquina_next;
			Dato_Dir_reg <= Dato_Dir_next;
			En_Esc_reg <= En_Esc_next;
	end
////////////////// Maquina de estados///////////////////
always@*
       begin
        ctrl_maquina_next = ctrl_maquina;
		  En_Esc_next = En_Esc_reg;
        Dato_Dir_next = Dato_Dir_reg;
		  Term_Esc_reg = 0;
      case (ctrl_maquina)
            s0 : begin
				////////// Estado general, espera la se;al de escritura para empezar el proceso////////////
               if (Escritura) begin
                  ctrl_maquina_next = s1;
						En_Esc_next = 1;end
               else begin
						ctrl_maquina_next = s0;
                  En_Esc_next = 0;
						Term_Esc_reg = 0;
						end		end
             s1 : begin
		//////////// Estado de escritura del dato de segundos, tanto del clock como del timer
		//////////// Recibe de la maquina principal la direccion (clock o timer) donde escribe y el valor		
               if (DIR) 
						Dato_Dir_next = D_Seg;
               else if (DAT)
						Dato_Dir_next = Seg;
					else if (cambio_estado )begin
						 ctrl_maquina_next = s2;
						 En_Esc_next =  0;end
					else begin
						 En_Esc_next =  1;
                  ctrl_maquina_next = s1;  end
						end
					s2 : begin
		//////////// Estado de escritura del dato de minutos, tanto del clock como del timer
		//////////// Recibe de la maquina principal la direccion (clock o timer) donde escribe y el valor
               if (DIR) 
						Dato_Dir_next = D_Min;
               else if (DAT)
						Dato_Dir_next = Min;
					else if (cambio_estado ) begin	
						 ctrl_maquina_next = s3;
						  En_Esc_next = 0; end
					else begin
						 En_Esc_next = 1;
                  ctrl_maquina_next = s2;  end	
						end
					s3 : begin
		//////////// Estado de escritura del dato de hora, tanto del clock como del timer
		//////////// Recibe de la maquina principal la direccion (clock o timer) donde escribe y el valor	
               if (DIR) 
						Dato_Dir_next = D_Hora;
               else if (DAT)
						Dato_Dir_next = Hora;
					else if (cambio_estado ) begin	 
						 ctrl_maquina_next = s4;
						  En_Esc_next = 0; end
					else begin
						 En_Esc_next =  1;
                  ctrl_maquina_next = s3;  end	
						end
					s4 : begin
		//////////// Estado de escritura del dato de dia del clock 
		//////////// Recibe de la maquina principal el valor a escribir	
					if(En_clk) begin
						if (DIR) 
							Dato_Dir_next = 8'b00100100;
						else if (DAT)
							Dato_Dir_next = Dia;
						else if (cambio_estado ) begin	 
							 ctrl_maquina_next = s5;
							  En_Esc_next = 0; end
						else begin
							 En_Esc_next =  1;
							ctrl_maquina_next = s4;  end	
							end
					else begin	 
							 ctrl_maquina_next = s5;
							  En_Esc_next = 0;
							  end end
					s5 : begin
			//////////// Estado de escritura del dato de mes del clock 
		//////////// Recibe de la maquina principal el valor a escribir
					if(En_clk) begin
						if (DIR) 
							Dato_Dir_next = 8'b00100101;
						else if (DAT) 
							Dato_Dir_next = Mes;
						else if (cambio_estado ) begin	 
							 ctrl_maquina_next = s6;
							  En_Esc_next = 0; end
						else begin
							 En_Esc_next =  1;
							ctrl_maquina_next = s5;  end	
							end 
					else begin	 
							 ctrl_maquina_next = s6;
							  En_Esc_next = 0;
							  end end
					s6 : begin
			//////////// Estado de escritura del dato de ano del clock 
		//////////// Recibe de la maquina principal el valor a escribir	
						if(En_clk) begin
							if (DIR) 
								Dato_Dir_next = 8'b00100110;
							else if (DAT)
								Dato_Dir_next = Ano;
							else if (cambio_estado ) begin
								 ctrl_maquina_next = s7;
								  En_Esc_next = 0; end
							else begin
								 En_Esc_next =  1;
								ctrl_maquina_next = s6;  end	
								end 
						else begin	 
							 ctrl_maquina_next = s7;
							  En_Esc_next = 0;
							  end end
					s7 : begin
			//////////// Estado de escritura del comando de traansferencia, tanto del clock como del timer 	
					if(En_clk) begin  // transferencia de la RAM al clock
						if (DIR) 
							Dato_Dir_next = 8'b11110001;
						else if (DAT)
							Dato_Dir_next = 8'b00000001;
						else if (cambio_estado ) begin
							 Term_Esc_reg = 1;	
							 ctrl_maquina_next = s0;
							  En_Esc_next = 0; end
						else begin
							 En_Esc_next =  1;
							ctrl_maquina_next = s7;  end							
							end 
					else begin // transferencia de la RAM al timer
						if (DIR) 
								Dato_Dir_next = 8'b11110010;
						else if (DAT)
							Dato_Dir_next = 8'b00000001;
						else if (cambio_estado ) begin
							 Term_Esc_reg = 1;	
							 ctrl_maquina_next = s0;
							  En_Esc_next = 0; end
						else begin
							 En_Esc_next =  1;
							ctrl_maquina_next = s7;  end							
							end end
					default : ctrl_maquina_next = s0;
         endcase
		end
//// Asignacion de los datos de salida/////////					
	assign Dato_Dire =  Dato_Dir_reg ;
	assign E_esc =  En_Esc_reg ;
	assign Term_Esc = Term_Esc_reg; //	// Bandera que indica que se termino el proceso de escritura
endmodule 