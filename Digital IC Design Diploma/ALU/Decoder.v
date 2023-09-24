`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 07/27/2023 01:36:45 PM
// Design Name: DigIC_Dip08_09_V_W4
// Module Name: Decoder
// Project Name: Assignment 4.1
//////////////////////////////////////////////////////////////////////////////////



module Decoder (
        input wire [1 : 0] in,
        output reg [0 : 3] out
    );
    always @(*)
        begin
            out = 0;
            case(in)
                2'b00: out = 4'b1000;
                2'b01: out = 4'b0100;
                2'b10: out = 4'b0010;
                2'b11: out = 4'b0001;
            endcase
        end
endmodule
