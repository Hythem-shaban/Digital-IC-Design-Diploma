`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 08/21/2023 11:51:21 PM
// Design Name: DigIC_Dip08_09_P
// Module Name: ClkDiv
// Project Name: Integer Clock Divider
//////////////////////////////////////////////////////////////////////////////////


module ClkDiv #(parameter DIVIDED_RATIO_WIDTH = 8)(
    input   wire                                       i_ref_clk,
    input   wire                                       i_rst_n,
    input   wire                                       i_clk_en,
    input   wire       [DIVIDED_RATIO_WIDTH - 1 : 0]   i_div_ratio,
    output  wire                                       o_div_clk
    );

reg     [DIVIDED_RATIO_WIDTH - 1 : 0]   i_div_ratio_reg;                            // to register input i_div_ratio
reg     [DIVIDED_RATIO_WIDTH - 2 : 0]   counter_reg;                                // counter
reg                                     odd_high_pulse;                             // flag for high pulse in case of odd ratio
reg                                     odd_low_pulse;                              // flag for low pulse in case of odd ratio
reg                                     o_div_clk_reg;                              // to register output o_div_clk

wire    [DIVIDED_RATIO_WIDTH - 2 : 0]   high_pulse_counts;                           // counter final value of high pulse in case of even or odd
wire    [DIVIDED_RATIO_WIDTH - 2 : 0]   low_pulse_counts;                           // counter final value of low pulse in case of odd
wire                                    clk_div_en;                                 // for the corner case
wire                                    even_half_period_done;                      // to check if even and counter = final value of half period
wire                                    odd_high_pulse_done;                         // to check if odd and counter = final value of high pulse
wire                                    odd_low_pulse_done;                         // to check if odd and counter = final value of low pulse
wire                                    is_odd_ratio;                               // determine whether input ratio is odd or even

always @(posedge i_ref_clk, negedge i_rst_n)
    begin
        if (!i_rst_n)
            i_div_ratio_reg <= 0;
        else
            i_div_ratio_reg <= i_div_ratio;
    end

always @(posedge i_ref_clk, negedge i_rst_n)
    begin
        if (!i_rst_n)
            begin
                o_div_clk_reg <= 0;
                counter_reg <= 0;
                odd_high_pulse <= 0; 
                odd_low_pulse <= 1;   
            end
        else if (clk_div_en)
            begin
                if (even_half_period_done)
                    begin
                        counter_reg <= 0;
                        o_div_clk_reg <= ~o_div_clk_reg;
                    end
                else if (odd_high_pulse_done || odd_low_pulse_done)
                    begin
                        counter_reg <= 0;
                        o_div_clk_reg <= ~o_div_clk_reg;
                        odd_high_pulse <= ~odd_high_pulse; 
                        odd_low_pulse <= ~odd_low_pulse;
                    end
                else
                    begin
                        counter_reg <= counter_reg + 1'b1;
                    end 
            end
    end

assign high_pulse_counts = ((i_div_ratio_reg >> 1) - 1);      // in case of even ratio, low-pulse counts = high-pulse counts (duty cycle = 50%)
assign low_pulse_counts = (i_div_ratio_reg >> 1); // in case of odd ratio, low-pulse counts = high-pulse counts + 1 (duty cycle < 50%)
assign is_odd_ratio = i_div_ratio_reg[0];

assign even_half_period_done = (!is_odd_ratio) && (counter_reg == high_pulse_counts);
assign odd_high_pulse_done = ((is_odd_ratio) && (counter_reg == high_pulse_counts) && (odd_high_pulse)); 
assign odd_low_pulse_done = ((is_odd_ratio) && (counter_reg == low_pulse_counts) && (odd_low_pulse));
assign clk_div_en = (i_clk_en) && (i_div_ratio_reg != 0) && (i_div_ratio_reg != 1);

assign o_div_clk = clk_div_en? o_div_clk_reg : i_ref_clk; // if clock divider is enabled, output divided clock. else, output reference clock.
endmodule
