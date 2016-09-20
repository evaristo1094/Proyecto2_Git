`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:24:29 09/15/2016 
// Design Name: 
// Module Name:    Ingreso_Datos 
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
module Ingreso_Datos(
	input wire  clk,	reset,	 C_T,	disminuye,	aumenta,		escribe,	 corre_der,	corre_izq,	 doce_24,
	output wire [5:0] seg_C, min_C, hora_C, dia, mes, ano, seg_T, min_T, hora_T
	    );

	localparam [2:0] s0 = 3'b000,           
                    s1 = 3'b001,
                    s2 = 3'b010,
						  s3 = 3'b011,
						  s4 = 3'b100,
						  s5 = 3'b101,
						  s6 = 3'b110;
						  
//...........................................................
						  
	reg [3:0] seg_C_D_reg, seg_C_D_next,seg_C_U_reg, seg_C_U_next;
	reg [7:0] min_C_reg, min_C_next;
	reg [7:0] hora_C_reg, hora_C_next;
	reg [7:0] dia_reg, dia_next;
	reg [7:0] mes_reg, mes_next;
	reg [7:0] ano_reg, ano_next;
	reg [7:0] seg_T_reg, seg_T_next;
	reg [7:0] min_T_reg, min_T_next;
	reg [7:0] hora_T_reg, hora_T_next;
	reg [2:0] contador_maquina_reg, contador_maquina_next;
	
//...........................................................
	
	always @(posedge clk, posedge reset) begin
       if (reset) begin
          seg_C_reg <= 0;
			 min_C_reg <= 0;
			 hora_C_reg <= 0;
			 dia_reg <= 0;
			 mes_reg <= 0;
			 ano_reg <= 0;
			 seg_T_reg <= 0;
			 min_T_reg <= 0;
			 hora_T_reg <= 0;
			 contador_maquina_reg <= 0;
		end 
       else begin
          seg_C_reg <= seg_C_next; 
			 min_C_reg <= min_C_next;
	       hora_C_reg <= hora_C_next;
	       dia_reg <= dia_next;
	       mes_reg <= mes_next;
	       ano_reg <= ano_next;
	       seg_T_reg <= seg_T_next;
	       min_T_reg <= min_T_next;
	       hora_T_reg <= hora_T_next;
			 contador_maquina_reg <= contador_maquina_next;
			 end end
//...........................................................
					  
	always @* begin
		seg_C_next = seg_C_reg;
		min_C_next = min_C_reg;
		hora_C_next = hora_C_reg;
		dia_next = dia_reg;
		mes_next = mes_reg;
		ano_next = ano_reg;
		seg_T_next = seg_T_reg;
		min_T_next = min_T_reg;
		hora_T_next = hora_T_reg;
		contador_maquina_next = contador_maquina_reg;
		
//***********************ESTADO S0****************************		
		
      case (contador_maquina_next) 
         s0: begin
				if (escribe)
					contador_maquina_next = s1;
            else
					contador_maquina_next = contador_maquina_next;
					end
					
//***********************ESTADO S1 SEGUNDOS ****************************						
					
			s1: begin
				if(aumenta) begin
					if (C_T) begin
						if  (seg_C_D_next == 4'b0101 && seg_C_D_next == 4'b1001 )begin
						 seg_C_D_next = 0;
						 seg_C_U_next = 0;
						 end
						else	begin
							if (seg_C_U_next == 4'b1001)begin
							seg_D_next = seg_D_next + 1;
							seg_U_next = 0; end
							else 
								seg_U_next = seg_U_next + 1;
							end
					   end
						
					else begin 
						if  (seg_T_next == 8'b00111011)
						 seg_T_next = 0;
						else	seg_T_next = seg_T_next + 1;
						end
					end	
						
				else if(disminuye) begin
					if (C_T) begin
						if  (seg_C_next == 8'b00000000)
						 seg_C_next =  6'b111011;
						else	seg_C_next = seg_C_next - 1;
						end 
						
						
					else begin 
						if  (seg_T_next== 8'b00000000)
						 seg_T_next =  6'b111011;
						else	seg_T_next = seg_T_next - 1;
						end
					end
										
				else if (corre_der) 
					contador_maquina_next = s2;
				else if (corre_izq)
					contador_maquina_next = s6;
					else contador_maquina_next = contador_maquina_next;
					end 
				
//********************ESTADO S2 MINUTO**********************					
						
			s2: begin
				if(aumenta) begin
					if (C_T) begin
						if  (min_C_next==59)
						 min_C_next = 0;
						else	min_C_next = min_C_next + 1;
						end 
						
						
					else begin 
						if  (min_T_next==59)
						 min_T_next = 0;
						else	min_T_next = min_T_next + 1;
						end
					end
						
				else if (disminuye) begin
					if (C_T) begin
						if  (min_C_next==59)
						 min_C_next = 0;
						else	min_C_next = min_C_next - 1;
						end
						
						
					else begin 
						if  (min_T_next==59)
						 min_T_next = 0;
						else	min_T_next = min_T_next - 1;
						end
					end
					
				else if (corre_der) 
					contador_maquina_next = s3;
				else if (corre_izq)
					contador_maquina_next = s1;
					else contador_maquina_next = contador_maquina_next;
					end 
	
//*************ESTADO S3 HORA**********************************
//*********************************12	
			
			s3: begin
				if (12_24)
					if(aumenta) begin
						if (C_T) begin
							if  (hora_C_next==12)
							 hora_C_next = 0;
							else	hora_C_next = hora_C_next + 1;
							end
							
							
						else begin 
							if  (hora_T_next==12)
							 hora_T_next = 0;
							else	hora_T_next = hora_T_next + 1;
							end
						end
							
					else if (disminuye) begin
						if (C_T) begin
							if  (hora_C_next==12)
							 hora_C_next = 0;
							else	hora_C_next = hora_C_next - 1;
							end
							
							
						else begin 
							if  (hora_T_next==12)
							 hora_T_next = 0;
							else	hora_T_next = hora_T_next - 1;
							end
						end
							
//**********************24							
				else 
					if(aumenta) begin
						if (C_T) begin
							if  (hora_C_next==24)
							 hora_C_next = 0;
							else	hora_C_next = hora_C_next + 1;
							end
							
							
						else begin 
							if  (hora_T_next==24)
							 hora_T_next = 0;
							else	hora_T_next = hora_T_next + 1;
							end
						end
							
					else if (disminuye) begin
						if (C_T) begin
							if  (hora_C_next==24)
							 hora_C_next = 0;
							else	hora_C_next = hora_C_next - 1;
							end
					
							
							
						else begin 
							if  (hora_T_next==24)
							 hora_T_next = 0;
							else	hora_T_next = hora_T_next - 1;
							end
						end
			
					
				else if (corre_der) 
					contador_maquina_next = s4;
				else if (corre_izq)
					contador_maquina_next = s2;
					else contador_maquina_next = contador_maquina_next;
					end 
								 
//*************************************ESTADO S4 DIA*******************************


			s4: begin
				if(aumenta) begin
					if  (dia_next == 31) 
					 dia_next=0;
					else	dia_next = dia_next + 1;
					end 
													
				else if (disminuye) begin
					if  (dia_next==31)
						 dia_next = 1;
					else	dia_next = dia_next - 1;
					end
				
						
																
				else if (corre_der) 
					contador_maquina_next = s5;
				else if (corre_izq) 
					contador_maquina_next = s3;
						else contador_maquina_next = contador_maquina_next;
						end 
				
			
//*******************************ESTADO S5 MES************************************
			
			
			s5: begin
				if(aumenta) begin
					if  (mes_next==12)
					     mes_next = 1;
					else	mes_next = mes_next + 1;
					end
													
				else if (disminuye) begin
					if  (mes_next==12)
						 mes_next = 1;
					else	mes_next = mes_next - 1;
					end
				
						
																
				else if (corre_der) 
					contador_maquina_next = s6;
				else if (corre_izq) 
					contador_maquina_next = s4;
						else contador_maquina_next = contador_maquina_next;
						end 
				
			
//*******************************ESTADO S6 ANO************************************
			
			
			s6: begin
				if(aumenta) begin
					if  (ano_next==99)
					     ano_next = 0;
					else	ano_next = ano_next + 1;
					end
													
				else if (disminuye) begin
					if  (ano_next==99)
						 ano_next = 0;
					else	ano_next = ano_next - 1;
					end
				
						
																
				else if (corre_der) 
					contador_maquina_next = s1;
				else if (corre_izq)  
					contador_maquina_next = s5;
						else contador_maquina_next = contador_maquina_next;
						end 
			
						
         default: contador_maquina_next = s0;
      endcase					  
		end				  
//..............................................................
  
	assign seg_C = seg_C_reg;
	assign min_C = min_C_reg;
	assign hora_C = hora_C_reg;
	assign dia = dia_reg;
	assign mes = mes_reg;
	assign ano = ano_reg;
	assign seg_T = seg_T_reg;
	assign min_T = min_T_reg;
	assign hora_T = hora_T_reg;	
	
endmodule

