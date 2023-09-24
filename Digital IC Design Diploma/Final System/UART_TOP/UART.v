`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 09/15/2023 03:03:17 PM
// Design Name: DigIC_Dip08_09_UART
// Module Name: UART
// Project Name: UART
//////////////////////////////////////////////////////////////////////////////////


module UART #(parameter PRESCALE = 32, DATA_WIDTH = 8)(
    input   wire                            RST,
    input   wire                            TX_CLK,
    input   wire    [DATA_WIDTH  -  1 : 0]  TX_P_Data,
    input   wire                            TX_Data_Valid,
    output  wire                            TX_OUT,
    output  wire                            TX_OUT_Busy,
    output  wire                            TX_OUT_started,
    input   wire                            RX_CLK,
    input   wire                            RX_IN,
    output  wire    [DATA_WIDTH  -  1 : 0]  RX_P_Data,
    output  wire                            RX_Data_Valid,
    input   wire    [$clog2(PRESCALE) : 0]  Prescale,                            
    input   wire                            PAR_TYP,
    input   wire                            PAR_EN,
    output  wire                            framing_error,
    output  wire                            parity_error
    );

UART_TX #(.DATA_WIDTH(DATA_WIDTH)) U0_UART_TX (
    .CLK(TX_CLK),
    .RST(RST),
    .PAR_TYP(PAR_TYP),
    .PAR_EN(PAR_EN),
    .P_Data(TX_P_Data),
    .Data_Valid(TX_Data_Valid),
    .TX_Out(TX_OUT),
    .Busy(TX_OUT_Busy),
    .started(TX_OUT_started)
);

UART_RX #(.DATA_WIDTH(DATA_WIDTH), .PRESCALE(PRESCALE)) U0_UART_RX (
    .CLK(RX_CLK),
    .RST(RST),
    .PAR_TYP(PAR_TYP),
    .PAR_EN(PAR_EN),
    .Prescale(Prescale),
    .RX_IN(RX_IN),
    .P_Data(RX_P_Data),
    .Data_Valid(RX_Data_Valid),
    .framing_error(framing_error),
    .parity_error(parity_error)
);
endmodule
