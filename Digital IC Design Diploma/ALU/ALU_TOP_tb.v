`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 07/27/2023 03:03:28 PM
// Design Name: DigIC_Dip08_09_V_W4
// Module Name: ALU_TOP_tb
// Project Name: Assignment 4.1
//////////////////////////////////////////////////////////////////////////////////


module ALU_TOP_tb ();
    parameter A_WIDTH = 16, B_WIDTH = 16, ARITH_WIDTH = 32, LOGIC_WIDTH = 16, CMP_WIDTH = 16, SHIFT_WIDTH = 16;
    reg [A_WIDTH - 1 : 0] A_tb;
    reg [B_WIDTH - 1 : 0] B_tb;
    reg [3 : 0] ALU_FUNC_tb;
    reg CLK_tb, RST_tb;
    wire [ARITH_WIDTH - 1 : 0] Arith_OUT_tb;
    wire Carry_OUT_tb;
    wire [LOGIC_WIDTH - 1 : 0] Logic_OUT_tb;
    wire [CMP_WIDTH - 1 : 0] CMP_OUT_tb;
    wire [SHIFT_WIDTH - 1 : 0] Shift_OUT_tb;
    wire Arith_Flag_tb, Logic_Flag_tb, CMP_Flag_tb, Shift_Flag_tb;
    
    ALU_TOP    #( 
                .A_WIDTH(A_WIDTH), 
                .B_WIDTH(B_WIDTH), 
                .ARITH_WIDTH(ARITH_WIDTH),
                .LOGIC_WIDTH(LOGIC_WIDTH), 
                .CMP_WIDTH(CMP_WIDTH), 
                .SHIFT_WIDTH(SHIFT_WIDTH)) 
             DUT(
                .A(A_tb),
                .B(B_tb),
                .ALU_FUNC(ALU_FUNC_tb),
                .CLK(CLK_tb),
                .RST(RST_tb),
                .Arith_OUT(Arith_OUT_tb),
                .Carry_OUT(Carry_OUT_tb),
                .Logic_OUT(Logic_OUT_tb),
                .CMP_OUT(CMP_OUT_tb),
                .Shift_OUT(Shift_OUT_tb),
                .Arith_Flag(Arith_Flag_tb),
                .Logic_Flag(Logic_Flag_tb),
                .CMP_Flag(CMP_Flag_tb),
                .Shift_Flag(Shift_Flag_tb)
            );
    
    always
        begin
            #4
            CLK_tb = 1'b1;
            #6
            CLK_tb = 1'b0;
        end
    
    initial
        begin
            $dumpfile("ALU.vcd");
            $dumpvars;
            RST_tb = 1'b1;
            CLK_tb = 1'b0;
            ALU_FUNC_tb = 4'b1000;
            A_tb = 'd6;
            B_tb = 'd3;
            #10
            RST_tb = 1'b0;
            $monitor("time=%0t, A=%0d, B=%0d, ALU_FUNC=%b, Arith_OUT=%0d, Arith_flag=%0b, Carry_OUT=%0b, Logic_OUT=%0b, Logic_flag=%0b, CMP_OUT=%0b, CMP_flag=%0b, Shift_OUT=%b, Shift_flag=%0b",
                         $time, A_tb, B_tb, ALU_FUNC_tb, Arith_OUT_tb, Arith_Flag_tb, Carry_OUT_tb, Logic_OUT_tb, Logic_Flag_tb, CMP_OUT_tb, CMP_Flag_tb, Shift_OUT_tb, Shift_Flag_tb);
            #10
            RST_tb = 1'b1;
            $display("TEST CASE 1");    // test Addition
            #10
            ALU_FUNC_tb = 4'b0000;
            #10
            if ((Arith_OUT_tb != 'd9) || (Arith_Flag_tb != 1'b1))
                $display("TEST CASE 1 is failed");
            else
                $display("TEST CASE 1 is passed");
            
            $display("TEST CASE 2");    // test Subtraction
            ALU_FUNC_tb = 4'b0001;
            #10
            if ((Arith_OUT_tb != 'd3) || (Arith_Flag_tb != 1'b1))
                $display("TEST CASE 2 is failed");
            else
                $display("TEST CASE 2 is passed");
                
            $display("TEST CASE 3");    // test Multiplication
            ALU_FUNC_tb = 4'b0010;
            #10
            if ((Arith_OUT_tb != 'd18) || (Arith_Flag_tb != 1'b1))
                $display("TEST CASE 3 is failed");
            else
                $display("TEST CASE 3 is passed");
            
            $display("TEST CASE 4");    // test Division
            ALU_FUNC_tb = 4'b0011;
            #10
            if ((Arith_OUT_tb != 'd2) || (Arith_Flag_tb != 1'b1))
                $display("TEST CASE 4 is failed");
            else
                $display("TEST CASE 4 is passed");
            
            $display("TEST CASE 5");    // test logic AND
            ALU_FUNC_tb = 4'b0100;
            #10
            if ((Logic_OUT_tb != 'd2) || (Logic_Flag_tb != 1'b1))
                $display("TEST CASE 5 is failed");
            else
                $display("TEST CASE 5 is passed");
            
            $display("TEST CASE 6");    // test logic OR
            ALU_FUNC_tb = 4'b0101;
            #10
            if ((Logic_OUT_tb != 'd7) || (Logic_Flag_tb != 1'b1))
                $display("TEST CASE 6 is failed");
            else
                $display("TEST CASE 6 is passed");
            
            $display("TEST CASE 7");    // test logic NAND
            ALU_FUNC_tb = 4'b0110;
            #10
            if ((Logic_OUT_tb != 'b1111111111111101) || (Logic_Flag_tb != 1'b1))
                $display("TEST CASE 7 is failed");
            else
                $display("TEST CASE 7 is passed");
                
            $display("TEST CASE 8");    // test logic NOR
            ALU_FUNC_tb = 4'b0111;
            #10
            if ((Logic_OUT_tb != 'b1111111111111000) || (Logic_Flag_tb != 1'b1))
                $display("TEST CASE 8 is failed");
            else
                $display("TEST CASE 8 is passed");
            $display("TEST CASE 9");    // test Equality
            ALU_FUNC_tb = 4'b1001;
            #10
            if ((CMP_OUT_tb != 'd0) || (CMP_Flag_tb != 1'b1))
                $display("TEST CASE 9 is failed");
            else
                $display("TEST CASE 9 is passed");
            
            $display("TEST CASE 10");    // test Greater than
            ALU_FUNC_tb = 4'b1010;
            #10
            if ((CMP_OUT_tb != 'd2) || (CMP_Flag_tb != 1'b1))
                $display("TEST CASE 10 is failed");
            else
                $display("TEST CASE 10 is passed");
            
            $display("TEST CASE 11");    // test Less than
            ALU_FUNC_tb = 4'b1011;
            #10
            if ((CMP_OUT_tb != 'd0) || (CMP_Flag_tb != 1'b1))
                $display("TEST CASE 11 is failed");
            else
                $display("TEST CASE 11 is passed");
            
            $display("TEST CASE 12");    // test A Right Shift
            ALU_FUNC_tb = 4'b1100;
            #10
            if ((Shift_OUT_tb != 'd3) || (Shift_Flag_tb != 1'b1))
                $display("TEST CASE 12 is failed");
            else
                $display("TEST CASE 12 is passed");
            
            $display("TEST CASE 13");    // test A Left Shift
            ALU_FUNC_tb = 4'b1101;
            #10
            if ((Shift_OUT_tb != 'd12) || (Shift_Flag_tb != 1'b1))
                $display("TEST CASE 13 is failed");
            else
                $display("TEST CASE 13 is passed");
            $display("TEST CASE 14");    // test B Right Shift
            ALU_FUNC_tb = 4'b1110;
            #10
            if ((Shift_OUT_tb != 'd1) || (Shift_Flag_tb != 1'b1))
                $display("TEST CASE 14 is failed");
            else
                $display("TEST CASE 14 is passed");
            
            $display("TEST CASE 15");    // test B Left Shift
            ALU_FUNC_tb = 4'b1111;
            #10
            if ((Shift_OUT_tb != 'd6) || (Shift_Flag_tb != 1'b1))
                $display("TEST CASE 15 is failed");
            else
                $display("TEST CASE 15 is passed");
            $display("TEST CASE 16");    // test carry_out
            A_tb = 'hFFFF;
            B_tb = 'hFFFF;
            ALU_FUNC_tb = 4'b0000;
            #10
            if ((Carry_OUT_tb != 'b1) || (Arith_Flag_tb != 1'b1))
                $display("TEST CASE 16 is failed");
            else
                $display("TEST CASE 16 is passed");
            
            $display("TEST CASE 17");    // test Multiplication carry_out
            A_tb = 'd65535;
            B_tb = 'd65535;
            ALU_FUNC_tb = 4'b0010;
            #10
            if ((Carry_OUT_tb != 'b1) || (Arith_Flag_tb != 1'b1))
                $display("TEST CASE 17 is failed");
            else
                $display("TEST CASE 17 is passed");
            
            $display("TEST CASE 18");    // test Subtraction carry_out
            A_tb = 'd3;
            B_tb = 'd6;
            ALU_FUNC_tb = 4'b0001;
            #10
            if ((Carry_OUT_tb != 'b1) || (Arith_Flag_tb != 1'b1))
                $display("TEST CASE 18 is failed");
            else
                $display("TEST CASE 18 is passed");
            
            $display("TEST CASE 19");    // test NO Operation
            A_tb = 'd6;
            B_tb = 'd3;
            ALU_FUNC_tb = 4'b1000;
            #10
            if ((Arith_OUT_tb != 'd0) || (Logic_OUT_tb != 'b0) || (CMP_OUT_tb != 'b0) || (Shift_OUT_tb != 'b0) || (Carry_OUT_tb != 'b0) 
                || (Arith_Flag_tb != 1'b0) || (Logic_Flag_tb != 1'b0) || (CMP_Flag_tb != 1'b0) || (Shift_Flag_tb != 1'b0))
                $display("TEST CASE 19 is failed");
            else
                $display("TEST CASE 19 is passed");
            #10 $stop;
        end
endmodule
