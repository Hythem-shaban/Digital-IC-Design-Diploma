`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 07/27/2023 08:04:52 PM
// Design Name: DigIC_Dip08_09_V_W3
// Module Name: Register_File_tb
// Project Name: Assignment 4.2
//////////////////////////////////////////////////////////////////////////////////

module Register_File_tb(
    );
    parameter MEM_WIDTH = 16, MEM_DEPTH = 8;
    reg     [MEM_WIDTH - 1 : 0] WrData_tb;
    reg     [$clog2(MEM_DEPTH) - 1 : 0] Address_tb;
    reg     CLK_tb, RST_n_tb;
    reg     WrEn_tb, RdEn_tb;
    wire    [15 : 0] RdData_tb;
    
    Register_File #(.MEM_WIDTH(MEM_WIDTH), .MEM_DEPTH(MEM_DEPTH)) DUT(
        .WrData(WrData_tb),
        .Address(Address_tb),
        .CLK(CLK_tb),
        .RST_n(RST_n_tb),
        .WrEn(WrEn_tb),
        .RdEn(RdEn_tb),
        .RdData(RdData_tb)
    ); 
    
    always #5 CLK_tb = ~CLK_tb;
    
    initial
        begin
            $dumpfile("Regster_File.vcd");
            $dumpvars;
            CLK_tb = 1'b0;
            Address_tb = 'b000;
            WrData_tb = 'b1111_1111_0000_0000;
            WrEn_tb = 1'b0;
            RdEn_tb = 1'b0;
            RST_n_tb = 1'b0;
            $monitor("time=%0t, RST_n=%0b, WrEn=%0b, RdEn=%0b, WrData=%b, RdData=%b", $time, RST_n_tb, WrEn_tb, RdEn_tb, WrData_tb, RdData_tb);
            #10
            $display("TEST CASE 1"); // test WrData & RdData
            RST_n_tb = 1'b1;
            WrEn_tb = 1'b1;
            RdEn_tb = 1'b0;
            Address_tb = 'b000;
            #10
            WrEn_tb = 1'b0;
            RdEn_tb = 1'b1;
            Address_tb = 'b000;
            #10
            if (RdData_tb[Address_tb] != 'b1111_1111_0000_0000)
                $display("TEST CASE 1 IS FAILED");
            else
            $display("TEST CASE 1 IS PASSED");
            $display("TEST CASE 2"); // test RST (All the registers are cleared using Asynchronous active low Reset signal)
            RST_n_tb = 1'b0;
            #10
            WrEn_tb = 1'b0;
            RdEn_tb = 1'b1;
            Address_tb = 'b000;
            RST_n_tb = 1'b1;
            #10
            if (RdData_tb[Address_tb] != 'b0000_0000_0000_0000)
               $display("TEST CASE 2 IS FAILED");
            else
               $display("TEST CASE 2 IS PASSED");
           
            $display("TEST CASE 3"); // test WrEn & RdEn (Only one operation (read or write) can be evaluated at a time.)
            WrEn_tb = 1'b1;
            RdEn_tb = 1'b1;
            Address_tb = 'b111;
            #10
            if (RdData_tb[Address_tb] == 'b1111_1111_0000_0000)
                $display("TEST CASE 3 IS FAILED");
            else
                $display("TEST CASE 3 IS PASSED");
            $display("TEST CASE 4"); // test WrData & RdData
            WrData_tb = 'b1111_1111_0000_1111;
            WrEn_tb = 1'b1;
            RdEn_tb = 1'b0;
            Address_tb = 'b100;
            #10
            WrEn_tb = 1'b0;
            RdEn_tb = 1'b1;
            Address_tb = 'b100;
            #10
            if (RdData_tb[Address_tb] != 'b1111_1111_0000_1111)
                $display("TEST CASE 4 IS FAILED");
            else
                $display("TEST CASE 4 IS PASSED");
            $display("TEST CASE 5"); // test No WrEn & No RdEn (Rd BUS keeps data)
            WrData_tb = 'b1111_1111_0000_1111;
            WrEn_tb = 1'b0;
            RdEn_tb = 1'b0;
            Address_tb = 'b100;
            #10
            if (RdData_tb[Address_tb] != 'b1111_1111_0000_1111)
                $display("TEST CASE 5 IS FAILED");
            else
                $display("TEST CASE 5 IS PASSED");
            #10 $stop;   
        end
endmodule
