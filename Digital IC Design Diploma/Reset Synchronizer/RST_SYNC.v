`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 09/10/2023 10:48:46 PM
// Design Name: DigIC_Dip08_09_CDC
// Module Name: RST_SYNC
// Project Name: Reset Synchronizer
//////////////////////////////////////////////////////////////////////////////////


module RST_SYNC #(parameter STAGES_NUM = 1)(
        input   wire    RST,
        input   wire    CLK,
        output  wire    SYNC_RST
    );
    
reg     [STAGES_NUM - 1 : 0]    rst_sync_reg, rst_sync_next;

always @(posedge CLK, negedge RST)
    begin
        if (!RST)
            begin
                rst_sync_reg <= 0;
            end
        else
            begin
                rst_sync_reg <= rst_sync_next;
            end
    end

always @(*)
    begin
        rst_sync_next = {1'b1, rst_sync_reg[STAGES_NUM - 1 : 1]};
    end

assign SYNC_RST = rst_sync_reg[0];
endmodule
