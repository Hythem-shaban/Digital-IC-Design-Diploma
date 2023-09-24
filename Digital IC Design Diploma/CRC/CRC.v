`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 08/01/2023 01:47:22 AM
// Design Name: DigIC_Dip08_09_V_W5
// Module Name: CRC
// Project Name: Assignment 5.0
//////////////////////////////////////////////////////////////////////////////////


module CRC #(parameter DATA_LENGTH = 1, n = $clog2(DATA_LENGTH*8) + 1, [7 : 0] TAPS = 8'b01000100)(
    input   wire     Data,
    input   wire     Active,
    input   wire     CLK, RST_n,
    output  reg      CRC, Valid
    );
    
    reg         [7 : 0]     LFSR_reg;
    reg         [n - 1 : 0] Q_reg;
    integer                 i;
    wire                    feedback;
    wire                    done;
    
    always @(posedge CLK, negedge RST_n)
        begin
            if (~RST_n)
                begin
                    LFSR_reg <= 8'hD8;
                    CRC <= 1'b0;
                    Valid <= 1'b0;
                end
            else if (Active)
                begin
                    LFSR_reg[7] <= feedback;
                    for (i = 6; i >= 0; i = i - 1)
                        if(TAPS[i] == 1)
                            LFSR_reg[i] <= LFSR_reg[i + 1] ^ feedback;
                        else
                            LFSR_reg[i] <= LFSR_reg[i + 1];
                    Valid <= 1'b0;
                end
            else if (~done)
                begin
                    {LFSR_reg[6 : 0], CRC} <= LFSR_reg;
                    Valid <= 1'b1;
                end
            else
                begin
                    LFSR_reg <= 8'hD8;
                    CRC <= 1'b0;
                    Valid <= 1'b0;
                end 
            
        end

    always @(posedge CLK, negedge RST_n) 
        begin
            if (!RST_n)
                begin
                    Q_reg <= DATA_LENGTH*8;
                end
            else if (Active)
                begin
                    Q_reg <= 'b0;
                end
            else if (!done)
                begin
                    Q_reg <= Q_reg + 1;
                end     
        end
    assign done = Q_reg == DATA_LENGTH*8;
    assign feedback = Data ^ LFSR_reg[0]; 
endmodule

