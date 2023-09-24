`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 09/12/2023 11:15:01 PM
// Design Name: DigIC_Dip08_09_CDC
// Module Name: FIFO_RD
// Project Name: Asynchronous FIFO
//////////////////////////////////////////////////////////////////////////////////


module FIFO_RD #(parameter ADD_WIDTH = 4)(
    input   wire                            rd_clk,
    input   wire                            rd_rst,
    input   wire                            rd_inc,
    input   wire    [ADD_WIDTH     : 0]     wr_ptr,
    output  wire    [ADD_WIDTH     : 0]     rd_ptr,
    output  wire    [ADD_WIDTH - 1 : 0]     rd_addr,
    output  wire                            rd_empty
    );

reg     [ADD_WIDTH : 0]     rd_bin_ptr_reg, rd_bin_ptr_next;
reg     [ADD_WIDTH : 0]     rd_grey_ptr_reg, rd_grey_ptr_next;
reg                         rd_empty_reg, rd_empty_next;

// generation of read address
always @(posedge rd_clk, negedge rd_rst)
    begin
        if (!rd_rst)
            begin
                rd_bin_ptr_reg <= 0;
            end
        else
            begin
                rd_bin_ptr_reg <= rd_bin_ptr_next;
            end
    end

always @(*)
    begin
        if (rd_inc && !rd_empty)
            begin
                rd_bin_ptr_next <= rd_bin_ptr_reg + 1;
            end
        else
            begin
                rd_bin_ptr_next <= rd_bin_ptr_reg;
            end
    end
    
assign  rd_addr = rd_bin_ptr_reg[ADD_WIDTH - 1 : 0];

// generation of write gray pointer
always @(posedge rd_clk, negedge rd_rst)
    begin
        if (!rd_rst)
            begin
                rd_grey_ptr_reg <= 0;
            end
        else
            begin
                rd_grey_ptr_reg <= rd_grey_ptr_next;
            end
    end

always @(*)
    begin
        rd_grey_ptr_next = (rd_bin_ptr_next >> 1) ^ rd_bin_ptr_next;    // binary to gray conversion
    end
 
assign  rd_ptr = rd_grey_ptr_reg;

// generation of empty flag
always @(posedge rd_clk, negedge rd_rst)
    begin
        if (!rd_rst)
            begin
                rd_empty_reg <= 1'b1;
            end
        else
            begin
                rd_empty_reg <= rd_empty_next;
            end
    end

always @(*)
    begin
        rd_empty_next = (rd_grey_ptr_next == wr_ptr);
    end

assign  rd_empty = rd_empty_reg;
endmodule
