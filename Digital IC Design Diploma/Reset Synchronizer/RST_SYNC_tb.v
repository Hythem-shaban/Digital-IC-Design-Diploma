`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 09/10/2023 10:56:37 PM
// Design Name: DigIC_Dip08_09_CDC
// Module Name: RST_SYNC_tb
// Project Name: Reset Synchronizer
//////////////////////////////////////////////////////////////////////////////////


module RST_SYNC_tb();

///////////////////// Parameters ////////////////////////

parameter STAGES_NUM  = 2;
parameter CLK_PERIOD  = 5;

//////////////////// DUT Signals ////////////////////////

reg         CLK_tb;
reg         RST_tb;
wire        SYNC_RST_tb;

////////////////// initial block ///////////////////////

initial 
    begin
        // System Functions
        $dumpfile("RST_SYNC_DUMP.vcd");       
        $dumpvars; 
        
        // initialization
        initialize();
        // reset
        reset();
        // repeat(STAGES_NUM) @(posedge CLK_tb);
        #(STAGES_NUM*CLK_PERIOD);
        if(SYNC_RST_tb == 1)
            begin
                $display("Test Case is succeeded %b %t",SYNC_RST_tb, $time);
            end
        else
            begin
                $display("Test Case is failed %b %t",SYNC_RST_tb, $time);
            end
        #(CLK_PERIOD);
        $stop;
    end
    
/////////////////////// TASKS //////////////////////////
        
/////////////// Signals Initialization //////////////////

task initialize;
    begin
        CLK_tb      = 1'b0;
        RST_tb      = 1'b0; 
    end
endtask

///////////////////////// RESET /////////////////////////

task reset;
    begin
        RST_tb  = 'b1;
        #(CLK_PERIOD)
        RST_tb  = 'b0;
        #(CLK_PERIOD)
        RST_tb  = 'b1;
    end
endtask

////////////////// Clock Generator  ////////////////////

always #(CLK_PERIOD/2.0) CLK_tb = ~CLK_tb;

/////////////////// DUT Instantation ///////////////////

RST_SYNC #(.STAGES_NUM(STAGES_NUM)) RST_SYNC_U0 (
    .CLK(CLK_tb),
    .RST(RST_tb),
    .SYNC_RST(SYNC_RST_tb)
);
endmodule
