`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 08/21/2023 11:51:21 PM
// Design Name: DigIC_Dip08_09_P
// Module Name: CLK_Gate
// Project Name: CLock Gating
//////////////////////////////////////////////////////////////////////////////////


module CLK_Gate(
    input   wire    CLK,
    input   wire    CLK_EN,
    output  wire    GATED_CLK
    );
    
reg     latch_out;

always @(CLK, CLK_EN)
    begin
        if (!CLK)
            begin
                latch_out <= CLK_EN;
            end
    end

assign GATED_CLK = CLK && latch_out; 

// Integrated Clock Gating Cell
/*
TLATNCAX12M U0_TLATNCAX12M (
.E(CLK_EN),
.CK(CLK),
.ECK(GATED_CLK)
);
*/
endmodule
