`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 08/17/2023 12:56:59 AM
// Design Name: DigIC_Dip08_09_UART_TX
// Module Name: parity_generator
// Project Name: UART_TX
//////////////////////////////////////////////////////////////////////////////////


module parity_generator #(parameter DATA_WIDTH = 8) (
        input   wire                            CLK, RST, EN,
        input   wire    [DATA_WIDTH - 1 : 0]    P_Data,
        input   wire                            started,
        input   wire                            PAR_TYP,
        output  wire                            PAR_Bit
    );
localparam  even = 0,
            odd  = 1;

reg par_bit_reg, par_bit_next;

always @(posedge CLK, negedge RST)
    begin
        if (!RST)
            par_bit_reg <= 1'b0;
        else
            par_bit_reg <= par_bit_next;
    end

always @(*)
    begin
        if (EN && started)
            begin
                case(PAR_TYP)
                    odd     : par_bit_next = ~(^P_Data);
                    even    : par_bit_next = (^P_Data);
                endcase
            end
        else
            begin
                par_bit_next = par_bit_reg;
            end
    end
    
assign PAR_Bit = par_bit_reg;
endmodule
