`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 09/10/2023 10:19:49 PM
// Design Name: DigIC_Dip08_09_CDC
// Module Name: Data_SYNC_tb
// Project Name: Data Synchronizer
//////////////////////////////////////////////////////////////////////////////////


module Data_SYNC_tb();

///////////////////// Parameters ////////////////////////

parameter STAGES_NUM = 2; 
parameter BUS_WIDTH = 8;
parameter CLK1_PERIOD = 17;
parameter CLK2_PERIOD = 5;
parameter TEST_CASES  = 5;

//////////////////// DUT Signals ////////////////////////

reg    [BUS_WIDTH - 1 : 0]     async_bus_tb;
reg                            async_bus_en_tb;
reg                            CLK_tb;
reg                            RST_tb;
wire                           en_pulse_tb;
wire   [BUS_WIDTH - 1 : 0]     sync_bus_tb;

///////////////// Loops Variables ///////////////////////

integer Operation;

/////////////////////// Memories ////////////////////////

reg    [BUS_WIDTH - 1 : 0]      Test_ASYNC_IN           [TEST_CASES - 1 : 0];
reg    [BUS_WIDTH - 1 : 0]      Expec_SYNC_OUT          [TEST_CASES - 1 : 0];
////////////////// initial block ///////////////////////

initial 
    begin
        // System Functions
        $dumpfile("DATA_SYNC_DUMP.vcd");       
        $dumpvars; 
        
        // Read Input Files
        $readmemh("C:/Users/hythe/Desktop/vivado_projects/Data_Synchronizer/Data_Synchronizer.srcs/sources_1/new/ASYNC_Ins_h.txt", Test_ASYNC_IN);
        $readmemh("C:/Users/hythe/Desktop/vivado_projects/Data_Synchronizer/Data_Synchronizer.srcs/sources_1/new/SYNC_Outs_h.txt", Expec_SYNC_OUT);
        // initialization
        initialize();
        // reset
        reset();
        // Test Cases
        for (Operation = 0; Operation < TEST_CASES; Operation = Operation + 1)
            begin
                do_oper(Test_ASYNC_IN[Operation]);
                check_out(Expec_SYNC_OUT[Operation], Operation);
            end
        $stop;
    end

/////////////////////// TASKS //////////////////////////
    
/////////////// Signals Initialization //////////////////

task initialize;
    begin
        CLK_tb          = 1'b0;
        RST_tb          = 1'b0; 
        async_bus_tb    =  'b0;
        async_bus_en_tb = 1'b0;
    end
endtask

///////////////////////// RESET /////////////////////////

task reset;
    begin
        RST_tb  = 'b1;
        #(CLK2_PERIOD)
        RST_tb  = 'b0;
        #(CLK2_PERIOD)
        RST_tb  = 'b1;
    end
endtask

///////////////// Do UART_RX Operation //////////////////

task do_oper;
    input   [BUS_WIDTH - 1 : 0] IN_ASYNC;
    begin
        async_bus_tb = IN_ASYNC;
        async_bus_en_tb = 1'b1;
        #(CLK1_PERIOD)
        async_bus_en_tb = 1'b0;   
        #(CLK1_PERIOD);
    end
endtask

////////////////// Check Out Response  ////////////////////

task check_out; 
    input  [BUS_WIDTH - 1 : 0] OUT_SYNC;
    input integer Oper_Num;
    reg    [BUS_WIDTH - 1 : 0] gen_OUT_SYNC;                      
    begin
        gen_OUT_SYNC  = sync_bus_tb;
        if(gen_OUT_SYNC == OUT_SYNC)
            begin
                $display("Test Case %d is succeeded, P_Data = %b, %t",Oper_Num, gen_OUT_SYNC, $time);
            end
        else
            begin
                $display("Test Case %d is failed, P_Data = %b, %t",Oper_Num, gen_OUT_SYNC, $time);
            end
    end
endtask

////////////////// Clock Generator  ////////////////////

always #(CLK2_PERIOD/2.0) CLK_tb = ~CLK_tb;

/////////////////// DUT Instantation ///////////////////

Data_SYNC #(.STAGES_NUM(STAGES_NUM), .BUS_WIDTH(BUS_WIDTH)) Data_SYNC_U0 (
    .async_bus(async_bus_tb),
    .async_bus_en(async_bus_en_tb),
    .CLK(CLK_tb),
    .RST(RST_tb),
    .en_pulse(en_pulse_tb),
    .sync_bus(sync_bus_tb)
);
endmodule
