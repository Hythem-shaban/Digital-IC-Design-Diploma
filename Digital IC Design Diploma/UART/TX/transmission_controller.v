`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 08/17/2023 12:56:45 AM
// Design Name: DigIC_Dip08_09_UART_TX
// Module Name: transmission_controller
// Project Name: UART_TX
//////////////////////////////////////////////////////////////////////////////////


module transmission_controller(
        input   wire                CLK, RST,
        input   wire                Data_Valid,
        input   wire                PAR_EN,
        input   wire                S_Done,
        output  reg                 S_EN,
        output  reg     [2 : 0]     Frame_Bit_SEL,
        output  wire                Busy
    );
    
localparam  idle    = 0,
            start   = 1,
            data    = 2,
            parity  = 3,
            stop    = 4;

reg     [2 : 0]     state_reg, state_next;
reg                 busy_reg, busy_next;

always @(posedge CLK, negedge RST)
    begin
        if (!RST)
            busy_reg <= 1'b0;
        else
            busy_reg <= busy_next;
    end
// state reg   
always @(posedge CLK, negedge RST)
    begin
        if (!RST)
            state_reg <= idle;
        else
            state_reg <= state_next;
    end
// next state logic    
always @(*)
    begin
        state_next = state_reg;
        case (state_reg)
            idle:
                begin
                    if (Data_Valid)
                        state_next = start;
                    else
                        state_next = idle;      
                end
            start:
                begin
                    state_next = data;
                end
            data:
                begin
                    if (S_Done)
                        begin
                            if (PAR_EN)
                                state_next = parity;
                            else
                                state_next = stop;
                        end
                    else
                        state_next = data;
                end
            parity:
                begin
                   state_next = stop;
                end
            stop:
                begin
                    if (Data_Valid)
                        state_next = start;
                    else
                        state_next = idle;
                end
            default:
                begin
                    state_next = idle;
                end
        endcase
    end
// output logic
always @(*)
    begin
        busy_next = 1'b0;
        Frame_Bit_SEL = 3'd0;
        S_EN = 1'b0;
        case (state_reg)
            idle:
                begin
                    S_EN = 1'b0;
                    Frame_Bit_SEL = 3'd0;
                    busy_next = 1'b0;     
                end
            start:
                begin
                    S_EN = 1'b1;
                    Frame_Bit_SEL = 3'd1;
                    busy_next = 1'b1;
                end
            data:
                begin
                    S_EN = 1'b1;
                    Frame_Bit_SEL = 3'd2;
                    busy_next = 1'b1;
                    if (S_Done)
                        S_EN = 1'b0;
                    else
                        S_EN = 1'b1;
                end
            parity:
                begin
                    S_EN = 1'b0;
                    Frame_Bit_SEL = 3'd3; 
                    busy_next = 1'b1;
                end
            stop:
                begin
                    S_EN = 1'b0;
                    Frame_Bit_SEL = 3'd4; 
                    busy_next = 1'b1;
                end
            default:
                begin
                    S_EN = 1'b0;
                    Frame_Bit_SEL = 3'd0;
                    busy_next = 1'b0;
                end
        endcase
    end
assign Busy = busy_reg;
endmodule