`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:59:40 09/21/2016 
// Design Name: 
// Module Name:    indicador_ring 
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
module indicador_ring (
	input alarma_on,clk,reset,apagar_alarma,
	input wire [7:0] HRTC, MRTC, SRTC,
	output reg activring,
	output wire [3:0] hora_1, hora_2, min_1, min_2, seg_1, seg_2
    );
localparam [3:0] 	H_1 = 2,
						H_2 = 3, 
						M_1 = 5,
						M_2 = 9,
						S_1 = 5,
						S_2 = 9;
reg [3:0] hora1, hora2, min1, min2, seg1, seg2,hora1_next, hora2_next, min1_next, min2_next, seg1_next, seg2_next;
localparam [1:0] 	s0 = 2'b00, 
						s1 = 2'b01,
						s2 = 3'b10,
						s3 = 2'b11;

/// contador del control de la maquina de estados///		

reg [1:0] ctrl_maquina_next,ctrl_maquina;
always@(posedge clk, posedge reset)begin
	if(reset)begin
		hora1 <= 0;
		hora2 <= 0;
		min1 <= 0;
		min2 <= 0;
		seg1 <= 0;
		seg2 <= 0;	
		ctrl_maquina <= 0;end
	else	
	begin
		hora1 <= hora1_next;
		hora2 <= hora2_next;
		min1 <= min1_next;
		min2 <= min2_next;
		seg1 <= seg1_next;
		seg2 <= seg2_next;
		ctrl_maquina <= ctrl_maquina_next;		end
		
		end

always @ *
		begin 
		activring = 0;
		hora1_next = hora1;
		hora2_next =hora2;
		min1_next=min1;
		min2_next=min2;
		seg1_next=seg1;
		seg2_next=seg2;
		ctrl_maquina_next = ctrl_maquina;
		case(ctrl_maquina)
		
		s0: begin
						if(alarma_on) begin
							ctrl_maquina_next = s1; 
							activring = 1'b0;end
						else begin
							ctrl_maquina_next = s0;
							activring = 1'b0;	end
			end
		s1:	begin
						if(HRTC == 8'b00100011 && MRTC == 8'b01011001 && SRTC == 8'b01011001)begin
							ctrl_maquina_next = s2;
								end
						else begin
								hora1_next = H_1 - HRTC[7:4];
								hora2_next = H_2 - HRTC[3:0];
								min1_next  = M_1 - MRTC[7:4];
								min2_next  = M_2 - MRTC[3:0];
								seg1_next  = S_1 - SRTC[7:4];
								seg2_next  = S_2 - SRTC[3:0];
								activring = 1'b0;
								ctrl_maquina_next = s1;						end
			
		end
		
		s2: begin
			if(apagar_alarma)begin
				activring = 1'b0;
				ctrl_maquina_next = s0;	
				
				end
			else begin 
				ctrl_maquina_next = s2;	
				activring = 1'b1;
				hora1_next = 4'b0000;
				hora2_next = 4'b0000;
				min1_next  = 4'b0000;
				min2_next  = 4'b0000;
				seg1_next  = 4'b0000;
				seg2_next  = 4'b0000;end
		end
		default : ctrl_maquina_next = s0;
		
		endcase		
		end

assign hora_1 = hora1;
assign hora_2 = hora2;
assign min_1 = min1;
assign min_2 = min2;
assign seg_1 = seg1;
assign seg_2 = seg2;
		
endmodule
