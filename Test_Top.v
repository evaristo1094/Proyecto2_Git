`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:39:46 09/14/2016
// Design Name:   Top_Instanciacion
// Module Name:   C:/Users/Evaristo/Documents/Verilog/Proyecto2/Test_Top.v
// Project Name:  Proyecto2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Top_Instanciacion
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Test_Top;

	// Inputs
	reg CLK;
	reg Reset;
	reg inicializar;
	reg WR1;
	reg CT;
	reg doce_24;
	reg [7:0] clk_seg1;
	reg [7:0] clk_min1;
	reg [7:0] clk_hora1;
	reg [7:0] Mes1;
	reg [7:0] Dia1;
	reg [7:0] Ano1;
	reg [7:0]T_seg,T_min,T_hora;
	// Outputs
	wire [7:0] Mes2;
	wire [7:0] Dia2;
	wire [7:0] Ano2;
	wire [7:0] Seg2;
	wire [7:0] Min2;
	wire [7:0] Hora2;
	wire [7:0] Seg2_T;
	wire [7:0] Min2_T;
	wire [7:0] Hora2_T;
	wire WRO;
	wire CSO,alarma_ON;
	wire ADO;
	wire RDO;
	// Bidirs
	wire [7:0] Bus_Dato_Dir;

	// Instantiate the Unit Under Test (UUT)
	Top_Instanciacion uut (
		.CLK(CLK), 
		.Reset(Reset), 
		.inicializar(inicializar),
		.WR1(WR1), 
		.CT(CT),
		.doce_24(doce_24),
		.clk_seg1(clk_seg1), 
		.clk_min1(clk_min1), 
		.clk_hora1(clk_hora1), 
		.Mes1(Mes1), 
		.Dia1(Dia1), 
		.Ano1(Ano1), 
		.Mes2(Mes2), 
		.Dia2(Dia2), 
		.Ano2(Ano2), 
		.Seg2(Seg2), 
		.Min2(Min2), 
		.Hora2(Hora2), 
		.Seg2_T(Seg2_T), 
		.Min2_T(Min2_T), 
		.Hora2_T(Hora2_T), 
		.WRO(WRO), 
		.CSO(CSO), 
		.ADO(ADO), 
		.RDO(RDO), 
		.Bus_Dato_Dir(Bus_Dato_Dir),
		.T_seg(T_seg),
		.T_min(T_min),
		.T_hora(T_hora),
		.alarma_ON(alarma_ON)
	);
assign Bus_Dato_Dir = (~RDO) ?  8'b00100011 : 8'bzzzzzzzz;
	initial begin
		// Initialize Inputs
		CLK = 0;
		Reset = 0;
		WR1 = 0;
		CT = 0;
		clk_seg1 = 0;
		clk_min1 = 0;
		clk_hora1 = 0;
		doce_24 = 0;
		Mes1 = 0;
		Dia1 = 0;
		Ano1 = 0;

		// Wait 100 ns for global reset to finish
		#10;
      Reset = 1;
		#10;
		Reset = 0;
		#10;
		inicializar = 1;
		#1000;
		inicializar = 0;
		#10;
		doce_24 = 1;
		WR1 = 0;
		#580;
		WR1 = 1;
		#4000;
		WR1 = 0;
		CT = 1;
		clk_seg1 = 0;
		clk_min1 = 10;
		clk_hora1 = 8;
		Mes1 = 3;
		Dia1 = 15;
		Ano1 = 16;
		#4000;
		doce_24 = 1;
		CT = 0;
		Mes1 = 5;
		Dia1 = 6;
		Ano1 = 10;
		#4000;
		#10;
		inicializar = 1;
		#2000;
		inicializar = 0;
		#10;
	end
  always  begin
		#5	CLK = ~CLK;
		end      
endmodule

