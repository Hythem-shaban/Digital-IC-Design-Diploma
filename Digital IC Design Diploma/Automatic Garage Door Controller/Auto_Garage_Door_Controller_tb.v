`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 08/01/2023 04:19:17 PM
// Design Name: DigIC_Dip08_09_V_W4
// Module Name: Auto_Garage_Door_Controller_tb
// Project Name: Assignment 5.1
//////////////////////////////////////////////////////////////////////////////////


module Auto_Garage_Door_Controller_tb();
    
///////////////////// Parameters ////////////////////////
    
parameter CLK_PERIOD = 20; // 50 MHz 
parameter TEST_CASES = 6;
    
//////////////////// DUT Signals ////////////////////////

reg     Up_max_tb, Dn_max_tb, Activate_tb;
reg     CLK_tb, RST_n_tb;
wire    Up_M_tb, Dn_M_tb;

///////////////// Loops Variables ///////////////////////

integer Operation;

/////////////////////// Memories ////////////////////////

reg    [2 : 0]   Test_Data    [TEST_CASES - 1 : 0];
reg    [1 : 0]   Expec_Outs   [TEST_CASES - 1 : 0]; 

////////////////// initial block ///////////////////////

initial 
    begin
        // System Functions
        $dumpfile("C:/Users/hythe/Desktop/vivado_projects/Assignment5.1/Assignment5.1.srcs/sources_1/new/Auto_Garage_Door_Controller_DUMP.vcd");       
        $dumpvars; 
        
        // Read Input Files
        $readmemb("C:/Users/hythe/Desktop/vivado_projects/Assignment5.1/Assignment5.1.srcs/sources_1/new/DATA_b.txt", Test_Data);
        $readmemb("C:/Users/hythe/Desktop/vivado_projects/Assignment5.1/Assignment5.1.srcs/sources_1/new/Expec_Out_b.txt", Expec_Outs);
        
        // initialization
        initialize();
        // reset
        reset();
        // Test Cases
        for (Operation = 0; Operation < TEST_CASES; Operation = Operation + 1)
            begin
                do_oper(Test_Data[Operation]);                       // do_lfsr_operation
                check_out(Expec_Outs[Operation],Operation);           // check output response
            end
    
        #(CLK_PERIOD);
        $stop;
    end
    
/////////////////////// TASKS //////////////////////////

/////////////// Signals Initialization //////////////////

task initialize;
    begin
        CLK_tb  = 1'b0;
        RST_n_tb  = 1'b0;
        Activate_tb = 1'b0;  
    end
endtask

///////////////////////// RESET /////////////////////////

task reset;
    begin
        RST_n_tb =  'b1;
        #(CLK_PERIOD)
        RST_n_tb  = 'b0;
        #(CLK_PERIOD)
        RST_n_tb  = 'b1;
    end
endtask

////////////////// Do LFSR Operation ////////////////////

task do_oper;
    input  [2 : 0] IN_Data ;
    integer i;
    begin
        {Activate_tb, Up_max_tb, Dn_max_tb} = IN_Data;
        #(CLK_PERIOD); 
    end
endtask

////////////////// Check Out Response  ////////////////////

task check_out;
    input  reg     [1 : 0]     expec_out;
    input  integer             Oper_Num; 
    
    reg [1 : 0] gener_out ;
    
    begin

        #(CLK_PERIOD) gener_out = {Up_M_tb, Dn_M_tb};
        if(gener_out == expec_out) 
            begin
                $display("Test Case %d @time=%0t is succeeded",Oper_Num, $time);
            end
        else
            begin
                $display("Test Case %d @time=%0t is failed", Oper_Num, $time);
            end
    end
endtask

////////////////// Clock Generator  ////////////////////

initial
    begin
        forever #(CLK_PERIOD/2) CLK_tb = ~CLK_tb;
    end

/////////////////// DUT Instantation ///////////////////
Auto_Garage_Door_Controller DUT (
    .Up_max(Up_max_tb),
    .Dn_max(Dn_max_tb),
    .Activate(Activate_tb),
    .CLK(CLK_tb),
    .RST_n(RST_n_tb),
    .Up_M(Up_M_tb),
    .Dn_M(Dn_M_tb)
);
    
endmodule
