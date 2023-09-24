`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 08/30/2023 04:51:54 PM
// Design Name: DigIC_Dip08_09_UART_RX
// Module Name: edge_bit_counter
// Project Name: UART_RX
//////////////////////////////////////////////////////////////////////////////////


module edge_bit_counter #(parameter PRESCALE = 32, DATA_WIDTH = 8)(
        input   wire                                    CLK,
        input   wire                                    RST,
        input   wire                                    EN,
        input   wire    [$clog2(PRESCALE) : 0]          prescale,
        output  reg     [$clog2(DATA_WIDTH) : 0]        bit_cnt,
        output  reg     [$clog2(PRESCALE) : 0]          edge_cnt
    );

always @(posedge CLK, negedge RST)
    begin
        if (!RST)
            begin
                edge_cnt <= (prescale - 1);
            end
        else if (!EN)
            begin
                edge_cnt <= 0;
            end
        else if (!(edge_cnt == (prescale - 1)))
            begin
                edge_cnt <= edge_cnt + 1;
            end
        else if (edge_cnt == (prescale - 1))
            begin
                edge_cnt <= 0;
            end
    end

always @(posedge CLK, negedge RST)
    begin
        if (!RST)
            begin
                bit_cnt <= (DATA_WIDTH + 3);
            end
        else if (!EN)
            begin
                bit_cnt <= 0;
            end
        else if (!(edge_cnt == (prescale - 1)))
            begin
                bit_cnt <= bit_cnt;
            end
        else if ((edge_cnt == (prescale - 1)) && !(bit_cnt == (DATA_WIDTH + 3)))
            begin
                bit_cnt <= bit_cnt + 1;
            end
        else if (bit_cnt == (DATA_WIDTH + 3))
            begin
                bit_cnt <= 0;
            end
    end

   


endmodule
