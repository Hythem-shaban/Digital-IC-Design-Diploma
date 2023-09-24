`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 09/15/2023 03:31:55 PM
// Design Name: DigIC_Dip08_09_Final_System
// Module Name: inverter
// Project Name: Final System
//////////////////////////////////////////////////////////////////////////////////


module inverter #(WIDTH = 1)(
    input   wire    [WIDTH - 1 : 0]     in_signal,
    output  wire    [WIDTH - 1 : 0]     inverted_signal
    );

assign inverted_signal = ~in_signal;

endmodule
