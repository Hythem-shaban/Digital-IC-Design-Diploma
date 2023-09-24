`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 07/27/2023 07:24:59 PM
// Design Name: DigIC_Dip08_09_V_W3
// Module Name: Register_File
// Project Name: Assignment 4.2
//////////////////////////////////////////////////////////////////////////////////

module Register_File #(parameter MEM_WIDTH = 16, MEM_DEPTH = 8)
    (
        input   wire [MEM_WIDTH - 1 : 0] WrData,
        input   wire [$clog2(MEM_DEPTH) - 1 : 0] Address,
        input   wire CLK, RST_n,
        input   wire WrEn, RdEn,
        output  reg [15 : 0] RdData
    );
    
    reg [MEM_WIDTH - 1 : 0] memory [MEM_DEPTH - 1 : 0];
    integer i;
    always @(posedge CLK, negedge RST_n)
        begin
            if (~RST_n)
                for (i = 0; i < MEM_DEPTH; i = i + 1)
                    begin
                        memory[i] <= 'b0;
                    end
            else if (WrEn && ~RdEn)
                memory[Address] <= WrData;
            else if (~WrEn && RdEn)
                RdData <= memory[Address];
        end
endmodule
