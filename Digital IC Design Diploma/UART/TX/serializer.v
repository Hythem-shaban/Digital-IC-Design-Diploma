`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 08/17/2023 12:55:40 AM
// Design Name: DigIC_Dip08_09_UART_TX
// Module Name: serializer
// Project Name: UART_TX
//////////////////////////////////////////////////////////////////////////////////


module serializer #(parameter DATA_WIDTH = 8, n = $clog2(DATA_WIDTH) + 1)(
        input   wire                            CLK, RST,
        input   wire    [DATA_WIDTH - 1 : 0]    P_Data,
        input   wire                            S_EN,
        output  wire                            S_Done,
        output  reg                             S_Data
    );
    
reg     [DATA_WIDTH - 1 : 0]    PISO;
reg     [n - 1 : 0]             Q_reg;

always @(posedge CLK, negedge RST)
    begin
        if (!RST)
            begin
                PISO <= 0;
                S_Data <= 1'b0;
            end 
        else 
            begin
                if (S_EN)
                    begin 
                        {PISO[6 : 0], S_Data} <= PISO;
                    end
                else
                    begin
                        PISO <= P_Data;
                    end
            end
    end
    
always @(posedge CLK, negedge RST) 
    begin
        if (!RST)
            begin
                Q_reg <= DATA_WIDTH;
            end
        else if (!S_EN)
            begin
                Q_reg <= 0;
            end
        else if (!(Q_reg == DATA_WIDTH))
            begin
                Q_reg <= Q_reg + 1;
            end
    end

assign S_Done = Q_reg == DATA_WIDTH;
endmodule
