`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 07/17/2023 02:24:05 PM
// Design Name: DigIC_Dip08_09_V_W2
// Module Name: load_down_up_counter_tb
// Project Name: Assignment 2
//////////////////////////////////////////////////////////////////////////////////

module load_down_up_counter_tb(
    );
    reg  [4:0] IN_tb;
    reg  Load_tb, Up_tb, Down_tb;
    reg  CLK_tb;
    wire [4:0] Counter_tb;
    wire High_tb, Low_tb;
    
    load_down_up_counter DUT (
        .IN(IN_tb),
        .Load(Load_tb),
        .Up(Up_tb),
        .Down(Down_tb),
        .CLK(CLK_tb),
        .Counter(Counter_tb),
        .High(High_tb),
        .Low(Low_tb)
    );
    
    always #5 CLK_tb = ~CLK_tb;
    
    initial
        begin
            $dumpfile("count.vcd");
            $dumpvars;
            CLK_tb  = 1'b0;
            Load_tb = 1'b0;
            Up_tb   = 1'b0;
            Down_tb = 1'b0;
            IN_tb   = 5'b00011;
            $monitor("time=%0t, load=%b, up=%b, down=%b, counter=%d, high flag=%d, low flag=%d",
                    $time, Load_tb, Up_tb, Down_tb, Counter_tb, High_tb, Low_tb);
            $display("TEST CASE 1"); // test load function
            #10                         // apply @ current -ve edge
            Load_tb = 1'b1;
            #10                         // test @ next -ve edge
            if (Counter_tb != 5'b00011)
                $display("TEST CASE 1 is failed");
            else
                $display("TEST CASE 1 is passed");
            $display("TEST CASE 2"); // test load priority over down             
            Down_tb = 1'b1;
            #10                         // test @ next -ve edge
            if (Counter_tb != 5'b00011)
                $display("TEST CASE 2 is failed");
            else
                $display("TEST CASE 2 is passed");
            $display("TEST CASE 3"); // test load priority over up
            Up_tb   = 1'b1;
            #10                         // test @ next -ve edge
            if (Counter_tb != 5'b00011)
                $display("TEST CASE 3 is failed");
            else
                $display("TEST CASE 3 is passed");
            $display("TEST CASE 4"); // test down function
            #10
            Load_tb = 1'b0;
            Down_tb = 1'b1;
            #10
            if (Counter_tb != 5'b00010)
                $display("TEST CASE 4 is failed");
            else
                $display("TEST CASE 4 is passed");
            $display("TEST CASE 5"); // test down priority over up
            Up_tb   = 1'b1;
            #10
            if (Counter_tb != 5'b00001)
                $display("TEST CASE 5 is failed");
            else
                $display("TEST CASE 5 is passed");
            $display("TEST CASE 6"); // test low flag
            #10
            if (Counter_tb != 5'b00000 && Low_tb != 1'b1)
                $display("TEST CASE 6 is failed");
            else
                $display("TEST CASE 6 is passed");
            $display("TEST CASE 7"); // test stop down @ raised low flag
            #10
            if (Counter_tb != 5'b00000 && Low_tb != 1'b1)
                $display("TEST CASE 7 is failed");
            else
                $display("TEST CASE 7 is passed");
            $display("TEST CASE 8"); // test up function
            #10
            Load_tb = 1'b0;
            Down_tb = 1'b0;
            Up_tb   = 1'b1;
            #10
            if (Counter_tb != 5'b00001)
                $display("TEST CASE 8 is failed");
            else
                $display("TEST CASE 8 is passed");
            $display("TEST CASE 9"); // test high flag
            #310
            Load_tb = 1'b0;
            Down_tb = 1'b0;
            Up_tb   = 1'b1;
            #10
            if (Counter_tb != 5'b11111 && High_tb != 1'b1)
                $display("TEST CASE 9 is failed");
            else
                $display("TEST CASE 9 is passed");
            $display("TEST CASE 10"); // test stop up @ raised high flag
            #10
            if (Counter_tb != 5'b11111 && High_tb != 1'b1)
                $display("TEST CASE 10 is failed");
            else
                $display("TEST CASE 10 is passed");
            #10 $finish;
        end 
    
endmodule
