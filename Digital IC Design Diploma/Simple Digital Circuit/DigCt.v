`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 07/12/2023 01:21:59 AM
// Design Name: DigIC_Dip08_09_V_W1
// Module Name: DigCt
// Project Name: Assignment 1
//////////////////////////////////////////////////////////////////////////////////


module DigCt(
    IN1, IN2, IN3, IN4, IN5, CLK, OUT1, OUT2, OUT3
    );
    
    input IN1, IN2, IN3, IN4, IN5;
    input CLK;
    output OUT1, OUT2, OUT3;
    
    reg D1, D2, D3;
    reg OUT1, OUT2, OUT3;
    
    always @(IN1, IN2, IN3)
        begin
            D1 = ~(~(IN1 | IN2) & IN3);
        end
        
    always @(IN2, IN3)
        begin
            D2 = ~(IN2 & IN3);
        end
        
    always @(IN3, IN4, IN5)
        begin
            D3 = ((IN3 | ~IN4) | IN5);
        end
        
    always @(posedge CLK)
        begin
            OUT1 <= D1;
        end
    
    always @(posedge CLK)
        begin
            OUT2 <= D2;
        end
    
    always @(posedge CLK)
        begin
            OUT3 <= D3;
        end
    
    
endmodule
