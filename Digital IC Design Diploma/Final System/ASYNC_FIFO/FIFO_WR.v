`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 09/12/2023 10:34:01 PM
// Design Name: DigIC_Dip08_09_CDC
// Module Name: FIFO_WR
// Project Name: Asynchronous FIFO
//////////////////////////////////////////////////////////////////////////////////


module FIFO_WR #(parameter ADD_WIDTH = 4)(
    input   wire                            wr_clk,
    input   wire                            wr_rst,
    input   wire                            wr_inc,
    input   wire    [ADD_WIDTH     : 0]     rd_ptr,
    output  wire    [ADD_WIDTH     : 0]     wr_ptr,
    output  wire    [ADD_WIDTH - 1 : 0]     wr_addr,
    output  wire                            wr_full
    );

reg     [ADD_WIDTH : 0]     wr_bin_ptr_reg, wr_bin_ptr_next;
reg     [ADD_WIDTH : 0]     wr_grey_ptr_reg, wr_grey_ptr_next;
reg                         wr_full_reg, wr_full_next;

// generation of write address
always @(posedge wr_clk, negedge wr_rst)
    begin
        if (!wr_rst)
            begin
                wr_bin_ptr_reg <= 0;
            end
        else
            begin
                wr_bin_ptr_reg <= wr_bin_ptr_next;
            end
    end

always @(*)
    begin
        if (wr_inc && !wr_full)
            begin
                wr_bin_ptr_next <= wr_bin_ptr_reg + 1;
            end
        else
            begin
                wr_bin_ptr_next <= wr_bin_ptr_reg;
            end
    end
    
assign  wr_addr = wr_bin_ptr_reg[ADD_WIDTH - 1 : 0];

// generation of write gray pointer
always @(posedge wr_clk, negedge wr_rst)
    begin
        if (!wr_rst)
            begin
                wr_grey_ptr_reg <= 0;
            end
        else
            begin
                wr_grey_ptr_reg <= wr_grey_ptr_next;
            end
    end

always @(*)
    begin
        wr_grey_ptr_next = (wr_bin_ptr_next >> 1) ^ wr_bin_ptr_next;    // binary to gray conversion
    end
 
assign  wr_ptr = wr_grey_ptr_reg;

// generation of full flag
always @(posedge wr_clk, negedge wr_rst)
    begin
        if (!wr_rst)
            begin
                wr_full_reg <= 1'b0;
            end
        else
            begin
                wr_full_reg <= wr_full_next;
            end
    end

always @(*)
    begin
        wr_full_next = (wr_grey_ptr_next[ADD_WIDTH]         != rd_ptr[ADD_WIDTH]        ) && 
                       (wr_grey_ptr_next[ADD_WIDTH - 1]     != rd_ptr[ADD_WIDTH - 1]    ) && 
                       (wr_grey_ptr_next[ADD_WIDTH - 2 : 0] == rd_ptr[ADD_WIDTH - 2 : 0]);
    end

assign  wr_full = wr_full_reg;
endmodule
