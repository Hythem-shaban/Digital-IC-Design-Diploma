`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 09/09/2023 10:58:36 PM
// Design Name: DigIC_Dip08_09_CDC
// Module Name: Pulse_GEN
// Project Name: Pulse Generator
//////////////////////////////////////////////////////////////////////////////////


module Pulse_GEN(
    input   wire    in,
    input   wire    CLK,
    input   wire    RST,
    output  wire    out_pulse
    );

reg     out_pulse_reg,  out_pulse_next;
reg     pulse_reg, pulse_next;
wire    generated_pulse;

// pulse generator
always @(posedge CLK, negedge RST)
    begin
        if (!RST)
            begin
                pulse_reg <= 0;
            end
        else
            begin
                pulse_reg <= pulse_next;
            end
    end

always @(*)
    begin
        pulse_next = in;
    end

assign generated_pulse = in && (~pulse_reg);

// register pulse
always @(posedge CLK, negedge RST)
    begin
        if (!RST)
            begin
                out_pulse_reg <= 0;
            end
        else
            begin
                out_pulse_reg <= out_pulse_next;
            end
    end

always @(*)
    begin
        out_pulse_next = generated_pulse;
    end

assign out_pulse = out_pulse_reg;

endmodule

