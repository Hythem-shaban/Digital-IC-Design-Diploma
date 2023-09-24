`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 09/09/2023 10:58:36 PM
// Design Name: DigIC_Dip08_09_CDC
// Module Name: Pulse_GEN_tb
// Project Name: Pulse Generator
//////////////////////////////////////////////////////////////////////////////////


module Pulse_GEN_tb();

///////////////////// Parameters ////////////////////////

parameter CLK_PERIOD = 10;

//////////////////// DUT Signals ////////////////////////

reg    in_tb;
reg    CLK_tb;
reg    RST_tb;
wire   out_pulse_tb;

////////////////// initial block ///////////////////////
initial 
    begin
        // System Functions
        $dumpfile("Pulse_GEN_DUMP.vcd");       
        $dumpvars; 
        
        // initialization
        initialize();
        // reset
        reset(); 
        
        #(CLK_PERIOD);
        in_tb = 1'b1;
        #(5*CLK_PERIOD);
        in_tb = 1'b0;
        #(2*CLK_PERIOD);
        in_tb = 1'b1;
        #(3*CLK_PERIOD);
        in_tb = 1'b0;
        #(3*CLK_PERIOD);

        $stop;
    end

/////////////////////// TASKS //////////////////////////

/////////////// Signals Initialization //////////////////

task initialize;
    begin
        in_tb   = 1'b0;
        CLK_tb  = 1'b0; 
        RST_tb  = 1'b0;
    end
endtask

///////////////////////// RESET /////////////////////////

task reset;
    begin
        RST_tb  = 1'b1;
        #(CLK_PERIOD)
        RST_tb  = 1'b0;
        #(CLK_PERIOD)
        RST_tb  = 1'b1;
    end
endtask

////////////////// Clock Generator  ////////////////////

always #(CLK_PERIOD/2.0) CLK_tb = ~CLK_tb;

/////////////////// DUT Instantation ///////////////////

Pulse_GEN DUT (
    .in(in_tb),
    .CLK(CLK_tb),
    .RST(RST_tb),
    .out_pulse(out_pulse_tb)
);
endmodule
