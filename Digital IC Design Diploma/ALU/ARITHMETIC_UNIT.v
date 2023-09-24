`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 07/27/2023 01:50:31 PM
// Design Name: DigIC_Dip08_09_V_W4
// Module Name: ARITHMETIC_UNIT
// Project Name: Assignment 4.1
//////////////////////////////////////////////////////////////////////////////////


module ARITHMETIC_UNIT #(parameter A_WIDTH = 5, B_WIDTH = 5, ARITH_WIDTH = 10)
    (
        input   wire    [A_WIDTH - 1 : 0]       A,
        input   wire    [B_WIDTH - 1 : 0]       B,
        input   wire    [1 : 0]                 ALU_FUNC,
        input   wire                            CLK, RST, EN,
        output  wire    [ARITH_WIDTH - 1 : 0]   Arith_OUT,
        output  wire                            Carry_OUT,
        output  wire                            Arith_Flag
    );
    reg [ARITH_WIDTH - 1 : 0]   Q_reg, Q_next;
    reg                         Arith_Flag_reg, Arith_Flag_next;
    reg                         Carry_OUT_reg, Carry_OUT_next;
    always @(posedge CLK, negedge RST)
        begin
            if (~RST)
                begin
                    Q_reg <= 0;
                    Arith_Flag_reg <= 0;
                    Carry_OUT_reg <= 0;
                end
            else
                begin
                    Q_reg <= Q_next;
                    Arith_Flag_reg <= Arith_Flag_next;
                    Carry_OUT_reg <= Carry_OUT_next;
                end
        end
    
    always @(*)
        begin
            Q_next = Q_reg;
            Arith_Flag_next = 1'b0;
            Carry_OUT_next = 1'b0;
            if (EN)
                begin
                    Arith_Flag_next = 1'b1;
                    Carry_OUT_next = 1'b0;
                    case (ALU_FUNC[1:0])
                        2'b00:      {Q_next[ARITH_WIDTH - 1 : A_WIDTH + 1], Carry_OUT_next, Q_next[A_WIDTH - 1 : 0]} = A + B;
                        2'b01:      {Q_next[ARITH_WIDTH - 1 : A_WIDTH + 1], Carry_OUT_next, Q_next[A_WIDTH - 1 : 0]} = A - B;
                        2'b10:      {Carry_OUT_next, Q_next[ARITH_WIDTH - 1 : 0]} = A * B; 
                        2'b11:      {Carry_OUT_next, Q_next[ARITH_WIDTH - 1 : 0]} = A / B;
                        default:    {Carry_OUT_next, Q_next} = 0;
                    endcase
                end
            else
                begin
                    {Carry_OUT_next, Q_next} = 'b0;
                    Arith_Flag_next = 1'b0;
                end
        end
    assign Arith_Flag = Arith_Flag_reg;
    assign Arith_OUT = Q_reg;
    assign Carry_OUT = Carry_OUT_reg;
endmodule
