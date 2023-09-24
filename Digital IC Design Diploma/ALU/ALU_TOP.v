`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 07/27/2023 12:56:26 PM
// Design Name: DigIC_Dip08_09_V_W4
// Module Name: ALU_TOP
// Project Name: Assignment 4.1
//////////////////////////////////////////////////////////////////////////////////


module ALU_TOP #(parameter A_WIDTH = 16, B_WIDTH = 16, ARITH_WIDTH = 32, LOGIC_WIDTH = 16, CMP_WIDTH = 16, SHIFT_WIDTH = 16)
    (
    input   wire [A_WIDTH - 1 : 0]      A,
    input   wire [B_WIDTH - 1 : 0]      B,
    input   wire [3 : 0]                ALU_FUNC,
    input   wire                        CLK, RST,
    output  wire [ARITH_WIDTH - 1 : 0]  Arith_OUT,
    output  wire                        Carry_OUT,
    output  wire [LOGIC_WIDTH - 1 : 0]  Logic_OUT,
    output  wire [CMP_WIDTH - 1 : 0]    CMP_OUT,
    output  wire [SHIFT_WIDTH - 1 : 0]  Shift_OUT,
    output  wire                        Arith_Flag, Logic_Flag, CMP_Flag, Shift_Flag
    );
    
    wire Arith_En, Logic_En, CMP_En, Shift_En;
    
    Decoder  u1 (
        .in(ALU_FUNC[3:2]),
        .out({Arith_En, Logic_En, CMP_En, Shift_En})
    );
    ARITHMETIC_UNIT #(.A_WIDTH(A_WIDTH), .B_WIDTH(B_WIDTH), .ARITH_WIDTH(ARITH_WIDTH)) u2 (
        .A(A),
        .B(B),
        .ALU_FUNC(ALU_FUNC[1:0]),
        .CLK(CLK),
        .EN(Arith_En),
        .RST(RST),
        .Arith_OUT(Arith_OUT),
        .Carry_OUT(Carry_OUT),
        .Arith_Flag(Arith_Flag)
    );
    LOGIC_UNIT #(.A_WIDTH(A_WIDTH), .B_WIDTH(B_WIDTH), .LOGIC_WIDTH(LOGIC_WIDTH)) u3 (
        .A(A),
        .B(B),
        .ALU_FUNC(ALU_FUNC[1:0]),
        .CLK(CLK),
        .EN(Logic_En),
        .RST(RST),
        .Logic_OUT(Logic_OUT),
        .Logic_Flag(Logic_Flag)
    );
    CMP_UNIT #(.A_WIDTH(A_WIDTH), .B_WIDTH(B_WIDTH), .CMP_WIDTH(CMP_WIDTH)) u4 (
        .A(A),
        .B(B),
        .ALU_FUNC(ALU_FUNC[1:0]),
        .CLK(CLK),
        .EN(CMP_En),
        .RST(RST),
        .CMP_OUT(CMP_OUT),
        .CMP_Flag(CMP_Flag)
    );
    SHIFT_UNIT #(.A_WIDTH(A_WIDTH), .B_WIDTH(B_WIDTH), .SHIFT_WIDTH(SHIFT_WIDTH)) u5 (
        .A(A),
        .B(B),
        .ALU_FUNC(ALU_FUNC[1:0]),
        .CLK(CLK),
        .EN(Shift_En),
        .RST(RST),
        .Shift_OUT(Shift_OUT),
        .Shift_Flag(Shift_Flag)
    );  
endmodule
