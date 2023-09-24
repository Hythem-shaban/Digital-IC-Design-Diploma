`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 07/27/2023 01:51:16 PM
// Design Name: DigIC_Dip08_09_V_W4
// Module Name: LOGIC_UNIT
// Project Name: Assignment 4.1
//////////////////////////////////////////////////////////////////////////////////


module LOGIC_UNIT #(parameter A_WIDTH = 5, B_WIDTH = 5, LOGIC_WIDTH = 5)
    (
        input   wire    [A_WIDTH - 1 : 0]       A,
        input   wire    [B_WIDTH - 1 : 0]       B,
        input   wire    [1 : 0]                 ALU_FUNC,
        input   wire                            CLK, RST, EN,
        output  wire    [LOGIC_WIDTH - 1 : 0]   Logic_OUT,
        output  wire                            Logic_Flag
    );
    reg [LOGIC_WIDTH - 1 : 0] Q_reg, Q_next;
    reg                       Logic_Flag_reg, Logic_Flag_next;
    always @(posedge CLK, negedge RST)
        begin
            if (~RST)
                begin
                    Q_reg <= 0;
                    Logic_Flag_reg <= 1'b0;
                end
                
            else
                begin
                    Q_reg <= Q_next;
                    Logic_Flag_reg <= Logic_Flag_next;
                end       
        end
    
    always @(*)
        begin
            if (EN)
                begin
                    Logic_Flag_next = 1'b1;
                    case (ALU_FUNC[1:0])
                        2'b00:      Q_next = A & B; 
                        2'b01:      Q_next = A | B;
                        2'b10:      Q_next = ~(A & B); 
                        2'b11:      Q_next = ~(A | B);
                        default:    Q_next = 0;
                    endcase
                end
            else
                begin
                    Q_next = 'b0;
                    Logic_Flag_next = 1'b0;
                end
        end
    assign Logic_Flag = Logic_Flag_reg;
    assign Logic_OUT = Q_reg;
endmodule
