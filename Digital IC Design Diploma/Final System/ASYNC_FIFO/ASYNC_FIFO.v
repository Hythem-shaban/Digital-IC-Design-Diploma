`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 09/12/2023 09:19:23 PM
// Design Name: DigIC_Dip08_09_CDC
// Module Name: ASYNC_FIFO
// Project Name: Asynchronous FIFO
//////////////////////////////////////////////////////////////////////////////////


module ASYNC_FIFO #(parameter DATA_WIDTH = 8, MEM_DEPTH = 16, ADD_WIDTH = $clog2(MEM_DEPTH))(
    input   wire    [DATA_WIDTH - 1 : 0]    wr_data,
    input   wire                            wr_clk,
    input   wire                            wr_rst,
    input   wire                            wr_inc,
    input   wire                            rd_clk,
    input   wire                            rd_rst,
    input   wire                            rd_inc,
    output  wire    [DATA_WIDTH - 1 : 0]    rd_data,
    output  wire                            full,
    output  wire                            empty
    );

wire    [ADD_WIDTH - 1 : 0]     wr_addr, rd_addr; 
wire    [ADD_WIDTH     : 0]     wr_ptr, rd_ptr;
wire    [ADD_WIDTH     : 0]     sync_wr_ptr, sync_rd_ptr;

FIFO_MEM #(.DATA_WIDTH(DATA_WIDTH), .MEM_DEPTH(MEM_DEPTH), .ADD_WIDTH(ADD_WIDTH)) FIFO_MEM_U0 (
    .wr_clk(wr_clk),
    .wr_rst(wr_rst),
    .wr_data(wr_data),
    .wr_inc(wr_inc),
    .wr_full(full),
    .wr_addr(wr_addr),
    .rd_addr(rd_addr),
    .rd_data(rd_data)
);

DF_SYNC #(.DATA_WIDTH(ADD_WIDTH)) DF_SYNC_UO (
    .clk(wr_clk),
    .rst(wr_rst),
    .async(rd_ptr),
    .sync(sync_rd_ptr)
);

DF_SYNC #(.DATA_WIDTH(ADD_WIDTH)) DF_SYNC_U1 (
    .clk(rd_clk),
    .rst(rd_rst),
    .async(wr_ptr),
    .sync(sync_wr_ptr)
);

FIFO_WR #(.ADD_WIDTH(ADD_WIDTH)) FIFO_WR_UO (
    .wr_clk(wr_clk),
    .wr_rst(wr_rst),
    .wr_inc(wr_inc),
    .rd_ptr(sync_rd_ptr),
    .wr_ptr(wr_ptr),
    .wr_addr(wr_addr),
    .wr_full(full)
);

FIFO_RD #(.ADD_WIDTH(ADD_WIDTH)) FIFO_RD_UO (
    .rd_clk(rd_clk),
    .rd_rst(rd_rst),
    .rd_inc(rd_inc),
    .wr_ptr(sync_wr_ptr),
    .rd_ptr(rd_ptr),
    .rd_addr(rd_addr),
    .rd_empty(empty)
);
    
endmodule
