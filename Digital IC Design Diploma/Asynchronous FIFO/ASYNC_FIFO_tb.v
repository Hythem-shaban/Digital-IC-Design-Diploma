`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 09/13/2023 12:21:20 AM
// Design Name: DigIC_Dip08_09_CDC
// Module Name: ASYNC_FIFO_tb
// Project Name: Asynchronous FIFO
//////////////////////////////////////////////////////////////////////////////////


module ASYNC_FIFO_tb();

///////////////////// Parameters ////////////////////////

parameter DATA_WIDTH    = 8;
parameter MEM_DEPTH     = 16;
parameter ADD_WIDTH     = $clog2(MEM_DEPTH);
parameter WR_CLK_PERIOD = 10;
parameter RD_CLK_PERIOD = 25;
parameter TEST_CASES    = 5;

//////////////////// DUT Signals ////////////////////////

reg    [DATA_WIDTH - 1 : 0]     wr_data_tb;
reg                             wr_clk_tb;
reg                             wr_rst_tb;
reg                             wr_inc_tb;
reg                             rd_clk_tb;
reg                             rd_rst_tb;
reg                             rd_inc_tb;
wire    [DATA_WIDTH - 1 : 0]    rd_data_tb;
wire                            full_tb;
wire                            empty_tb;

////////////////// initial block ///////////////////////

initial 
    begin
        // System Functions
        $dumpfile("UART_TX_DUMP.vcd");       
        $dumpvars; 
        
        // initialization
        initialize();
        // reset
        wr_reset();
        rd_reset();
        // Test Cases
        // test 1: test empty flag = 0
        #(WR_CLK_PERIOD);
        wr_data_tb = 8'hAA;
        wr_inc_tb = 1'b1;
        #(WR_CLK_PERIOD);
        wr_inc_tb = 1'b0;
        #(2*RD_CLK_PERIOD);
        if (empty_tb == 1'b0)
            $display("Test Case 1 is succeeded, empty = %b",empty_tb);
        else
            $display("Test Case 1 is failed, empty = %b",empty_tb);
        // test 2: test read operation
        #(RD_CLK_PERIOD);
        rd_inc_tb = 1'b1;
        if (rd_data_tb == 8'hAA)
            $display("Test Case 2 is succeeded, rd_data = %h",rd_data_tb);
        else
            $display("Test Case 2 is failed, rd_data = %h",rd_data_tb);
        #(RD_CLK_PERIOD);
        rd_inc_tb = 1'b0;
        // test 3: test empty flag = 1
        if (empty_tb == 1'b1)
            $display("Test Case 3 is succeeded, empty = %b",empty_tb);
        else
            $display("Test Case 3 is failed, empty = %b",empty_tb);
        // test 4: test full flag = 1
        wr_data_tb = 8'hAA;
        wr_inc_tb = 1'b1;
        #(15*WR_CLK_PERIOD);
        wr_data_tb = 8'hBB;
        #(WR_CLK_PERIOD);
        if (full_tb == 1'b1)
            $display("Test Case 4 is succeeded, full = %b",full_tb);
        else
            $display("Test Case 4 is failed, full = %b",full_tb);
        wr_inc_tb = 1'b0;
        // test 5: test full flag = 0
        rd_inc_tb = 1'b1;
        #(2*RD_CLK_PERIOD);
        if (full_tb == 1'b0)
            $display("Test Case 5 is succeeded, full = %b",full_tb);
        else
            $display("Test Case 5 is failed, full = %b",full_tb);
        // test 6: test empty flag = 1
        #(14*RD_CLK_PERIOD);
        if (empty_tb == 1'b1)
            $display("Test Case 6 is succeeded, empty = %b",empty_tb);
        else
            $display("Test Case 6 is failed, empty = %b",empty_tb);
        $stop;
    end

/////////////////////// TASKS //////////////////////////

/////////////// Signals Initialization //////////////////

task initialize;
    begin
        wr_clk_tb      = 1'b0;
        rd_clk_tb      = 1'b0;
        wr_rst_tb      = 1'b1; 
        rd_rst_tb      = 1'b1;
        wr_inc_tb      = 1'b0;
        rd_inc_tb      = 1'b0;
    end
endtask

///////////////////////// RESET /////////////////////////

task wr_reset;
    begin
        wr_rst_tb  = 'b1;
        #(WR_CLK_PERIOD)
        wr_rst_tb  = 'b0;
        #(WR_CLK_PERIOD)
        wr_rst_tb  = 'b1;
    end
endtask

task rd_reset;
    begin
        rd_rst_tb  = 'b1;
        #(RD_CLK_PERIOD)
        rd_rst_tb  = 'b0;
        #(RD_CLK_PERIOD)
        rd_rst_tb  = 'b1;
    end
endtask

////////////////// Clock Generator  ////////////////////

always #(WR_CLK_PERIOD/2.0) wr_clk_tb = ~wr_clk_tb;
always #(RD_CLK_PERIOD/2.0) rd_clk_tb = ~rd_clk_tb;

/////////////////// DUT Instantation ///////////////////

ASYNC_FIFO #(.DATA_WIDTH(DATA_WIDTH), .MEM_DEPTH(MEM_DEPTH), .ADD_WIDTH(ADD_WIDTH)) DUT (
    .wr_data(wr_data_tb),
    .wr_clk(wr_clk_tb),
    .wr_rst(wr_rst_tb),
    .wr_inc(wr_inc_tb),
    .rd_clk(rd_clk_tb),
    .rd_rst(rd_rst_tb),
    .rd_inc(rd_inc_tb),
    .rd_data(rd_data_tb),
    .full(full_tb),
    .empty(empty_tb)
);

endmodule
