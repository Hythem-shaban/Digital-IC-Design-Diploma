`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 07/20/2023 02:06:21 PM
// Design Name: DigIC_Dip08_09_V_W3
// Module Name: ALU_16bit
// Project Name: Assignment 3
//////////////////////////////////////////////////////////////////////////////////


module ALU_16bit(
    input   wire [15 : 0] A, B,
    input   wire [3 : 0] ALU_FUN,
    input   wire clk,
    output  reg  Arith_flag,
    output  reg  Logic_flag,
    output  reg  CMP_flag,
    output  reg  Shift_flag,
    output  wire  [15 : 0] ALU_OUT
    );
    
    reg [15 : 0] Q_reg, Q_next;
  
    always @(posedge clk)
        begin
            Q_reg <= Q_next;
        end
    
    always @(*)
        begin
            Q_next = Q_reg;
            case (ALU_FUN)
            4'b0000:    begin
                            Q_next = A + B;
                        end
            4'b0001:    begin
                            Q_next = A - B;
                        end
            4'b0010:    begin
                            Q_next = A * B;
                        end
            4'b0011:    begin
                            Q_next = A / B;
                        end
            4'b0100:    begin
                            Q_next = A & B;
                        end
            4'b0101:    begin
                            Q_next = A | B;
                        end
            4'b0110:    begin
                            Q_next = ~(A & B);
                        end
            4'b0111:    begin
                            Q_next = ~(A | B);
                        end
            4'b1000:    begin
                            Q_next = A ^ B;
                        end
            4'b1001:    begin
                            Q_next = ~(A ^ B);
                        end
            4'b1010:    begin
                            if (A == B)
                                Q_next = 1;
                            else
                                Q_next = 0;
                        end
            4'b1011:    begin
                            if (A > B)
                                Q_next = 1;
                            else
                                Q_next = 0;
                        end
            4'b1100:    begin
                            if (A < B)
                                Q_next = 1;
                            else
                                Q_next = 0;
                        end
            4'b1101:    begin
                            Q_next = A >> 1;
                        end
            4'b1110:    begin
                            Q_next = A << 1;
                        end
            default:    begin
                            Q_next = 16'b0;
                        end
            endcase
        end
        
    always @(*)
        begin
            Arith_flag  = 1'b0;
            Logic_flag  = 1'b0;
            CMP_flag    = 1'b0;
            Shift_flag  = 1'b0;
            case (ALU_FUN)
            4'b0000:    begin
                            Arith_flag = 1'b1;
                        end
            4'b0001:    begin
                            Arith_flag = 1'b1;
                        end
            4'b0010:    begin
                            Arith_flag = 1'b1;
                        end
            4'b0011:    begin
                            Arith_flag = 1'b1;
                        end
            4'b0100:    begin
                            Logic_flag = 1'b1;
                        end
            4'b0101:    begin
                            Logic_flag = 1'b1;
                        end
            4'b0110:    begin
                            Logic_flag = 1'b1;
                        end
            4'b0111:    begin
                            Logic_flag = 1'b1;
                        end
            4'b1000:    begin
                            Logic_flag = 1'b1;
                        end
            4'b1001:    begin
                            Logic_flag = 1'b1;
                        end
            4'b1010:    begin
                            CMP_flag = 1'b1;
                        end
            4'b1011:    begin
                            CMP_flag = 1'b1;
                        end
            4'b1100:    begin
                            CMP_flag = 1'b1;
                        end
            4'b1101:    begin
                            Shift_flag = 1'b1;
                        end
            4'b1110:    begin
                            Shift_flag = 1'b1;
                        end
            default:    begin
                            Arith_flag  = 1'b0;
                            Logic_flag  = 1'b0;
                            CMP_flag    = 1'b0;
                            Shift_flag  = 1'b0;
                        end
            endcase
        end
        assign ALU_OUT = Q_reg;
endmodule