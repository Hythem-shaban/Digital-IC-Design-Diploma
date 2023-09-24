`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: Eng Ali Mohamed Eltemsah
// Create Date: 07/12/2023 01:21:59 AM
// Design Name: DigIC_Dip08_09_V_W1
// Module Name: DigCt_tb
// Project Name: Assignment 1
//////////////////////////////////////////////////////////////////////////////////


module DigCt_tb(
    );
    reg IN1, IN2, IN3, IN4, IN5;
    reg CLK;
    wire OUT1, OUT2, OUT3;
    
    DigCt uut (
    .IN1(IN1),
    .IN2(IN2),
    .IN3(IN3),
    .IN4(IN4),
    .IN5(IN5),
    .CLK(CLK),
    .OUT1(OUT1),
    .OUT2(OUT2),
    .OUT3(OUT3)
    );
    
    initial
        begin
            #1280 $finish;
        end
    
    localparam T = 20;
    always
        begin
            CLK = 1'b0;
            #(T / 2);
            CLK = 1'b1;
            #(T / 2);
        end
        
    reg [4:0] read_data [0:31];
    integer i;
    initial
        begin
            $readmemb("C:/Users/hythe/Desktop/vivado_projects/Assignment1/Assignment1.srcs/sources_1/new/read_data.txt", read_data);
            for (i=0; i<32; i=i+1)
                begin
                    {IN1, IN2, IN3, IN4, IN5} = read_data[i];
                    #40;
                end
        end
endmodule
