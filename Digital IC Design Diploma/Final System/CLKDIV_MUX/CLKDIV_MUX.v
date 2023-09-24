`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 09/15/2023 05:30:52 PM
// Design Name: DigIC_Dip08_09_V_Final_System
// Module Name: div_ratio_mux
// Project Name: Final System
//////////////////////////////////////////////////////////////////////////////////


module CLKDIV_MUX #(parameter PRESCALE = 32, DIVIDED_RATIO_WIDTH = 3)(
        input   wire    [$clog2(PRESCALE) : 0]  prescale,
        output  reg     [DIVIDED_RATIO_WIDTH - 1 : 0]   div_ratio
    );

always @(*)
    begin
        case (prescale)
            'd32:       div_ratio = 1;
            'd16:       div_ratio = 2;
            'd08:       div_ratio = 4;
            default:    div_ratio = 1;
        endcase
    end
endmodule
