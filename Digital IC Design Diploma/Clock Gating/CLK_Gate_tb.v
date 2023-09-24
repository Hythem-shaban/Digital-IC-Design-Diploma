`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 08/21/2023 11:51:21 PM
// Design Name: DigIC_Dip08_09_P
// Module Name: CLK_Gate_tb
// Project Name: CLock Gating
//////////////////////////////////////////////////////////////////////////////////


module CLK_Gate_tb();

///////////////////// Parameters ////////////////////////

parameter CLK_PERIOD = 5;

//////////////////// DUT Signals ////////////////////////

reg     CLK_tb;
reg     CLK_EN_tb;
wire    GATED_CLK_tb;

////////////////// initial block ///////////////////////
initial 
    begin
        // System Functions
        $dumpfile("CLK_Gate_DUMP.vcd");       
        $dumpvars; 
        
        // initialization
        initialize();
        #(CLK_PERIOD)
        CLK_EN_tb   = 1'b1;
        #(10*CLK_PERIOD)
        CLK_EN_tb   = 1'b0;
        #(2*CLK_PERIOD)
        CLK_EN_tb   = 1'b1;
        #(5*CLK_PERIOD)
        CLK_EN_tb   = 1'b0;
        $stop;
    end
/////////////////////// TASKS //////////////////////////
    
/////////////// Signals Initialization //////////////////

task initialize;
    begin
        CLK_tb      = 1'b0;
        CLK_EN_tb   = 1'b0;
    end
endtask

////////////////// Clock Generator  ////////////////////

always #(CLK_PERIOD/2.0) CLK_tb = ~CLK_tb;

/////////////////// DUT Instantation ///////////////////

CLK_Gate DUT (
    .CLK(CLK_tb),
    .CLK_EN(CLK_EN_tb),
    .GATED_CLK(GATED_CLK_tb)
);

endmodule
