`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:59:48 09/10/2016 
// Design Name: 
// Module Name:    Entradas_De_Control 
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
module Entradas_De_Control(input wire clk, reset,
En_Esc,En_Lect,															//// Entradas para habilitar cuentas y salidas
output wire CS, WR,RD,AD, DIR1, DAT1,DAT_LECT,cambio_est,cambio_est2,	///Salidas que controlaran los tiempo de manejo del RTC
En_tristate	 );															/// Activacion del triestato para el envio de los datos
   
localparam inicio = 7;  // tiempo que tarda despues de entrada a cada estado para realizar la escritura determinada
localparam Tcs = 5; // tiempo minimo del chip select en bajo (50, para escribir)
localparam Tf = 0 ; // tiempo de bajada del flanco (fall) 
localparam Tr = 0 ; // tiempo de subida del flanco (rise)
localparam Twr = 6 ; // tiempo en bajo del pulso de escritura, incluye tiempo de rise
localparam Tw = 12; // tiempo de transferencia (tiempo que esta en alto el chip select, incluye el Tfall)
localparam Tdw = 5; // tiempo que el dato debe estar presente durante el pulso negativo de WR(escribe)
localparam Tdh = 1; // tiempo de hold(tiempo que debe permancecer el dato desp que cambia de 0 a 1 el WR)
localparam TA_Ds = 1 ; // tmpo ants q debe estar en estd en bajo el A/D (ctrl de datos y dir) del CS
localparam TA_Dt = 1; // tmpo despues q debe estar en estd en bajo el A/D (ctrl de datos y dir) del CS

////Contador de la maquina///
reg [6:0] ctrl_count_reg,ctrl_count_next;

// Registros que se utilizaran para guardar y luego transmitir a las salidas
reg CS_reg, WR_reg,AD_reg,CS_next, WR_next,AD_next,RD_reg,RD_next;
reg DIR_reg, DAT_reg,DIR_next, DAT_next,cambio_estado_reg, cambio_estado_next;
reg DAT_LECT_reg,DAT_LECT_next,cambio_estado2_reg, cambio_estado2_next;
reg En_tristate_reg,En_tristate_next;

// inicializacion y refrezco de los registros a utlizar de las variables salida
always @( posedge clk, posedge reset)	begin
	if (reset)begin
			ctrl_count_reg <= 0;
			CS_reg <= 1;
			WR_reg <= 1;
			RD_reg <= 1;
			AD_reg <= 1;
			DIR_reg <= 0;
			DAT_reg <= 0;
			cambio_estado_reg <=0;
			cambio_estado2_reg <=0;
			DAT_LECT_reg <=0;
			En_tristate_reg <=0;
				end
	else begin
			ctrl_count_reg <= ctrl_count_next;
			CS_reg <= CS_next;
			WR_reg <= WR_next;
			RD_reg <= RD_next;
			AD_reg <= AD_next;
			DIR_reg <= DIR_next;
			DAT_reg <= DAT_next;
			DAT_LECT_reg <= DAT_LECT_next;
			cambio_estado_reg <= cambio_estado_next;
			cambio_estado2_reg <= cambio_estado2_next;
			En_tristate_reg <= En_tristate_next;
			end
	end
	
///// Condicion para avanzar el contador que generara las senales de control///////////////	

always @( posedge clk, posedge reset) begin
		if (reset)
			ctrl_count_next <= 0;
		else if(En_Esc | En_Lect)
			ctrl_count_next <= ctrl_count_next + 7'b1;
		else
			ctrl_count_next <= 0;
		end	
		
		
////////// Creacion de los pulsos de la senal CS para el RTC///////////////	

	always@*
			begin
			if (ctrl_count_reg >=(inicio+TA_Ds) && ctrl_count_reg<=( inicio + TA_Ds + Tf + Tr + Tcs))
				CS_next = 1'b0;
			else if (ctrl_count_reg >=(inicio + TA_Ds + Tf +Tr + Tcs + Tw ) &&	ctrl_count_reg<=(inicio + TA_Ds + Tf + Tr + Tcs + Tw + Tf + Tcs + Tr))
				CS_next = 1'b0;
			else 
				CS_next = 1'b1;
			end
			
////////// Creacion de los pulsos de la senal WR para el RTC///////////////

	always@*
			begin
			if (ctrl_count_reg >=(inicio+ TA_Ds) &&	ctrl_count_reg<=(inicio + TA_Ds + Tf +Tr+ Tcs))
					WR_next = 1'b0;
			else if(En_Esc ) begin 
				if (ctrl_count_reg >=(inicio + TA_Ds + Tf +Tr + Tcs + Tw ) &&	ctrl_count_reg<=(inicio + TA_Ds + Tf +Tr + Tcs + Tw + Tf + Tcs + Tr))
					WR_next = 1'b0;
				else 
					WR_next = 1'b1; end
			else WR_next = 1'b1;
			end
			
////////// Creacion de los pulsos de la senal RD para el RTC///////////////

	always@*
			begin
			if(En_Lect) begin 
				if (ctrl_count_reg >=(inicio + TA_Ds + Tf +Tr + Tcs + Tw ) &&	ctrl_count_reg<=(inicio + TA_Ds + Tf + Tr + Tcs + Tw + Tf + Tcs + Tr))
					RD_next = 1'b0;
				else 
					RD_next = 1'b1; end
			else RD_next = 1'b1;
			end
			
////////// Creacion de los pulsos de la senal AD para el RTC///////////////

	always@*
			begin
			if (ctrl_count_reg >=(inicio) && ctrl_count_reg<=(inicio + TA_Ds + Tf  + Tcs + TA_Dt + Tr))
				AD_next = 1'b0;
			else 
				AD_next = 1'b1;
			end

////////// Creacion de una bandera que habilitara un proceso en las maquinas de esc y lect///////////////

	always@*
			begin
			if (ctrl_count_reg >=(inicio + TA_Ds + Tcs - Tdw - 2) &&	ctrl_count_reg <=(inicio + TA_Ds + Tcs + Tdh ))
				DIR_next = 1'b1;
			else 
				DIR_next = 1'b0;
			end
			
////////// Creacion de una bandera que habilitara un proceso en las maquinas de esc y lect///////////////	
		
	always@*
			begin
			if (ctrl_count_reg >=(inicio + TA_Ds  + Tcs + Tw  + Tcs  - Tdw - 2) &&	ctrl_count_reg<=(inicio + TA_Ds  + Tcs + Tw + Tcs + Tdh))
				DAT_next = 1'b1;
			else 
				DAT_next = 1'b0;
			end
			
////////// Creacion de una bandera que habilitara un la entrada de datos de la lectura///////////////	
		
	always@*
			begin
				if (ctrl_count_reg >=(inicio + TA_Ds  + Tcs + Tw  + Tcs  - Tdw + 1 ) &&	ctrl_count_reg<=(inicio + TA_Ds  + Tcs + Tw + Tcs + (Tdh - 1)))
					DAT_LECT_next = 1'b1;
				else 
					DAT_LECT_next = 1'b0;
			end
			
////////// Creacion de una bandera que habilitara el cambio de estado en las maquinas de esc y lect//////////			
	
	always@* 
		begin
			if (ctrl_count_reg >= (inicio + TA_Ds + Tcs + Tw + Tcs + Tdh) && ctrl_count_reg <= (inicio + TA_Ds  + Tcs + Tw  + Tcs  + Tdh + 1) )
				cambio_estado_next = 1;
			else 
				cambio_estado_next = 0;
		end
////////// Creacion de una bandera que habilitara el cambio de estado en las maquinas de lect//////////			
	
	always@* 
		begin
			if (ctrl_count_reg == (inicio + TA_Ds + Tcs + Tw + Tcs + Tdh))
				cambio_estado2_next = 1;
			else 
				cambio_estado2_next = 0;
		end		
////////// Creacion de senal de Eneable del tri estado del bus de datos ////////////////	

	always@*
		begin 
			if (En_Esc)  begin
				if (ctrl_count_reg >=(inicio + TA_Ds + Tf +Tr + Tcs + Tw + Tf + Tcs + Tr - Tdw ) &&	ctrl_count_reg<=(inicio + TA_Ds + Tf + Tr + Tcs + Tw + Tf + Tcs + Tr + Tdh ))
					En_tristate_next = 1;
				else if (ctrl_count_reg >=(inicio + TA_Ds + Tf + Tr + Tcs - Tdw ) &&	ctrl_count_reg <=(inicio + TA_Ds + Tf +Tr+ Tcs + Tdh ))
					En_tristate_next = 1;
				else 
					En_tristate_next = 0;
				end	
			else if	(En_Lect) begin
				if (ctrl_count_reg >=(inicio + TA_Ds + Tf + Tr + Tcs - Tdw ) &&	ctrl_count_reg <=(inicio + TA_Ds + Tf +Tr+ Tcs + Tdh ))
					En_tristate_next = 1;
				else 	
					En_tristate_next = 0;
				end
			else 	
					En_tristate_next = 0;		
		end		
		
// asignacion de las senales de salida y  banderas correspondientes
	assign CS = CS_reg;
	assign WR = WR_reg;
	assign AD = AD_reg;
	assign RD = RD_reg;
	assign DIR1 = DIR_reg;
	assign DAT1 = DAT_reg;
	assign DAT_LECT = DAT_LECT_reg;
	assign cambio_est = cambio_estado_reg;
	assign cambio_est2 = cambio_estado2_reg;
	assign En_tristate = En_tristate_reg ;
endmodule
