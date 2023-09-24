`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 08/30/2023 04:52:16 PM
// Design Name: DigIC_Dip08_09_UART_RX
// Module Name: start_check
// Project Name: UART_RX
//////////////////////////////////////////////////////////////////////////////////


module start_check(
    input   wire    CLK,
    input   wire    RST,
    input   wire    strt_chk_en,
    input   wire    sampled_bit,
    output  wire    strt_glitch
    );

reg strt_glitch_reg, strt_glitch_next;
    
always @(posedge CLK, negedge RST)
    begin
        if (!RST)
            begin
                strt_glitch_reg <= 0;
            end
        else
            begin
                strt_glitch_reg <= strt_glitch_next;
            end
    end 
       
always @(*)
    begin
        if (strt_chk_en)
            begin
                strt_glitch_next = (sampled_bit == 1'b0)? 1'b0 : 1'b1;
            end
        else
            begin
                strt_glitch_next = 1'b0;
            end
    end

assign strt_glitch = strt_glitch_reg;   

endmodule
