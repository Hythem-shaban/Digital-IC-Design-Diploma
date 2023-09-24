`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 07/17/2023 01:56:01 PM
// Design Name: DigIC_Dip08_09_V_W2
// Module Name: load_down_up_counter
// Project Name: Assignment 2
//////////////////////////////////////////////////////////////////////////////////

module load_down_up_counter(
    input   wire [4:0] IN,
    input   wire Load, Up, Down,
    input   wire CLK,
    output  wire [4:0] Counter,
    output  wire  High, Low
    );
    reg [4:0] Q_reg, Q_next;
    // state reg
    always @(posedge CLK)
        begin
            Q_reg <= Q_next;
        end
    // next state logic
    always @(*)
        begin
            if (Load)                   // Load has the Highest priority
                begin
                    Q_next = IN;
                end
            else if (Down && ~Low)      // Down has Higher periority than Up
                begin                   // ~Low to check if count value is not equal to 0 which means "Low" flag = 0 
                    Q_next = Q_reg - 5'b1;
                end
            else if (Up && ~High && ~Down)       // ~High to check if count value is not equal to 31 which means "High" flag = 0 
                begin
                    Q_next = Q_reg + 5'b1;
                end
            else 
                begin
                    Q_next = Q_reg;
                end
        end
    // output logic
    assign High =  &(Q_reg);            // "High" flag = 1 if count value = 5'b11111 which is the function of AND
    assign Low  = ~|(Q_reg);            // "Low"  flag = 1 if count value = 5'b00000 which is the function of NOR
    assign Counter = Q_reg;
endmodule
