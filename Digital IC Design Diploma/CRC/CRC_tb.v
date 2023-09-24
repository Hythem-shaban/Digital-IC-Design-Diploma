`timescale 1ns / 1ps

// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 08/01/2023 02:11:38 AM
// Design Name: DigIC_Dip08_09_V_W5
// Module Name: CRC_tb
// Project Name: Assignment 5.0
//////////////////////////////////////////////////////////////////////////////////


module CRC_tb();

///////////////////// Parameters ////////////////////////

parameter DATA_LENGTH = 1;
parameter CLK_PERIOD = 100;
parameter TEST_CASES = 10;

//////////////////// DUT Signals ////////////////////////

reg     Data_tb;
reg     Active_tb;
reg     CLK_tb;
reg     RST_n_tb;
wire    CRC_tb;
wire    Valid_tb;

///////////////// Loops Variables ///////////////////////

integer Operation;

/////////////////////// Memories ////////////////////////

reg    [DATA_LENGTH*8 - 1 : 0]   Test_Data    [TEST_CASES - 1 : 0];
reg    [DATA_LENGTH*8 - 1 : 0]   Expec_Outs   [TEST_CASES - 1 : 0];

////////////////// initial block ///////////////////////

initial 
    begin
        // System Functions
        $dumpfile("CRC_DUMP.vcd");       
        $dumpvars; 
        
        // Read Input Files
        $readmemh("C:/Users/hythe/Desktop/vivado_projects/Assignment5.0/Assignment5.0.srcs/sources_1/new/DATA_h.txt", Test_Data);
        $readmemh("C:/Users/hythe/Desktop/vivado_projects/Assignment5.0/Assignment5.0.srcs/sources_1/new/Expec_Out_h.txt", Expec_Outs);
        
        // initialization
        initialize();
        reset();
        // Test Cases
        for (Operation = 0; Operation < TEST_CASES; Operation = Operation + 1)
            begin
                do_oper(Test_Data[Operation]);                       // do_lfsr_operation
                check_out(Expec_Outs[Operation],Operation);           // check output response
            end
        $stop;
    end

/////////////////////// TASKS //////////////////////////

/////////////// Signals Initialization //////////////////

task initialize;
    begin
        CLK_tb      = 1'b0;
        RST_n_tb    = 1'b0;
        Active_tb   = 1'b0;  
    end
endtask

///////////////////////// RESET /////////////////////////

task reset;
    begin
        RST_n_tb  = 'b1;
        #(CLK_PERIOD)
        RST_n_tb  = 'b0;
        #(CLK_PERIOD)
        RST_n_tb  = 'b1;
    end
endtask

////////////////// Do LFSR Operation ////////////////////

task do_oper;
    input  [DATA_LENGTH*8 - 1 : 0] IN_Data ;
    integer i;
    begin
        //reset();
        Active_tb = 1'b1;
        for(i = 0; i < DATA_LENGTH*8; i = i + 1)
            begin
                Data_tb = IN_Data[i];
                #(CLK_PERIOD);
            end
        Active_tb = 1'b0;   
    end
endtask

////////////////// Check Out Response  ////////////////////

task check_out;
    input  reg     [DATA_LENGTH*8 : 0]     expec_out;
    input  integer             Oper_Num; 
    
    integer i;
    reg [DATA_LENGTH*8 : 0] gener_out ;
    
    begin
        @(posedge Valid_tb)
        #(CLK_PERIOD)
        for(i = 0; i < DATA_LENGTH*8; i = i + 1)
            begin
                 gener_out[i] = CRC_tb;   
                  #(CLK_PERIOD);
            end
        if(gener_out == expec_out) 
            begin
                $display("Test Case %d is succeeded",Oper_Num);
            end
        else
            begin
                $display("Test Case %d is failed", Oper_Num);
            end
    end
endtask

////////////////// Clock Generator  ////////////////////

always #(CLK_PERIOD/2) CLK_tb = ~CLK_tb;

/////////////////// DUT Instantation ///////////////////

CRC DUT #(.DATA_LENGTH(DATA_LENGTH))(
    .Data(Data_tb),
    .Active(Active_tb),
    .CLK(CLK_tb),
    .RST_n(RST_n_tb),
    .CRC(CRC_tb),
    .Valid(Valid_tb)
);

endmodule
