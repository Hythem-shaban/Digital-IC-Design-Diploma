`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 07/27/2023 01:51:33 PM
// Design Name: DigIC_Dip08_09_V_W4
// Module Name: CMP_UNIT
// Project Name: Assignment 4.1
//////////////////////////////////////////////////////////////////////////////////


module CMP_UNIT #(parameter A_WIDTH = 5, B_WIDTH = 5, CMP_WIDTH = 5)
    (
        input   wire    [A_WIDTH - 1 : 0]       A,
        input   wire    [B_WIDTH - 1 : 0]       B,
        input   wire    [1 : 0]                 ALU_FUNC,
        input   wire                            CLK, RST, EN,
        output  wire    [CMP_WIDTH - 1 : 0]     CMP_OUT,
        output  wire                            CMP_Flag
    );
    reg [CMP_WIDTH - 1 : 0] Q_reg, Q_next;
    reg                     CMP_Flag_reg, CMP_Flag_next;
    always @(posedge CLK, negedge RST)
        begin
            if (~RST)
                begin
                    Q_reg <= 0;
                    CMP_Flag_reg <= 0;
                end
            else
                begin
                    Q_reg <= Q_next;
                    CMP_Flag_reg <= CMP_Flag_next;
                end
        end
    
    always @(*)
        begin
            if (EN)
                begin
                    case (ALU_FUNC[1:0])
                        2'b00:      begin
                                        Q_next = 0;
                                        CMP_Flag_next = 1'b0; 
                                    end
                        2'b01:      begin
                                        CMP_Flag_next = 1'b1;
                                        if (A == B)
                                            Q_next = 1;
                                        else
                                            Q_next = 0;
                                    end
                        2'b10:      begin
                                        CMP_Flag_next = 1'b1;
                                        if (A > B)
                                            Q_next = 2;
                                        else
                                            Q_next = 0;
                                    end
                        2'b11:      begin
                                        CMP_Flag_next = 1'b1;
                                        if (A < B)
                                            Q_next = 3;
                                        else
                                            Q_next = 0;
                                    end
                        default:    begin
                                        Q_next = 0;
                                        CMP_Flag_next = 1'b0;
                                    end
                    endcase
                end
            else
                begin
                    Q_next = 'b0;
                    CMP_Flag_next = 1'b0;
                end
        end
    assign CMP_Flag = CMP_Flag_reg;  
    assign CMP_OUT = Q_reg;
endmodule