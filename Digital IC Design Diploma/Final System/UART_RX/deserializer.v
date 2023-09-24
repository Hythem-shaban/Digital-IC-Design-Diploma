`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 08/30/2023 04:49:55 PM
// Design Name: DigIC_Dip08_09_UART_RX
// Module Name: deserializer
// Project Name: UART_RX
//////////////////////////////////////////////////////////////////////////////////


module deserializer #(parameter DATA_WIDTH = 8)(
    input   wire                            CLK,
    input   wire                            RST,
    input   wire                            deser_en,
    input   wire                            sampled_bit,
    output  wire    [DATA_WIDTH - 1 : 0]    P_Data
    );

reg     [DATA_WIDTH - 1 : 0]    SIPO;

always @(posedge CLK, negedge RST)
    begin
        if (!RST)
            begin
                SIPO <= 0;
            end
        else if (deser_en)
            begin
                SIPO <= {sampled_bit, SIPO[DATA_WIDTH - 1 : 1]};
            end
    end
assign P_Data = SIPO;
endmodule
