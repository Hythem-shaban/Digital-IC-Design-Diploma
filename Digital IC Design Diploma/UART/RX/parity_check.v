`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 08/30/2023 04:52:33 PM
// Design Name: DigIC_Dip08_09_UART_RX
// Module Name: parity_check
// Project Name: UART_RX
//////////////////////////////////////////////////////////////////////////////////


module parity_check #(parameter DATA_WIDTH = 8)(
    input   wire                            CLK,
    input   wire                            RST,
    input   wire                            PAR_TYP,
    input   wire                            par_chk_en,
    input   wire                            sampled_bit,
    input   wire    [DATA_WIDTH - 1 : 0]    P_Data,
    output  wire                             par_error
    );

localparam  even = 0,
            odd  = 1; 

reg     par_error_reg, par_error_next;

always @(posedge CLK, negedge RST)
    begin
        if (!RST)
            begin
                par_error_reg <= 0;
            end
        else
            begin
                par_error_reg <= par_error_next;
            end
    end
always @(*)
    begin
        if (par_chk_en)
            begin
                case (PAR_TYP)
                    even:   par_error_next = (sampled_bit != (^P_Data));
                    odd:    par_error_next = (sampled_bit !=  ~(^P_Data));
                endcase
            end
        else
            begin
                par_error_next = par_error_reg;
            end
    end

assign par_error = par_error_reg;
endmodule
