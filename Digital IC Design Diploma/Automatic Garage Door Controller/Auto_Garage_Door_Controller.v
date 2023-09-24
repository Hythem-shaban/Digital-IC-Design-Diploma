`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 08/01/2023 03:56:49 PM
// Design Name: DigIC_Dip08_09_V_W4
// Module Name: Auto_Garage_Door_Controller
// Project Name: Assignment 5.1
//////////////////////////////////////////////////////////////////////////////////


module Auto_Garage_Door_Controller(
    input   wire    Up_max, Dn_max, Activate,
    input   wire    CLK, RST_n,
    output  reg     Up_M, Dn_M
    );
    
    localparam [1 : 0]  IDLE  = 2'b00,
                        Mv_Up = 2'b01,
                        Mv_Dn = 2'b11;
    reg [1 : 0] state_reg, state_next;
    
    // state register
    always @(posedge CLK, negedge RST_n)
        begin
            if (~RST_n)
                state_reg <= 0;
            else
                state_reg <= state_next;
        end
    // next state logic
    always @(*)
        begin
            case (state_reg)
                IDLE:       if (~Activate)
                                state_next = IDLE; 
                            else if (Activate && Dn_max && ~Up_max)
                                state_next = Mv_Up;
                            else if (Activate && ~Dn_max && Up_max)
                                state_next = Mv_Dn;
                            else
                                state_next = IDLE; 
                Mv_Up:      if (Up_max)
                                state_next = IDLE;
                            else
                                state_next = Mv_Up;
                Mv_Dn:      if (Dn_max)
                                state_next = IDLE;
                            else
                                state_next = Mv_Dn;
                default:    state_next = IDLE;
            endcase
        end
    // output logic 
    always @(*)
        begin
            case (state_reg)
                IDLE:       begin
                                Up_M = 1'b0;
                                Dn_M = 1'b0;
                            end
                Mv_Up:      begin
                                Up_M = 1'b1;
                                Dn_M = 1'b0;
                            end
                Mv_Dn:      begin
                                Up_M = 1'b0;
                                Dn_M = 1'b1;
                            end
                default:    begin
                                Up_M = 1'b0;
                                Dn_M = 1'b0;
                            end
            endcase
        end
      
endmodule
