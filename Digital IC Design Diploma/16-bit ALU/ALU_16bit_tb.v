`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 07/20/2023 02:47:34 PM
// Design Name: DigIC_Dip08_09_V_W3
// Module Name: ALU_16bit_tb
// Project Name: Assignment 3
//////////////////////////////////////////////////////////////////////////////////


module ALU_16bit_tb(
    );
    reg     [15 : 0] A_tb, B_tb;
    reg     [3 : 0] ALU_FUN_tb;
    reg     clk_tb;
    wire    Arith_flag_tb;
    wire    Logic_flag_tb;
    wire    CMP_flag_tb;
    wire    Shift_flag_tb;
    wire    [15 : 0] ALU_OUT_tb;
    
    ALU_16bit DUT (
        .A(A_tb),
        .B(B_tb),
        .ALU_FUN(ALU_FUN_tb),
        .clk(clk_tb),
        .Arith_flag(Arith_flag_tb),
        .Logic_flag(Logic_flag_tb),
        .CMP_flag(CMP_flag_tb),
        .Shift_flag(Shift_flag_tb),
        .ALU_OUT(ALU_OUT_tb)
    );
    
    always #5 clk_tb = ~clk_tb;
    
    initial
        begin
            $dumpfile("ALU_16bit.vcd");
            $dumpvars;
            clk_tb = 1'b0;
            ALU_FUN_tb = 4'b1111;
            A_tb = 16'd6;
            B_tb = 16'd3;
            $monitor("time=%0t, A=%0d, B=%0d, ALU_FUN=%b, Arith_flag=%0b, Logic_flag=%0b, CMP_flag=%0b, Shift_flag=%0b, ALU_OUT=%b",
                        $time, A_tb, B_tb, ALU_FUN_tb, Arith_flag_tb, Logic_flag_tb, CMP_flag_tb, Shift_flag_tb, ALU_OUT_tb);
            $display("TEST CASE 1");    // test Addition
            #10
            ALU_FUN_tb = 4'b0000;
            #10
            if ((ALU_OUT_tb != 16'd9) || (Arith_flag_tb != 1'b1))
                $display("TEST CASE 1 is failed");
            else
                $display("TEST CASE 1 is passed");
            
            $display("TEST CASE 2");    // test Subtraction
            ALU_FUN_tb = 4'b0001;
            #10
            if ((ALU_OUT_tb != 16'd3) || (Arith_flag_tb != 1'b1))
                $display("TEST CASE 2 is failed");
            else
                $display("TEST CASE 2 is passed");
                
            $display("TEST CASE 3");    // test Multiplication
            ALU_FUN_tb = 4'b0010;
            #10
            if ((ALU_OUT_tb != 16'd18) || (Arith_flag_tb != 1'b1))
                $display("TEST CASE 3 is failed");
            else
                $display("TEST CASE 3 is passed");
            
            $display("TEST CASE 4");    // test Division
            ALU_FUN_tb = 4'b0011;
            #10
            if ((ALU_OUT_tb != 16'd2) || (Arith_flag_tb != 1'b1))
                $display("TEST CASE 4 is failed");
            else
                $display("TEST CASE 4 is passed");
            
            $display("TEST CASE 5");    // test logic AND
            ALU_FUN_tb = 4'b0100;
            #10
            if ((ALU_OUT_tb != 16'd2) || (Logic_flag_tb != 1'b1))
                $display("TEST CASE 5 is failed");
            else
                $display("TEST CASE 5 is passed");
            
            $display("TEST CASE 6");    // test logic OR
            ALU_FUN_tb = 4'b0101;
            #10
            if ((ALU_OUT_tb != 16'd7) || (Logic_flag_tb != 1'b1))
                $display("TEST CASE 6 is failed");
            else
                $display("TEST CASE 6 is passed");
            
            $display("TEST CASE 7");    // test logic NAND
            ALU_FUN_tb = 4'b0110;
            #10
            if ((ALU_OUT_tb != 16'b1111111111111101) || (Logic_flag_tb != 1'b1))
                $display("TEST CASE 7 is failed");
            else
                $display("TEST CASE 7 is passed");
                
            $display("TEST CASE 8");    // test logic NOR
            ALU_FUN_tb = 4'b0111;
            #10
            if ((ALU_OUT_tb != 16'b1111111111111000) || (Logic_flag_tb != 1'b1))
                $display("TEST CASE 8 is failed");
            else
                $display("TEST CASE 8 is passed");
                
            $display("TEST CASE 9");    // test logic XOR
            ALU_FUN_tb = 4'b1000;
            #10
            if ((ALU_OUT_tb != 16'd5) || (Logic_flag_tb != 1'b1))
                $display("TEST CASE 9 is failed");
            else
                $display("TEST CASE 9 is passed");
            
            $display("TEST CASE 10");    // test logic XNOR
            ALU_FUN_tb = 4'b1001;
            #10
            if ((ALU_OUT_tb != 16'b1111111111111010) || (Logic_flag_tb != 1'b1))
                $display("TEST CASE 10 is failed");
            else
                $display("TEST CASE 10 is passed");
            
            $display("TEST CASE 11");    // test Equality
            ALU_FUN_tb = 4'b1010;
            #10
            if ((ALU_OUT_tb != 16'd0) || (CMP_flag_tb != 1'b1))
                $display("TEST CASE 11 is failed");
            else
                $display("TEST CASE 11 is passed");
            
            $display("TEST CASE 12");    // test Greater than
            ALU_FUN_tb = 4'b1011;
            #10
            if ((ALU_OUT_tb != 16'd1) || (CMP_flag_tb != 1'b1))
                $display("TEST CASE 12 is failed");
            else
                $display("TEST CASE 12 is passed");
            
            $display("TEST CASE 13");    // test Less than
            ALU_FUN_tb = 4'b1100;
            #10
            if ((ALU_OUT_tb != 16'd0) || (CMP_flag_tb != 1'b1))
                $display("TEST CASE 13 is failed");
            else
                $display("TEST CASE 13 is passed");
            
            $display("TEST CASE 14");    // test Right Shift
            ALU_FUN_tb = 4'b1101;
            #10
            if ((ALU_OUT_tb != 16'd3) || (Shift_flag_tb != 1'b1))
                $display("TEST CASE 14 is failed");
            else
                $display("TEST CASE 14 is passed");
            
            $display("TEST CASE 15");    // test Left Shift
            ALU_FUN_tb = 4'b1110;
            #10
            if ((ALU_OUT_tb != 16'd12) || (Shift_flag_tb != 1'b1))
                $display("TEST CASE 15 is failed");
            else
                $display("TEST CASE 15 is passed");
            $display("TEST CASE 16");    // test Default
            ALU_FUN_tb = 4'b1111;
            #10
            if (ALU_OUT_tb != 16'd0)
                $display("TEST CASE 16 is failed");
            else
                $display("TEST CASE 16 is passed");
            #10 $stop;
            
        end
endmodule
