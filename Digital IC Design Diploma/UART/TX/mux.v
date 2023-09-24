`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 08/17/2023 01:18:51 AM
// Design Name: DigIC_Dip08_09_UART_TX
// Module Name: mux
// Project Name: UART_TX
//////////////////////////////////////////////////////////////////////////////////


module mux (
        input   wire                    CLK, RST,
        input   wire                    IN0, IN1, IN2, IN3, IN4,
        input   wire      [2 : 0]       SEL,
        output  wire                    OUT
    );
    
reg OUT_reg, OUT_next;
always @(posedge CLK, negedge RST)
    begin
        if (!RST)
            OUT_reg <= 1'b1;
        else
            OUT_reg <= OUT_next;
    end
    
always @(*)
    begin
        case(SEL)
            3'b000:     OUT_next = IN0;
            3'b001:     OUT_next = IN1;
            3'b010:     OUT_next = IN2;
            3'b011:     OUT_next = IN3;
            3'b100:     OUT_next = IN4;
            default:    OUT_next = IN0;
        endcase
    end

assign OUT = OUT_reg;
endmodule
