`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:50:11 08/13/2016 
// Design Name: 
// Module Name:    Sincronizacion 
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
module Sincronizacion(input wire clk, reset, output wire hsync,vsync,video_on,p_tick, output wire [9:0] pixel_x,pixel_y
    );

// constant declaration
// VGA 640-by-480 sync parameters
localparam HD = 640; // horizontal display area
localparam HF = 48 ; // h.front (left) border
localparam HB = 16 ; // h.back (right) border
localparam HR = 96 ; // h.retrace
localparam VD = 480; // vertical display area
localparam VF = 10; // v.front ( top) border
localparam VB = 33; // v.back ( bottom) border
localparam VR = 2;  // v.retrace
localparam frec = 3;  
// mod-2 counter
reg mod3_reg;
reg mod3_next;
reg[1:0] cuenta;
// sync counters
reg [9:0] h_count_reg, h_count_next;
reg [9:0] v_count_reg, v_count_next ;
// output buffer
reg v_sync_reg, h_sync_reg ;
wire v_sync_next, h_sync_next ;
// status signal
wire h_end, v_end, pixel_tick;

// body
// registers
always @( posedge clk, posedge reset)begin
	if (reset)
		begin
			mod3_reg <= 1'b0;
			v_count_reg <= 0;
			cuenta <=0;
			h_count_reg <= 0 ;
			v_sync_reg <= 1'b0;
			h_sync_reg <= 1'b0;
		end
	else
		begin
			mod3_reg <= mod3_next;
			cuenta <= cuenta + 2'b1;
			v_count_reg <= v_count_next;
			h_count_reg <= h_count_next;
			v_sync_reg <= v_sync_next;
			h_sync_reg <= h_sync_next;
	end
	end
// mod-2 circuit to generate 25 MHz enable tick
	//assign mod2_next = ~mod2_reg;
	assign pixel_tick = mod3_reg;
	//assign bandera = mod2_reg;
// s t a t u s s i g n a l s
// end of horizontal counter ( 799 )
	assign h_end = (h_count_reg ==(HD+HF+HB+HR-1));
// end of vertical counter ( 524 )
	assign v_end = (v_count_reg==(VD+VF+VB+VR-1));
// next-state logic of mod-800 horizontal sync counter
	always @*
		begin
		if (pixel_tick) // 25 MHz pulse
			if (h_end)
				h_count_next = 0;
			else
				h_count_next = h_count_reg + 10'b1;
		else
			h_count_next = h_count_reg;
		end
// next-state logic of mod-525 vertical sync counter
	always @*
		begin
		if (pixel_tick & h_end)
			if (v_end)
				v_count_next = 0;
			else
				v_count_next = v_count_reg + 10'b1;
		else
			v_count_next = v_count_reg;
		end
	always @*
		begin
		if(cuenta == frec)
			mod3_next = 1;
		else
			mod3_next = 0;
		end
	// horizontal and vertical sync, buffered to avoid glitch
	// h-svnc-next asserted between 656 and 751
	assign h_sync_next = (h_count_reg>=(HD+HB) &&	h_count_reg<=(HD+HB+HR-1));
	// vh-sync-next a s s e r t e d between 490 and 491
	assign v_sync_next = (v_count_reg>=(VD+VB) &&	v_count_reg<=(VD+VB+VR-1));
	// video on/off
	assign video_on = (h_count_reg<HD) && (v_count_reg<VD);
// output
	assign hsync = h_sync_reg;
	assign vsync = v_sync_reg;
	assign pixel_x = h_count_reg;
	assign pixel_y = v_count_reg;
	assign p_tick = pixel_tick;
endmodule
