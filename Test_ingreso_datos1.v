`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:05:45 09/22/2016
// Design Name:   Ingreso_Datos
// Module Name:   C:/Users/Luis/Ingreso_de_datos/Test_ingreso_datos1.v
// Project Name:  Ingreso_de_datos
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Ingreso_Datos
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Test_ingreso_datos1;

	// Inputs
	reg clk;
	reg reset;
	reg C_T;
	reg disminuye;
	reg aumenta;
	reg escribe;
	reg corre_der;
	reg corre_izq;
	reg doce_24;

	// Outputs
	wire [7:0] seg_C;
	wire [7:0] min_C;
	wire [7:0] hora_C;
	wire [7:0] dia;
	wire [7:0] mes;
	wire [7:0] ano;
	wire [7:0] seg_T;
	wire [7:0] min_T;
	wire [7:0] hora_T;

	// Instantiate the Unit Under Test (UUT)
	Ingreso_Datos uut (
		.clk(clk), 
		.reset(reset), 
		.C_T(C_T), 
		.disminuye(disminuye), 
		.aumenta(aumenta), 
		.escribe(escribe), 
		.corre_der(corre_der), 
		.corre_izq(corre_izq), 
		.doce_24(doce_24), 
		.seg_C(seg_C), 
		.min_C(min_C), 
		.hora_C(hora_C), 
		.dia(dia), 
		.mes(mes), 
		.ano(ano), 
		.seg_T(seg_T), 
		.min_T(min_T), 
		.hora_T(hora_T)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		C_T = 0;
		disminuye = 0;
		aumenta = 0;
		escribe = 0;
		corre_der = 0;
		corre_izq = 0;
		doce_24 = 0;

		// Wait 100 ns for global reset to finish
		#10;
		// se inicializan todas las señales
		reset = 1;
		#10;
      reset = 0;
		#10;
        
		// se activa la entrada escribir 
		
		escribe = 1;
		#100;
		/////////////////////////////////      SEGUNDOS
		C_T = 1;  //     clock aumenta
		#200;
		aumenta = 1;
		#300;
		C_T = 0; //       aumenta timer
		#200;
		aumenta = 0;
		#10;
		C_T = 1;//        clock disminuye
	   #100;
		disminuye = 1;
		#100;
		C_T = 0; //        disminuye timer
		#100;
		disminuye = 0;
		#10;
		corre_der = 1;
		#10;
		corre_der = 0;
		#10;
		//////////////////////////////////////      MINUTOS
		C_T = 1;  //       clock aumenta
		#200;
		aumenta = 1;
		#300;
		C_T = 0; //        aumenta timer
		#200;
		aumenta = 0;
		#10;
		C_T = 1;//         clock disminuye
	   #100;
		disminuye = 1;
		#100;
		C_T = 0; //        disminuye timer
		#100;
		disminuye = 0;
		#10;
		corre_der = 1;
		#10;
		corre_der = 0;
		#10;  
		/////////////////////////////////////                     HORA
		doce_24 = 1;//                        reloj 12 horas
		#100;
		C_T = 1;  //        clock aumenta
		#100;
		aumenta = 1;
		#300;
		C_T = 0; //         aumenta  timer
		#300;
		aumenta = 0;
		#10;
		C_T = 1; //         clock disminuye
	   #100;
		disminuye = 1;
		#100;
		C_T = 0; //         disminuye  timer
		#100;
		disminuye = 0;
		#10;
		doce_24 = 0; //                        reloj 24 horas
		#10;
		C_T = 1;  //        clock aumenta
		#100;
		aumenta = 1;
		#300;
		C_T = 0; //         aumenta timer
		#100;
		aumenta = 0;
		#300;
		C_T = 1;//          clock disminuye
	   #100;
		disminuye = 1;
		#100;
		C_T = 0; //         disminuye timer
		#100;
		disminuye = 0;
		#10;
		corre_der = 1;
		#10;
		corre_der = 0;
		#10;		 
		//////////////////////////////////////////////////////////////  DIA
		aumenta = 1;
		#200;
		aumenta = 0;
		#10;
		disminuye = 1;
		#100;
		disminuye = 0;
		#10;
		corre_der = 1;
		#10;
		corre_der = 0;
		#10;		
		////////////////////////////////////////////////////////////    MES
		aumenta = 1;
		#200;
		aumenta = 0;
		#10;
		disminuye = 1;
		#100;
		disminuye = 0;
		#10;
		corre_der = 1;
		#10;
		corre_der = 0;
		#10;
		///////////////////////////////////////////////////////////    ANO
		aumenta = 1;
		#200;
		aumenta = 0;
		#10;
		disminuye = 1;
		#100;
		disminuye = 0;
		#10;	
		/////////////////////////////////////   corro izq 
		corre_izq = 1;
		#10;
		corre_izq = 0;
		#10
		aumenta = 1;
		#100;
		aumenta = 0;
		#10;
		corre_der = 1;
		#10;
		corre_der = 0;
		#10;
		// vuelve al inicio estado s1 (segundos)		
		  
		// Add stimulus here
	end
  always  begin
		#10	clk = ~clk;
		end 
	
      
endmodule

