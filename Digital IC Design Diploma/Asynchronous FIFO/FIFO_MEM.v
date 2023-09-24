`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 09/12/2023 09:55:22 PM
// Design Name: DigIC_Dip08_09_CDC
// Module Name: FIFO_MEM
// Project Name: Asynchronous FIFO
//////////////////////////////////////////////////////////////////////////////////


module FIFO_MEM #(parameter DATA_WIDTH = 8, MEM_DEPTH = 16, ADD_WIDTH = $clog2(MEM_DEPTH))(
    input   wire    [DATA_WIDTH - 1 : 0]    wr_data,
    input   wire                            wr_clk,
    input   wire                            wr_rst,
    input   wire                            wr_inc,
    input   wire                            wr_full,
    input   wire    [ADD_WIDTH  - 1 : 0]    wr_addr,
    input   wire    [ADD_WIDTH  - 1 : 0]    rd_addr,
    output  wire    [DATA_WIDTH - 1 : 0]    rd_data
    );

integer i;
reg     [DATA_WIDTH - 1 : 0]    fifo_mem   [MEM_DEPTH - 1 : 0];

always @(posedge wr_clk, negedge wr_rst)
    begin
        if (!wr_rst)
            begin
                for (i = 0; i < MEM_DEPTH; i = i + 1)
                    begin
                        fifo_mem[i] = 'b0;
                    end
            end
        else if (wr_inc && !wr_full)
            begin
                fifo_mem[wr_addr] <= wr_data;
            end
    end
    
assign  rd_data = fifo_mem[rd_addr];

endmodule
