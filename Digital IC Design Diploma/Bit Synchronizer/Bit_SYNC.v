`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 09/08/2023 01:05:46 AM
// Design Name: DigIC_Dip08_09_CDC
// Module Name: Bit_SYNC
// Project Name: Bit Synchronizer
//////////////////////////////////////////////////////////////////////////////////


module Bit_SYNC #(parameter STAGES_NUM = 1, BUS_WIDTH = 1)(
    input   wire    [BUS_WIDTH - 1 : 0]     ASYNC,
    input   wire                            CLK,
    input   wire                            RST,
    output  wire    [BUS_WIDTH - 1 : 0]     SYNC
    );
reg     [STAGES_NUM - 1 : 0]    bit_sync_reg    [BUS_WIDTH - 1 : 0];
reg     [STAGES_NUM - 1 : 0]    bit_sync_next   [BUS_WIDTH - 1 : 0];
genvar i;
generate
    for (i = 0; i < BUS_WIDTH; i = i + 1)
        begin
            always @(posedge CLK, negedge RST)
                begin
                    if (!RST)
                        begin
                            bit_sync_reg[i] <= 0;
                        end
                    else
                        begin
                            bit_sync_reg[i] <= bit_sync_next[i];
                        end
                end
                
            always @(*)
                begin
                    bit_sync_next[i] = {bit_sync_reg[i][STAGES_NUM - 2 : 0], ASYNC[i]};
                end
                
            assign SYNC[i] = bit_sync_reg[i][STAGES_NUM - 1];
        end
endgenerate
endmodule
