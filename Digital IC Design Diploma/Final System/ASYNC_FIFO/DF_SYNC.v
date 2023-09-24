`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 09/12/2023 10:09:04 PM
// Design Name: DigIC_Dip08_09_CDC
// Module Name: DF_SYNC
// Project Name: Asynchronous FIFO
//////////////////////////////////////////////////////////////////////////////////


module DF_SYNC #(parameter DATA_WIDTH = 4)(
    input   wire                        clk,
    input   wire                        rst,
    input   wire    [DATA_WIDTH : 0]     async,
    output  wire    [DATA_WIDTH : 0]     sync
    );

reg     [DATA_WIDTH : 0]     f1_sync_reg, f1_sync_next;
reg     [DATA_WIDTH : 0]     f2_sync_reg, f2_sync_next;

always @(posedge clk, negedge rst)
    begin
        if (!rst)
            begin
                f1_sync_reg <= 0;
                f2_sync_reg <= 0;
            end
        else
            begin
                f1_sync_reg <= f1_sync_next;
                f2_sync_reg <= f2_sync_next;
            end
    end

always @(*)
    begin
        f1_sync_next = async;
        f2_sync_next = f1_sync_reg;
    end

assign  sync = f2_sync_reg;

endmodule
