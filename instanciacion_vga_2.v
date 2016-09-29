`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:44:31 09/22/2016 
// Design Name: 
// Module Name:    instanciacion_vga_2 
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
module instanciacion_vga_2(input wire CLK_TB, RESET_TB, activring_TB, bandera_TB_hh, bandera_TB_mh, bandera_TB_sh, bandera_TB_df,
    input wire bandera_TB_mf, bandera_TB_af, bandera_TB_hc, bandera_TB_mc, bandera_TB_sc, 
	 input wire [7:0] hora, min, seg, dia, mes, ano, c_hora, c_min, c_seg, 
	 output wire v_sync, h_sync,
	 output wire [6:0] text_on_out,
	 output wire [2:0] text_rgb_out
	 );
	 
	 wire videoon, vsync, hsync;
	 wire [9:0] pixx, pixy;
	 wire [6:0] text_on;
	 wire [2:0] text_rgb;
	 
	 
// Instantiate the module
Sincronizacion instance_name (
    .clk(CLK_TB), 
    .reset(RESET_TB), 
    .hsync(hsync), 
    .vsync(vsync), 
    .video_on(videoon), 
    .p_tick(), 
    .pixel_x(pixx), 
    .pixel_y(pixy)
    );


// Instantiate the module
vga_interfaz instance_name2 (
    .clk(CLK_TB), 
    .activring(activring_TB), 
    .bandera_Hhora(bandera_TB_hh), 
    .bandera_Mhora(bandera_TB_mh), 
    .bandera_Shora(bandera_TB_sh), 
    .bandera_Dfecha(bandera_TB_df), 
    .bandera_Mfecha(bandera_TB_mf), 
    .video_on(videoon), 
    .bandera_Afecha(bandera_TB_af), 
    .bandera_Hcrono(bandera_TB_hc), 
    .bandera_Mcrono(bandera_TB_mc), 
    .bandera_Scrono(bandera_TB_sc), 
    .hora1(hora[7:4]), 
    .hora2(hora[3:0]), 
    .min1(min[7:4]), 
    .min2(min[3:0]), 
    .sec1(seg[7:4]), 
    .sec2(seg[3:0]), 
    .dia1(dia[7:4]), 
    .dia2(dia[3:0]), 
    .mes1(mes[7:4]), 
    .mes2(mes[3:0]), 
    .ano1(ano[7:4]), 
    .ano2(ano[3:0]), 
    .ch1(c_hora[7:4]), 
    .ch2(c_hora[3:0]), 
    .cm1(c_min[7:4]), 
    .cs1(c_seg[7:4]), 
    .cs2(c_seg[3:0]), 
    .cm2(c_min[3:0]), 
    .pix_x(pixx), 
    .pix_y(pixy), 
    .text_on(text_on), 
    .text_rgb(text_rgb)
    );

assign v_sync = vsync;
assign h_sync = hsync;
assign text_on_out = text_on;
assign text_rgb_out = text_rgb;


endmodule
