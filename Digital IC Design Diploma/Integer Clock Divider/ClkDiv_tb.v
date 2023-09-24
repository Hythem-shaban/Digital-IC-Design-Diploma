`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 08/22/2023 01:16:09 AM
// Design Name: DigIC_Dip08_09_P
// Module Name: ClkDiv_tb
// Project Name: Integer Clock Divider
//////////////////////////////////////////////////////////////////////////////////


module ClkDiv_tb();

///////////////////// Parameters ////////////////////////
parameter DIVIDED_RATIO_WIDTH = 4;
parameter CLK_PERIOD = 10;
parameter TEST_CASES = 4;

//////////////////// DUT Signals ////////////////////////
reg                                     i_ref_clk_tb;
reg                                     i_rst_n_tb;
reg                                     i_clk_en_tb;
reg     [DIVIDED_RATIO_WIDTH - 1 : 0]   i_div_ratio_tb;
wire                                    o_div_clk_tb;

///////////////// Loops Variables ///////////////////////
integer Operation;

/////////////////////// Memories ////////////////////////
reg    [DIVIDED_RATIO_WIDTH - 1 : 0]    Test_Ratio          [TEST_CASES - 1 : 0];
//reg    [$clog2(CLK_PERIOD)  - 1 : 0]    Expec_Clk_Period    [TEST_CASES - 1 : 0];

////////////////// initial block ///////////////////////
initial 
    begin
        // System Functions
        $dumpfile("ClkDiv_DUMP.vcd");       
        $dumpvars; 
        
        // Read Input Files
        $readmemh("C:/Users/hythe/Desktop/vivado_projects/Integer Clock Divider/Integer Clock Divider.srcs/sources_1/new/Ratio_h.txt", Test_Ratio);
        //$readmemb("Clk_Period_h.txt", Expec_Clk_Period);
        // initialization
        initialize();
        //reset(); 
        // Test Cases
        for (Operation = 0; Operation < TEST_CASES; Operation = Operation + 1)
            begin
                do_oper(Test_Ratio[Operation]); 
                //check_out(Expec_Clk_Period[Operation], Operation); 
            end
        $stop;
    end

/////////////////////// TASKS //////////////////////////

/////////////// Signals Initialization //////////////////

task initialize;
    begin
        i_ref_clk_tb      = 1'b0;
        i_rst_n_tb        = 1'b0; 
        i_clk_en_tb       = 1'b0;
    end
endtask

///////////////////////// RESET /////////////////////////

task reset;
    begin
        i_rst_n_tb  = 'b1;
        #(CLK_PERIOD)
        i_rst_n_tb  = 'b0;
        #(CLK_PERIOD)
        i_rst_n_tb  = 'b1;
    end
endtask

////////////////// Do LFSR Operation ////////////////////

task do_oper;
    input   [DIVIDED_RATIO_WIDTH - 1 : 0] IN_Ratio;
    begin 
        reset();     
        i_div_ratio_tb = IN_Ratio;
        i_clk_en_tb = 1'b1;
        #(21*CLK_PERIOD);
        i_clk_en_tb = 1'b0;
    end
endtask

////////////////// Clock Generator  ////////////////////
always #(CLK_PERIOD/2.0) i_ref_clk_tb = ~i_ref_clk_tb;

/////////////////// DUT Instantation ///////////////////
ClkDiv #(.DIVIDED_RATIO_WIDTH(DIVIDED_RATIO_WIDTH)) DUT (
    .i_ref_clk(i_ref_clk_tb),
    .i_rst_n(i_rst_n_tb),
    .i_clk_en(i_clk_en_tb),
    .i_div_ratio(i_div_ratio_tb),
    .o_div_clk(o_div_clk_tb)
);
endmodule
