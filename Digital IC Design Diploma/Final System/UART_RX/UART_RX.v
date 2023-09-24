`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 08/30/2023 04:47:00 PM
// Design Name: DigIC_Dip08_09_UART_RX
// Module Name: UART_RX
// Project Name: UART_RX
//////////////////////////////////////////////////////////////////////////////////


module UART_RX #(parameter PRESCALE = 32, DATA_WIDTH = 8)(
    input   wire                                    CLK, RST,
    input   wire                                    PAR_TYP, PAR_EN,
    input   wire    [$clog2(PRESCALE) : 0]          Prescale,
    input   wire                                    RX_IN,
    output  wire    [DATA_WIDTH - 1 : 0]            P_Data,
    output  wire                                    Data_Valid,
    output  wire                                    framing_error,
    output  wire                                    parity_error
    );

wire [$clog2(DATA_WIDTH) : 0] bit_cnt; 
wire [$clog2(PRESCALE) : 0] edge_cnt;
wire cnt_en;
wire data_samp_en;
wire deser_en;
wire strt_chk_en, strt_glitch;
wire stp_chk_en;
wire par_chk_en;

reception_controller #(.PRESCALE(PRESCALE), .DATA_WIDTH(DATA_WIDTH)) reception_controller_U0 (
    .CLK(CLK),
    .RST(RST),
    .RX_IN(RX_IN),
    .PAR_EN(PAR_EN),
    .bit_cnt(bit_cnt),
    .edge_cnt(edge_cnt),
    .prescale(Prescale),
    .strt_glitch(strt_glitch),
    .stp_error(framing_error),
    .par_error(parity_error),
    .cnt_en(cnt_en),
    .data_samp_en(data_samp_en),
    .strt_chk_en(strt_chk_en),
    .stp_chk_en(stp_chk_en),
    .par_chk_en(par_chk_en),
    .deser_en(deser_en),
    .Data_Valid(Data_Valid)
);


edge_bit_counter #(.PRESCALE(PRESCALE), .DATA_WIDTH(DATA_WIDTH)) edge_bit_counter_UO (
    .CLK(CLK),
    .RST(RST),
    .EN(cnt_en),
    .prescale(Prescale),
    .bit_cnt(bit_cnt),
    .edge_cnt(edge_cnt)
);

wire sampled_bit;
data_sampling #(.PRESCALE(PRESCALE)) data_sampling_UO (
    .CLK(CLK),
    .RST(RST),
    .data_samp_en(data_samp_en),
    .RX_IN(RX_IN),
    .prescale(Prescale),
    .edge_cnt(edge_cnt),
    .sampled_bit(sampled_bit)
);


deserializer #(.DATA_WIDTH(DATA_WIDTH)) deserializer_UO (
    .CLK(CLK),
    .RST(RST),
    .deser_en(deser_en),
    .sampled_bit(sampled_bit),
    .P_Data(P_Data)
);


start_check start_check_UO (
    .CLK(CLK),
    .RST(RST),
    .strt_chk_en(strt_chk_en),
    .sampled_bit(sampled_bit),
    .strt_glitch(strt_glitch)
);


stop_check stop_check_UO (
    .CLK(CLK),
    .RST(RST),
    .stp_chk_en(stp_chk_en),
    .sampled_bit(sampled_bit),
    .stp_error(framing_error)
);


parity_check #(.DATA_WIDTH(DATA_WIDTH)) parity_check_UO (
    .CLK(CLK),
    .RST(RST),
    .PAR_TYP(PAR_TYP),
    .par_chk_en(par_chk_en),
    .sampled_bit(sampled_bit),
    .P_Data(P_Data),
    .par_error(parity_error)
);
endmodule
