`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 08/31/2023 12:06:39 AM
// Design Name: DigIC_Dip08_09_UART_RX
// Module Name: UART_RX_tb
// Project Name: UART_RX
//////////////////////////////////////////////////////////////////////////////////


module UART_RX_tb();

///////////////////// Parameters ////////////////////////

parameter PRESCALE = 32;
parameter DATA_WIDTH = 8;
parameter RX_CLK_PERIOD = 5;
parameter TX_CLK_PERIOD = 160;
parameter TEST_CASES = 9;

//////////////////// DUT Signals ////////////////////////

reg                                 CLK_tb; 
reg                                 RST_tb;
reg                                 PAR_TYP_tb;
reg                                 PAR_EN_tb;
reg    [$clog2(PRESCALE) : 0]       Prescale_tb;
reg                                 RX_IN_tb;
wire   [DATA_WIDTH - 1 : 0]         P_Data_tb;
wire                                Data_Valid_tb;

///////////////// Loops Variables ///////////////////////

integer Operation;

/////////////////////// Memories ////////////////////////

reg    [(DATA_WIDTH + 3) - 1 : 0]           Test_Data             [TEST_CASES - 1 : 0];
reg                                         Test_Parity_Type      [TEST_CASES - 1 : 0];
reg                                         Test_Parity_Enable    [TEST_CASES - 1 : 0];
reg    [DATA_WIDTH - 1 : 0]                 Expec_RX_Outs         [TEST_CASES - 1 : 0];
reg                                         Expec_Data_Valid      [TEST_CASES - 1 : 0];
////////////////// initial block ///////////////////////
initial 
    begin
        // System Functions
        $dumpfile("UART_TX_DUMP.vcd");       
        $dumpvars; 
        
        // Read Input Files
        $readmemb("C:/Users/hythe/Desktop/vivado_projects/UART_RX/UART_RX.srcs/sources_1/new/DATA_b.txt", Test_Data);
        $readmemb("C:/Users/hythe/Desktop/vivado_projects/UART_RX/UART_RX.srcs/sources_1/new/Parity_Type_b.txt", Test_Parity_Type);
        $readmemb("C:/Users/hythe/Desktop/vivado_projects/UART_RX/UART_RX.srcs/sources_1/new/Parity_Enable_b.txt", Test_Parity_Enable);
        $readmemh("C:/Users/hythe/Desktop/vivado_projects/UART_RX/UART_RX.srcs/sources_1/new/Expec_RX_Outs_h.txt", Expec_RX_Outs);
        $readmemh("C:/Users/hythe/Desktop/vivado_projects/UART_RX/UART_RX.srcs/sources_1/new/Expec_Data_Valid_b.txt", Expec_Data_Valid);
        // initialization
        initialize();
        // reset
        reset();
        // Test Cases
        
        // test start glitch
        RX_IN_tb = 1'b0;
        #(RX_CLK_PERIOD)
        RX_IN_tb = 1'b1;
        #(TX_CLK_PERIOD)
        
        for (Operation = 0; Operation < TEST_CASES; Operation = Operation + 1)
            begin
                do_oper(Test_Data[Operation], Test_Parity_Type[Operation], Test_Parity_Enable[Operation], Operation); // do_uart_transmission
                if (Operation == 1)
                    begin
                        RX_IN_tb = 1'b1;
                        #(TX_CLK_PERIOD);
                    end
                //check_out(Expec_RX_Outs[Operation], Expec_Data_Valid[Operation], Operation);           // check output response
            end
        $stop;
    end
/////////////////////// TASKS //////////////////////////
    
/////////////// Signals Initialization //////////////////

task initialize;
    begin
        CLK_tb      = 1'b0;
        RST_tb      = 1'b0; 
        Prescale_tb = 32;
        RX_IN_tb    = 1'b1;
    end
endtask

///////////////////////// RESET /////////////////////////

task reset;
    begin
        RST_tb  = 'b1;
        #(RX_CLK_PERIOD)
        RST_tb  = 'b0;
        #(RX_CLK_PERIOD)
        RST_tb  = 'b1;
    end
endtask

///////////////// Do UART_RX Operation //////////////////

task do_oper;
    input   [(DATA_WIDTH + 3) - 1 : 0] IN_Data;
    input   Parity_Type, Parity_Enable;
    input   integer Oper_Num;
    integer i;
    begin
        for(i = 0; i < (DATA_WIDTH + 3); i = i + 1)
            begin
                RX_IN_tb = IN_Data[i];
                PAR_TYP_tb = Parity_Type;
                PAR_EN_tb = Parity_Enable;
                #(TX_CLK_PERIOD);
                if (Parity_Enable == 0)
                    begin
                        if (i == 9)
                            check_out(Expec_RX_Outs[Oper_Num], Expec_Data_Valid[Oper_Num], Oper_Num);
                    end
                else 
                    begin
                        if (i == 10)
                            check_out(Expec_RX_Outs[Oper_Num], Expec_Data_Valid[Oper_Num], Oper_Num);
                    end
            end
    end
endtask

////////////////// Check Out Response  ////////////////////

task check_out; 
    input  [DATA_WIDTH - 1 : 0] expec_rx_out;
    input                       expec_data_valid;
    input integer Oper_Num;
    integer i;
    reg [DATA_WIDTH - 1 : 0] gener_rx_out;
    reg                      gener_data_valid;                         
    begin
        gener_rx_out = P_Data_tb;
        gener_data_valid = Data_Valid_tb;
        if((gener_rx_out == expec_rx_out) && (gener_data_valid == expec_data_valid)) 
            begin
                $display("Test Case %d is succeeded, P_Data = %b, Data_Valid = %b, %t",Oper_Num, gener_rx_out, gener_data_valid, $time);
            end
        else
            begin
                $display("Test Case %d is failed, P_Data = %b, Data_Valid = %b, %t",Oper_Num, gener_rx_out, gener_data_valid, $time);
            end

    // test 0 is to test no parity                                      (with return to idle state)
    // test 1 is to test even parity with parity bit = 0                (with go directly to start state)
    // test 2 is to test even parity with parity bit = 1                (with go directly to start state)
    // test 3 is to test even parity with parity error                  (with go directly to start state)
    // test 4 is to test odd parity with parity bit = 0                 (with go directly to start state)
    // test 5 is to test odd parity with parity error and stop error    (with go directly to start state)
    // test 6 is to test odd parity with parity bit = 1                 (with go directly to start state)
    // test 7 is to test odd parity with parity error                   (with go directly to start state)
    // test 8 is to test odd parity with stop error                             
        
    end
endtask

////////////////// Clock Generator  ////////////////////

always #(RX_CLK_PERIOD/2.0) CLK_tb = ~CLK_tb;

/////////////////// DUT Instantation ///////////////////

UART_RX #(.PRESCALE(PRESCALE), .DATA_WIDTH(DATA_WIDTH)) DUT (
    .CLK(CLK_tb),
    .RST(RST_tb),
    .PAR_TYP(PAR_TYP_tb), 
    .PAR_EN(PAR_EN_tb),
    .Prescale(Prescale_tb),
    .RX_IN(RX_IN_tb),
    .P_Data(P_Data_tb),
    .Data_Valid(Data_Valid_tb)
);
endmodule
