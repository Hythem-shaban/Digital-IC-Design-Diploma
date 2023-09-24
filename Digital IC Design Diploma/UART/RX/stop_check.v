`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 08/30/2023 04:52:52 PM
// Design Name: DigIC_Dip08_09_UART_RX
// Module Name: stop_check
// Project Name: UART_RX
//////////////////////////////////////////////////////////////////////////////////


module stop_check(
    input   wire    CLK,
    input   wire    RST,
    input   wire    stp_chk_en,
    input   wire    sampled_bit,
    output  wire    stp_error
    );
    
reg stp_error_reg, stp_error_next;
     
always @(posedge CLK, negedge RST)
    begin
        if (!RST)
            begin
                stp_error_reg <= 0;
            end
        else
            begin
                stp_error_reg <= stp_error_next;
            end
    end 
       
always @(*)
    begin
        if (stp_chk_en)
            begin
                stp_error_next = (sampled_bit == 1'b1)? 1'b0 : 1'b1;
            end
        else
            begin
                stp_error_next = stp_error_reg;
            end
    end

assign stp_error = stp_error_reg;   

endmodule
