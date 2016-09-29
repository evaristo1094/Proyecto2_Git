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
module Maquina_Escritura(input wire clk, reset,
En_clk, 			// habilitador de escritura de timer o clock, viene de la maquina principal
DAT,DIR,Escritura, cambio_estado,doce_24C,inicializador, 
input wire [7:0] Seg,Min,Hora,Ano, Mes, Dia,D_Seg,D_Min,D_Hora,output wire  Term_Esc,E_esc, output wire [7:0] Dato_Dire );

// Variables del control de la maquina de estados

localparam [3:0] 	s0 = 4'b0000, 
						s1 = 4'b0001,
						s2 = 4'b0010,
						s3 = 4'b0011,
						s4 = 4'b0100,
						s5 = 4'b0101,
						s6 = 4'b0110,
						s7 = 4'b0111,
						s8 = 4'b1000;
						
localparam [4:0] 	i0 = 5'b00000, 
						i1 = 5'b00001,
						i2 = 5'b00010,
						i3 = 5'b00011,
						i4 = 5'b00100,
						i5 = 5'b00101,
						i6 = 5'b00110,
						i7 = 5'b00111,
						i8 = 5'b01000, 
						i9 = 5'b10001,
						i10 = 5'b01010,
						i11 = 5'b01011,
						i12 = 5'b01100,
						i13 = 5'b01101,
						i14 = 5'b01110,
						i15 = 5'b01111,	
						i16 = 5'b10000;							

// contador de la maquina
reg [3:0] ctrl_maquina, ctrl_maquina_next;
reg [4:0] ctrl_inic, ctrl_inic_next;
//Registros Auxiliares a utilizar
reg [7:0] Dato_Dir_reg, Dato_Dir_next;
reg Term_Esc_reg;
reg En_Esc_reg, En_Esc_next;

// creacion de los registros a utlizar para controlar las variables
always @( posedge clk, posedge reset)
	if (reset)begin
			ctrl_maquina <= 0;
			ctrl_inic <= 0;
			Dato_Dir_reg <= 0;
			En_Esc_reg <= 0;
			
	end
	else begin
			ctrl_maquina <= ctrl_maquina_next;
			Dato_Dir_reg <= Dato_Dir_next;
			En_Esc_reg <= En_Esc_next;
			ctrl_inic <= ctrl_inic_next;
			
	end

///////////////// Maquina de estados///////////////////
	
always@*
       begin
        ctrl_maquina_next = ctrl_maquina;
		  En_Esc_next = En_Esc_reg;
        Dato_Dir_next = Dato_Dir_reg;
		  Term_Esc_reg = 0;
		  ctrl_inic_next = ctrl_inic;
	////// Inicializacion de los registros////////////	  
 if (inicializador) begin
//	En_Esc_next = 0;
			case (ctrl_inic)
					i0: begin
						 if (inicializador) begin
							ctrl_inic_next = i1;
							En_Esc_next = 0;end
						else 	begin
							ctrl_inic_next = i0;
							 En_Esc_next = 0;
							end
							end
					i1: begin
						 if (inicializador) begin
							ctrl_inic_next = i2;
							En_Esc_next = 1;end
						else 	begin
							ctrl_inic_next = i1;
							 En_Esc_next = 0;
							end
							end		
					i2: begin
						 if (DIR) 
							Dato_Dir_next = 8'b00000010;
						else if (DAT)
							Dato_Dir_next = 8'b00010000;
						else if (cambio_estado ) begin
							 En_Esc_next =  0;
							 ctrl_inic_next = i3; end
						else 	
							En_Esc_next =  1;
							end
					i3:	begin 
							if (DIR) 
								Dato_Dir_next = 8'b00000010;
							else if (DAT)
								Dato_Dir_next = 8'b00000000;
							else if (cambio_estado ) begin
								 En_Esc_next =  0;
								 ctrl_inic_next = i4;	end
							else 	
								En_Esc_next =  1;
								end
					i4: begin
							if (DIR) 
								Dato_Dir_next = 8'b00010000;
							else if (DAT)
								Dato_Dir_next = 8'b11010010;
							else if (cambio_estado ) begin
								 En_Esc_next =  0;
								 ctrl_inic_next = i5;
								end
							else 	
								En_Esc_next =  1;
								end
					i5: begin
							if (DIR) 
								Dato_Dir_next = 8'b00010000;
							else if (DAT)
								Dato_Dir_next = 8'b00000000;
							else if (cambio_estado ) begin
								 En_Esc_next =  0;
								 ctrl_inic_next = i6;
								end
							else 	
								En_Esc_next =  1;
								end	
								
					i6: begin
							if (DIR) 
								Dato_Dir_next = 8'b00100001;
							else if (DAT)
								Dato_Dir_next = 8'b00000000;
							else if (cambio_estado ) begin
								 En_Esc_next =  0;
								 ctrl_inic_next = i7;
								end
							else 	
								En_Esc_next =  1;
								end	
					i7: begin
						 if (DIR) 
							Dato_Dir_next = 8'b00100010;
						else if (DAT)
							Dato_Dir_next = 8'b00000000;
						else if (cambio_estado ) begin
							 En_Esc_next =  0;
							 ctrl_inic_next = i8; end
						else 	
							En_Esc_next =  1;
							end
					i8:	begin 
							if (DIR) 
								Dato_Dir_next = 8'b00100011;
							else if (DAT)
								Dato_Dir_next = 8'b00000000;
							else if (cambio_estado ) begin
								 En_Esc_next =  0;
								 ctrl_inic_next = i9;	end
							else 	
								En_Esc_next =  1;
								end
					i9: begin
							if (DIR) 
								Dato_Dir_next = 8'b00100100;
							else if (DAT)
								Dato_Dir_next = 8'b00000000;
							else if (cambio_estado ) begin
								 En_Esc_next =  0;
								 ctrl_inic_next = i10;
								end
							else 	
								En_Esc_next =  1;
								end
					i10: begin
							if (DIR) 
								Dato_Dir_next = 8'b00100101;
							else if (DAT)
								Dato_Dir_next = 8'b00000000;
							else if (cambio_estado ) begin
								 En_Esc_next =  0;
								 ctrl_inic_next = i11;
								end
							else 	
								En_Esc_next =  1;
								end	
								
					i11: begin
							if (DIR) 
								Dato_Dir_next = 8'b00100110;
							else if (DAT)
								Dato_Dir_next = 8'b00000000;
							else if (cambio_estado ) begin
								 En_Esc_next =  0;
								 ctrl_inic_next = i12;
								end
							else 	
								En_Esc_next =  1;
								end				
					
					i12: begin
							if (DIR) 
								Dato_Dir_next = 8'b01000001;
							else if (DAT)
								Dato_Dir_next = 8'b00000000;
							else if (cambio_estado ) begin
								 En_Esc_next =  0;
								 ctrl_inic_next = i13;
								end
							else 	
								En_Esc_next =  1;
								end				
					i13: begin
							if (DIR) 
								Dato_Dir_next = 8'b01000010;
							else if (DAT)
								Dato_Dir_next = 8'b00000000;
							else if (cambio_estado ) begin
								 En_Esc_next =  0;
								 ctrl_inic_next = i14;
								end
							else 	
								En_Esc_next =  1;
								end				
						
					i14: begin
							if (DIR) 
								Dato_Dir_next = 8'b01000011;
							else if (DAT)
								Dato_Dir_next = 8'b00000000;
							else if (cambio_estado ) begin
								 En_Esc_next =  0;
								 ctrl_inic_next = i15;
								end
							else 	
								En_Esc_next =  1;
								end	
					i15: begin
							if (DIR) 
								Dato_Dir_next = 8'b11110000;
							else if (DAT)
								Dato_Dir_next = 8'b00000000;
							else if (cambio_estado ) begin
								 En_Esc_next =  0;
								 ctrl_inic_next = i16;
								end
							else 	
								En_Esc_next =  1;
								end									
					i16:begin
						ctrl_inic_next = i0;
						 En_Esc_next =  0;
						 end
					default : ctrl_inic_next = i0;
         endcase			
end		
else begin			 
//////////// Inicio de la maquina de estados de escritura//////////////////		
			ctrl_inic_next = i0;	
      case (ctrl_maquina)
            s0 : begin
				////////// Estado general, espera la senal de escritura para empezar el proceso////////////
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
							 ctrl_maquina_next = s8;
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
							 ctrl_maquina_next = s8;
							  En_Esc_next = 0; end
						else begin
							 En_Esc_next =  1;
							ctrl_maquina_next = s7;  end							
							end end
				s8 : begin
		//////////// Estado de configuracion del formato de hora (12/24) y habilitacion del timer		
               if (DIR) 
						Dato_Dir_next = 8'b00000000;
               else if (DAT) begin
						if (En_clk)begin
							if (doce_24C)
								Dato_Dir_next = 8'b00010000;
							else 
								Dato_Dir_next = 8'b00000000;
							end	
						else begin
							if (doce_24C)
								Dato_Dir_next = 8'b00011000;
							else 
								Dato_Dir_next = 8'b00001000;
							end
						end
					else if (cambio_estado )begin
						 ctrl_maquina_next = s0;
						 Term_Esc_reg = 1;
						 En_Esc_next =  0;end
					else begin
						 En_Esc_next =  1;
                  ctrl_maquina_next = s8;  end
						end
					default : ctrl_maquina_next = s0;
         endcase
			end
			end
//// Asignacion de los datos de salida/////////					
	assign Dato_Dire =  Dato_Dir_reg ;
	assign E_esc =  En_Esc_reg ;
	assign Term_Esc = Term_Esc_reg; //	// Bandera que indica que se termino el proceso de escritura
endmodule 