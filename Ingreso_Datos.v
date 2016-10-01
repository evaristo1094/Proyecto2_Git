`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:54:03 09/22/2016 
// Design Name: 
// Module Name:    Ingreso_datos 
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
	input wire  clk, reset,	 C_T,	disminuye,	aumenta,		escribe,	 corre_der,	corre_izq, doce_24,
	output wire [7:0] seg_C, min_C, hora_C, dia, mes, ano, seg_T, min_T, hora_T, hora_TVGA,seg_TVGA,min_TVGA,
	output reg cursor_seg, cursor_min, cursor_hora, cursor_mes, cursor_dia, cursor_ano,
	cursor_T_seg, cursor_T_min, cursor_T_hora
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
	reg [3:0] min_C_D_reg, min_C_D_next, min_C_U_reg, min_C_U_next;
	reg [3:0] hora_C_D_reg, hora_C_D_next, hora_C_U_reg, hora_C_U_next;
	reg [3:0] dia_D_reg, dia_D_next, dia_U_reg, dia_U_next;
	reg [3:0] mes_D_reg, mes_D_next, mes_U_reg, mes_U_next;
	reg [3:0] ano_D_reg, ano_D_next, ano_U_reg, ano_U_next;
	reg [3:0] seg_T_D_reg, seg_T_D_next, seg_T_U_reg, seg_T_U_next;
	reg [3:0] min_T_D_reg, min_T_D_next, min_T_U_reg, min_T_U_next;
	reg [3:0] hora_T_D_reg, hora_T_D_next, hora_T_U_reg, hora_T_U_next;
	reg [2:0] contador_maquina_reg, contador_maquina_next;
	reg PM,PM_next;
//...........................................................
	
	always @(posedge clk, posedge reset) begin
       if (reset) begin
          seg_C_D_reg <= 0;
			 seg_C_U_reg <= 0;
			 min_C_D_reg <= 0;
			 min_C_U_reg <= 0;
			 hora_C_D_reg <= 0;
			 hora_C_U_reg <= 0;
			 dia_D_reg <= 0;
			 dia_U_reg <= 1;
			 mes_D_reg <= 0;
			 mes_U_reg <= 1;
			 ano_D_reg <= 0;
			 ano_U_reg <= 0;
			 seg_T_D_reg <= 0;
			 seg_T_U_reg <= 0;
			 min_T_D_reg <= 0;
			 min_T_U_reg <= 0;
			 hora_T_D_reg <= 0;
			 hora_T_U_reg <= 0;
			 contador_maquina_reg <= 0;
			 PM <=0;
		end 
       else begin
          seg_C_D_reg <= seg_C_D_next; 
			 seg_C_U_reg <= seg_C_U_next; 
			 min_C_D_reg <= min_C_D_next;
			 min_C_U_reg <= min_C_U_next;
	       hora_C_D_reg <= hora_C_D_next;
			 hora_C_U_reg <= hora_C_U_next;
	       dia_D_reg <= dia_D_next;
			 dia_U_reg <= dia_U_next;
	       mes_D_reg <= mes_D_next;
			 mes_U_reg <= mes_U_next;
	       ano_D_reg <= ano_D_next;
			 ano_U_reg <= ano_U_next;
	       seg_T_D_reg <= seg_T_D_next;
			 seg_T_U_reg <= seg_T_U_next;
	       min_T_D_reg <= min_T_D_next;
			 min_T_U_reg <= min_T_U_next;
	       hora_T_D_reg <= hora_T_D_next;
			 hora_T_U_reg <= hora_T_U_next;
			 contador_maquina_reg <= contador_maquina_next;
			 PM <= PM_next;
			 end end
//...........................................................
					  
	always @* begin
		seg_C_D_next =  seg_C_D_reg;
		seg_C_U_next = seg_C_U_reg;
		min_C_D_next =  min_C_D_reg;
		min_C_U_next = min_C_U_reg;
		hora_C_D_next = hora_C_D_reg;
		hora_C_U_next = hora_C_U_reg;
		dia_D_next = dia_D_reg;
		dia_U_next = dia_U_reg;
		mes_D_next = mes_D_reg;
		mes_U_next = mes_U_reg;
		ano_D_next = ano_D_reg;
		ano_U_next = ano_U_reg;
		seg_T_D_next = seg_T_D_reg;
		seg_T_U_next = seg_T_U_reg;
		min_T_D_next = min_T_D_reg;
		min_T_U_next = min_T_U_reg;
		hora_T_D_next = hora_T_D_reg;
		hora_T_U_next = hora_T_U_reg;
		contador_maquina_next = contador_maquina_reg;
		cursor_seg = 0;
		cursor_min = 0;
		cursor_hora = 0;
		cursor_dia = 0;
		cursor_mes = 0;
		cursor_ano = 0;
		cursor_T_seg = 0;
		cursor_T_min = 0;
		cursor_T_hora = 0;
		PM_next = PM;
//***********************ESTADO S0****************************		
		
      case (contador_maquina_next)
			
			s0: begin
				if (escribe)
					contador_maquina_next = s1;
            else begin
					if (aumenta) begin
						seg_T_D_next = 4'b1000;
						min_T_D_next = 4'b1000; end
					else begin
						contador_maquina_next = contador_maquina_reg;
						cursor_seg = 0;
						cursor_min = 0;
						cursor_hora = 0;
						cursor_dia = 0;
						cursor_mes = 0;
						cursor_ano = 0;
						cursor_T_seg = 0;
						cursor_T_min = 0;
						cursor_T_hora = 0; end
					end
			end
					
//***********************ESTADO S1 SEGUNDOS ****************************						
					
			s1: begin
				if(aumenta) begin
					if (C_T) begin
				//	seg_C_D_next = seg_C_D_reg;	
						if  ((seg_C_D_next == 4'b0101 && seg_C_U_next == 4'b1001) | seg_C_D_next == 4'b1100 )begin
						 seg_C_D_next = 0;
						 seg_C_U_next = 0;
						 end
						else	begin
							if (seg_C_U_next == 4'b1001)begin
							seg_C_D_next = seg_C_D_next + 4'b1;
							seg_C_U_next = 0; end
							else 
								seg_C_U_next = seg_C_U_next + 4'b1;
							end
					   end
						
					else begin 
					//seg_T_D_next = seg_T_D_reg;
						if  ((seg_T_D_next == 4'b0101 && seg_T_U_next == 4'b1001) || seg_T_D_next == 4'b1000)begin
						 seg_T_D_next = 0;
						 seg_T_U_next = 0;
						 end
						else	begin
							if (seg_T_U_next == 4'b1001)begin
							seg_T_D_next = seg_T_D_next + 4'b1;
							seg_T_U_next = 0; end
							else 
								seg_T_U_next = seg_T_U_next + 4'b1;
							end
						end
					end
						
				else if(disminuye) begin
					if (C_T) begin
						if  ((seg_C_D_next == 4'b0000 && seg_C_U_next == 4'b0000))begin
						 seg_C_D_next = 4'b0101;
						 seg_C_U_next = 4'b1001;
						 end
						else	begin
							if (seg_C_U_next == 4'b0000)begin
							seg_C_D_next = seg_C_D_next - 4'b1;
							seg_C_U_next = 4'b1001 ; end
							else 
								seg_C_U_next = seg_C_U_next - 4'b1;
							end
						end
				
					else begin 
						if  ((seg_T_D_next == 4'b0000 && seg_T_U_next == 4'b0000) | seg_T_D_next == 4'b1000 )begin
						 seg_T_D_next = 4'b0101;
						 seg_T_U_next = 4'b1001;
						 end
						else	begin
							if (seg_T_U_next == 4'b0000)begin
							seg_T_D_next = seg_T_D_next - 4'b1;
							seg_T_U_next = 4'b1001; end
							else 
								seg_T_U_next = seg_T_U_next - 4'b1;
							end
						end
					end
							
				else if (corre_der) 
					contador_maquina_next = s2;
				else if (corre_izq)begin
					if(C_T)
						contador_maquina_next = s6;
					else 
						contador_maquina_next = s3;
					end
				else if (~escribe)
					contador_maquina_next = s0;	
				else begin 
					contador_maquina_next = contador_maquina_next;
					if(C_T)begin
						cursor_seg = 1;
						cursor_min = 0;
						cursor_T_seg = 0;
						cursor_T_min = 0;
						cursor_ano = 0; end
					else begin
						cursor_seg = 0;
						cursor_min = 0;
						cursor_T_seg = 1;
						cursor_T_min = 0;
						cursor_ano = 0;					
					end 
				end
				end
//********************ESTADO S2 MINUTO**********************					
						
			s2: begin
				if(aumenta) begin
					if (C_T) begin
						//min_C_D_next = min_C_D_reg;
						if  ((min_C_D_next == 4'b0101 && min_C_U_next == 4'b1001) | min_C_D_next == 4'b1000 )begin
						 min_C_D_next = 0;
						 min_C_U_next = 0;
						 end
						else	begin
							if (min_C_U_next == 4'b1001)begin
							min_C_D_next = min_C_D_next + 4'b1;
							min_C_U_next = 0; end
							else 
								min_C_U_next = min_C_U_next + 4'b1;
							end
					   end
						
					else begin 
					//min_T_D_next = min_T_D_reg;
						if  ((min_T_D_next == 4'b0101 && min_T_U_next == 4'b1001)| min_T_D_next == 4'b1000 )begin
						 min_T_D_next = 0;
						 min_T_U_next = 0;
						 end
						else	begin
							if (min_T_U_next == 4'b1001)begin
							min_T_D_next = min_T_D_next + 4'b1;
							min_T_U_next = 0; end
							else 
								min_T_U_next = min_T_U_next + 4'b1;
							end
						end
					end
						
				else if(disminuye) begin
					if (C_T) begin
						if  (min_C_D_next == 4'b0000 && min_C_U_next == 4'b0000 )begin
						 min_C_D_next = 4'b0101;
						 min_C_U_next = 4'b1001;
						 end
						else	begin
							if (min_C_U_next == 4'b0000)begin
							min_C_D_next = min_C_D_next - 4'b1;
							min_C_U_next = 4'b1001 ; end
							else 
								min_C_U_next = min_C_U_next - 4'b1;
							end
						end
											
						
					else begin 
						if  ((min_T_D_next == 4'b0000 && min_T_U_next == 4'b0000) | min_T_D_next == 4'b1000 )begin
						 min_T_D_next = 4'b0101;
						 min_T_U_next = 4'b1001;
						 end
						else	begin
							if (min_T_U_next == 4'b0000)begin
							min_T_D_next = min_T_D_next - 4'b1;
							min_T_U_next = 4'b1001; end
							else 
								min_T_U_next = min_T_U_next - 4'b1;
							end
						end
					end
					
					
				else if (corre_der) 
					contador_maquina_next = s3;
				else if (corre_izq)
					contador_maquina_next = s1;
				else if (~escribe)
					contador_maquina_next = s0;	
				else begin 
					contador_maquina_next = contador_maquina_next;
					if(C_T)begin
						cursor_seg = 0;
						cursor_min = 1;
						cursor_T_seg = 0;
						cursor_T_min = 0;
						cursor_hora = 0;
						cursor_T_hora = 0;	 end
					else begin
						cursor_seg = 0;
						cursor_min = 0;
						cursor_T_seg = 0;
						cursor_T_min = 1;
						cursor_hora = 0;
						cursor_T_hora = 0;					
					end 
				end
				end
	
//*************ESTADO S3 HORA**********************************
//*********************************12	
			
			s3: begin
					if(aumenta) begin
	//**********************12*******************************************			
						if (doce_24) begin
							if (C_T) begin
								if  (hora_C_D_next [2:0] >= 3'b001 && hora_C_U_next >= 4'b0010 )begin
									 PM_next = ~PM;
									 hora_C_D_next = {PM_next,3'b000};
									 hora_C_U_next = 4'b0001;
								 end
								 
								else	begin
									if (hora_C_U_next == 4'b1001)begin
										hora_C_D_next [2:0] = 3'b001;
										hora_C_U_next = 0; end
									else 
										hora_C_U_next = hora_C_U_next + 4'b1;
									end
								end
								
							else begin 
								if  (hora_T_D_next == 4'b0010 && hora_T_U_next == 4'b0011  )begin
									 hora_T_D_next = 0;
									 hora_T_U_next = 4'b0000;
								 end
								else	begin
									if (hora_T_U_next == 4'b1001)begin
										hora_T_D_next = hora_T_D_next + 4'b1;
										hora_T_U_next = 0; end
									else 
										hora_T_U_next = hora_T_U_next + 4'b1;
									end
							end
						end
	//**********************24*******************************************				
						else begin
							if (C_T) begin
								if  (hora_C_D_next == 4'b0010 && hora_C_U_next == 4'b0011 )begin
									 hora_C_D_next = 0;
									 hora_C_U_next = 0;
								 end
								
								else	begin
									if (hora_C_U_next == 4'b1001)begin
										hora_C_D_next = hora_C_D_next + 4'b1;
										hora_C_U_next = 0; end
									else 
										hora_C_U_next = hora_C_U_next + 4'b1;
									end
								end
								
							else begin 
								if  (hora_T_D_next == 4'b0010 && hora_T_U_next == 4'b0011 )begin
									 hora_T_D_next = 0;
									 hora_T_U_next = 0;
								 end
								else	begin
									if (hora_T_U_next == 4'b1001)begin
										hora_T_D_next = hora_T_D_next + 4'b1;
										hora_T_U_next = 0; end
									else 
										hora_T_U_next = hora_T_U_next + 4'b1;
									end
								end
							end	
						end
					else if(disminuye) begin
		//**********************12*******************************************	
						if (doce_24) begin
							if (C_T) begin
								
								if  (hora_C_D_next [2:0] == 3'b000 &&( hora_C_U_next == 4'b0001 | hora_C_U_next == 4'b0000) )begin
								 PM_next = ~PM;
								 hora_C_D_next = {PM_next,3'b001};
								 hora_C_U_next = 4'b0010;
								 end
								else	begin
									if (hora_C_U_next == 4'b0000)begin
										hora_C_D_next [2:0] = 3'b000;
										hora_C_U_next = 4'b1001 ; end
									else 
										hora_C_U_next = hora_C_U_next - 4'b1;
									end
								end
													
								
							else begin 
								if  (hora_T_D_next == 4'b0000 && hora_T_U_next == 4'b0000)begin
									 hora_T_D_next = 4'b0010;
									 hora_T_U_next = 4'b0011;
								 end
							else	begin
									if (hora_T_U_next == 4'b0000)begin
										hora_T_D_next = hora_T_D_next - 4'b1;
										hora_T_U_next = 4'b1001; end
									else 
										hora_T_U_next = hora_T_U_next - 4'b1;
									end
								end
							end
		//**********************24*******************************************						
					else begin
					if (C_T) begin
							if  (hora_C_D_next == 4'b0000 && hora_C_U_next == 4'b0000 )begin
								 hora_C_D_next = 4'b0010;
								 hora_C_U_next = 4'b0011;
							 end
							else	begin
								if (hora_C_U_next == 4'b0000)begin
									hora_C_D_next = hora_C_D_next - 4'b1;
									hora_C_U_next = 4'b1001 ; end
								else 
									hora_C_U_next = hora_C_U_next - 4'b1;
								end
							end
												
							
						else begin 
							if  (hora_T_D_next == 4'b0000 && hora_T_U_next == 4'b0000 )begin
								 hora_T_D_next = 4'b0010;
								 hora_T_U_next = 4'b0011;
							 end
							else	begin
								if (hora_T_U_next == 4'b0000)begin
								hora_T_D_next = hora_T_D_next - 4'b1;
								hora_T_U_next = 4'b1001; end
								else 
									hora_T_U_next = hora_T_U_next - 4'b1;
								end
							end
						end
					end
					
				else if (corre_der) begin
					if(C_T)
						contador_maquina_next = s4;
					else 
						contador_maquina_next = s1;
					end	
				else if (corre_izq)
					contador_maquina_next = s2;
				else if (~escribe)
					contador_maquina_next = s0;	
				else begin 
					contador_maquina_next = contador_maquina_next;
					if(C_T)begin
						cursor_dia = 0;
						cursor_min = 0;
						cursor_T_min = 0;
						cursor_hora = 1;
						cursor_T_hora = 0;	 end
					else begin
						cursor_dia = 0;
						cursor_min = 0;
						cursor_T_min = 0;
						cursor_hora = 0;
						cursor_T_hora = 1;					
					end 
				end
				end			 
//*************************************ESTADO S4 DIA*******************************


			s4: begin
				if(aumenta) begin
					if  (dia_D_next == 4'b0011 && dia_U_next == 4'b0001 )begin
						 dia_D_next = 0;
						 dia_U_next = 4'b0001;
						 end
					else	begin
						if (dia_U_next == 4'b1001)begin
						dia_D_next = dia_D_next + 4'b1;
						dia_U_next = 0; end
						else 
							dia_U_next = dia_U_next + 4'b1;
						end
					  end
													
				else if (disminuye) begin
					if  (dia_D_next == 4'b0000 && dia_U_next == 4'b0001 )begin
						 dia_D_next = 4'b0011;
						 dia_U_next = 4'b0001;
						 end
					else	begin
						if (dia_U_next == 4'b0000)begin
						dia_D_next = dia_D_next - 4'b1;
						dia_U_next = 4'b1001 ; end
							else 
								dia_U_next = dia_U_next - 4'b1;
							end
						end
															
				else if (corre_der) 
					contador_maquina_next = s5;
				else if (corre_izq) 
					contador_maquina_next = s3;
				else if (~escribe)
					contador_maquina_next = s0;	
				else begin 
					contador_maquina_next = contador_maquina_next;
						cursor_dia = 1;
						cursor_mes = 0;
						cursor_hora = 0;
						cursor_T_hora = 0;	 
						end
				end
				
			
//*******************************ESTADO S5 MES************************************
			
			s5: begin
				if(aumenta) begin
					if  (mes_D_next == 4'b0001 && mes_U_next == 4'b0010 )begin
						 mes_D_next = 0;
						 mes_U_next = 4'b0001;
						 end
						else	begin
							if (mes_U_next == 4'b1001)begin
							mes_D_next = mes_D_next + 4'b1;
							mes_U_next = 0; end
							else 
								mes_U_next = mes_U_next + 4'b1;
							end
					   end
													
				else if (disminuye) begin
					if  (mes_D_next == 4'b0000 && mes_U_next == 4'b0001 )begin
						 mes_D_next = 4'b0001;
						 mes_U_next = 4'b0010;
						 end
						else	begin
							if (mes_U_next == 4'b0000)begin
							mes_D_next = mes_D_next - 4'b1;
							mes_U_next = 4'b1001 ; end
							else 
								mes_U_next = mes_U_next - 4'b1;
							end
						end
												
				else if (corre_der) 
					contador_maquina_next = s6;
				else if (corre_izq) 
					contador_maquina_next = s4;
				else if (~escribe)
					contador_maquina_next = s0;	
				else begin 
						contador_maquina_next = contador_maquina_next;
						cursor_dia = 0;
						cursor_mes = 1;
						cursor_ano = 0; 
						end
				end				
			
//*******************************ESTADO S6 ANO************************************
			
			
			s6: begin
				if(aumenta) begin
					if  (ano_D_next == 4'b1001 && ano_U_next == 4'b1001 )begin
						 ano_D_next = 0;
						 ano_U_next = 0;
						 end
						else	begin
							if (ano_U_next == 4'b1001)begin
							ano_D_next = ano_D_next + 4'b1;
							ano_U_next = 0; end
							else 
								ano_U_next = ano_U_next + 4'b1;
							end
					   end
													
				else if (disminuye) begin
					if  (ano_D_next == 4'b0000 && ano_U_next == 4'b0000 )begin
						 ano_D_next = 4'b1001;
						 ano_U_next = 4'b1001;
						 end
						else	begin
							if (ano_U_next == 4'b0000)begin
							ano_D_next = ano_D_next - 4'b1;
							ano_U_next = 4'b1001 ; end
							else 
								ano_U_next = ano_U_next - 4'b1;
							end
						end
								
				else if (corre_der) 
					contador_maquina_next = s1;
				else if (corre_izq)  
					contador_maquina_next = s5;
				else if (~escribe)
					contador_maquina_next = s0;	
				else begin 
					contador_maquina_next = contador_maquina_next;
						cursor_seg = 0;
						cursor_mes = 0;
						cursor_ano = 1;
						cursor_T_seg = 0;	 
						end
				end
				
         default: contador_maquina_next = s0;
      endcase					  
		end				  
//..............................................................
  
	assign seg_C = {seg_C_D_reg, seg_C_U_reg};	
	assign min_C = {min_C_D_reg, min_C_U_reg};
	assign hora_C = {hora_C_D_reg, hora_C_U_reg};
	assign dia = {dia_D_reg, dia_U_reg};
	assign mes = {mes_D_reg, mes_U_reg};
	assign ano = {ano_D_reg, ano_U_reg};
	assign seg_T = {(4'h5 - seg_T_D_reg), (4'h9 - seg_T_U_reg)};
	assign min_T = {(4'h5 - min_T_D_reg), (4'h9 - min_T_U_reg)};
	assign hora_T = {(4'h2 - hora_T_D_reg), (4'h3 - hora_T_U_reg)};
	assign seg_TVGA = {seg_T_D_reg, seg_T_U_reg};
	assign min_TVGA = {min_T_D_reg, min_T_U_reg};
	assign hora_TVGA = {hora_T_D_reg, hora_T_U_reg};
	
endmodule


