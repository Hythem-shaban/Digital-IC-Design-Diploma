`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 08/17/2023 03:40:40 AM
// Design Name: DigIC_Dip08_09_UART_TX
// Module Name: UART_TX_tb
// Project Name: UART_TX
//////////////////////////////////////////////////////////////////////////////////


module UART_TX_tb();

///////////////////// Parameters ////////////////////////

parameter DATA_WIDTH = 8;
parameter CLK_PERIOD = 5;
parameter TEST_CASES = 5;

//////////////////// DUT Signals ////////////////////////

reg                       CLK_tb, RST_tb;
reg                       PAR_TYP_tb, PAR_EN_tb;
reg [DATA_WIDTH - 1 : 0]  P_Data_tb;
reg                       Data_Valid_tb;
wire                      TX_Out_tb;
wire                      Busy_tb;

///////////////// Loops Variables ///////////////////////

integer Operation;

/////////////////////// Memories ////////////////////////

reg    [DATA_WIDTH - 1 : 0]         Test_Data             [TEST_CASES - 1 : 0];
reg    [DATA_WIDTH - 1 : 0]         Test_Parity_Type      [TEST_CASES - 1 : 0];
reg    [DATA_WIDTH - 1 : 0]         Test_Parity_Enable    [TEST_CASES - 1 : 0];
reg    [(DATA_WIDTH + 3) - 1 : 0]   Expec_TX_Outs         [TEST_CASES - 1 : 0];
reg    [(DATA_WIDTH + 3) - 1 : 0]   Expec_Busy_Outs       [TEST_CASES - 1 : 0];

////////////////// initial block ///////////////////////

initial 
    begin
        // System Functions
        $dumpfile("UART_TX_DUMP.vcd");       
        $dumpvars; 
        
        // Read Input Files
        $readmemh("C:/Users/hythe/Desktop/vivado_projects/UART_TX/UART_TX.srcs/sources_1/new/DATA_h.txt", Test_Data);
        $readmemb("C:/Users/hythe/Desktop/vivado_projects/UART_TX/UART_TX.srcs/sources_1/new/Parity_Type_b.txt", Test_Parity_Type);
        $readmemb("C:/Users/hythe/Desktop/vivado_projects/UART_TX/UART_TX.srcs/sources_1/new/Parity_Enable_b.txt", Test_Parity_Enable);
        $readmemb("C:/Users/hythe/Desktop/vivado_projects/UART_TX/UART_TX.srcs/sources_1/new/Expec_TX_Outs_b.txt", Expec_TX_Outs);
        $readmemb("C:/Users/hythe/Desktop/vivado_projects/UART_TX/UART_TX.srcs/sources_1/new/Expec_Busy_Outs_b.txt", Expec_Busy_Outs);
        // initialization
        initialize();
        reset();
        // Test Cases
        for (Operation = 0; Operation < TEST_CASES; Operation = Operation + 1)
            begin
                do_oper(Test_Data[Operation], Test_Parity_Type[Operation], Test_Parity_Enable[Operation]); // do_uart_transmission
                check_out(Expec_TX_Outs[Operation], Expec_Busy_Outs[Operation], Operation);           // check output response4
            end
        $stop;
    end

/////////////////////// TASKS //////////////////////////

/////////////// Signals Initialization //////////////////

task initialize;
    begin
        CLK_tb      = 1'b0;
        RST_tb      = 1'b0; 
        Data_Valid_tb = 1'b0;
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

////////////////// Do LFSR Operation ////////////////////

task do_oper;
    input   [DATA_WIDTH - 1 : 0] IN_Data;
    input   Parity_Type, Parity_Enable;
    begin      
        P_Data_tb = IN_Data;
        PAR_TYP_tb = Parity_Type;
        PAR_EN_tb  = Parity_Enable;
        Data_Valid_tb = 1'b1;
        #(CLK_PERIOD);
        Data_Valid_tb = 1'b0;
    end
endtask

////////////////// Check Out Response  ////////////////////

task check_out; 
    input  [(DATA_WIDTH + 3) - 1 : 0] expec_tx_out;
    input  [(DATA_WIDTH + 3) - 1 : 0] expec_busy_out;
    input integer Oper_Num;
    integer i;
    reg [(DATA_WIDTH + 3) - 1 : 0] gener_tx_out;
    reg [(DATA_WIDTH + 3) - 1 : 0] gener_busy_out;
    begin
        for(i = 0; i < (DATA_WIDTH + 3); i = i + 1)
            begin
                #(CLK_PERIOD);
                gener_tx_out[i]   = TX_Out_tb;
                gener_busy_out[i] = Busy_tb;

            end
        if((gener_tx_out == expec_tx_out) && (gener_busy_out == expec_busy_out)) 
            begin
                $display("Test Case %d is succeeded, output frame = %b, output busy = %b",Oper_Num,gener_tx_out,gener_busy_out);
            end
        else
            begin
                $display("Test Case %d is failed, output frame = %b, output busy = %b",Oper_Num, gener_tx_out, gener_busy_out);
            end
        
        
    end
endtask

////////////////// Clock Generator  ////////////////////

always #(CLK_PERIOD/2.0) CLK_tb = ~CLK_tb;

/////////////////// DUT Instantation ///////////////////

UART_TX #(.DATA_WIDTH(DATA_WIDTH)) DUT (
    .CLK(CLK_tb),
    .RST(RST_tb),
    .PAR_TYP(PAR_TYP_tb), 
    .PAR_EN(PAR_EN_tb),
    .P_Data(P_Data_tb),
    .Data_Valid(Data_Valid_tb),
    .TX_Out(TX_Out_tb),
    .Busy(Busy_tb)
);
endmodule
