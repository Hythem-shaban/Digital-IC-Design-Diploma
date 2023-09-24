`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 09/15/2023 03:31:55 PM
// Design Name: DigIC_Dip08_09_Final_System
// Module Name: SYS_TOP
// Project Name: Final System
//////////////////////////////////////////////////////////////////////////////////


module SYS_TOP #(parameter PRESCALE = 32, DATA_WIDTH = 8, REG_DEPTH = 16, FIFO_DEPTH = 16)(
    input   wire    REF_CLK,
    input   wire    UART_CLK,
    input   wire    RST,
    input   wire    RX_IN,
    output  wire    TX_OUT,
    output  wire    PAR_ERR,
    output  wire    FRAME_ERR
);

wire    [DATA_WIDTH - 1 : 0]    RX_P_Data_async, RX_P_Data_sync;
wire    [DATA_WIDTH - 1 : 0]    TX_P_Data_async, TX_P_Data_sync;
wire                            RX_Data_Valid_async, RX_Data_Valid_sync;
wire                            TX_Data_Valid_async, TX_Data_Valid_sync;
wire                            FIFO_Empty;
wire                            clk_div_en;
wire                            TX_CLK, RX_CLK, SYNC_RST_2;
wire    [2 : 0]                 div_ratio;
//wire                            TX_OUT_Busy, TX_Busy;
wire                            TX_OUT_started, FIFO_Full;
wire    [DATA_WIDTH - 1 : 0]    REG0, REG1, REG2, REG3;
wire                            WrEN, RdEN, RdData_Valid, SYNC_RST_1;
wire    [3 : 0]                 Address;
wire    [DATA_WIDTH - 1 : 0]    WrData, RdData;
wire    [3 : 0]                 ALU_FUN;
wire    [DATA_WIDTH*2 - 1 : 0]  ALU_OUT;
wire                            ALU_EN, ALU_OUT_VALID, ALU_CLK_EN, ALU_CLK;

UART #(.PRESCALE(PRESCALE), .DATA_WIDTH(DATA_WIDTH)) U0_UART (
    .RST(SYNC_RST_2),
    .TX_CLK(TX_CLK),
    .TX_P_Data(TX_P_Data_sync),
    .TX_Data_Valid(TX_Data_Valid_sync),
    .TX_OUT(TX_OUT),
    .TX_OUT_Busy(),
    .TX_OUT_started(TX_OUT_started),
    .RX_CLK(RX_CLK),
    .RX_IN(RX_IN),
    .RX_P_Data(RX_P_Data_async),
    .RX_Data_Valid(RX_Data_Valid_async),
    .Prescale(REG2[7:2]),                            
    .PAR_TYP(REG2[1]),
    .PAR_EN(REG2[0]),
    .framing_error(FRAME_ERR),
    .parity_error(PAR_ERR)
);

inverter U0_inverter (
    .in_signal(FIFO_Empty),
    .inverted_signal(TX_Data_Valid_sync)
);

DATA_SYNC #(.BUS_WIDTH(DATA_WIDTH)) U0_DATA_SYNC (
    .async_bus(RX_P_Data_async),
    .async_bus_en(RX_Data_Valid_async),
    .CLK(REF_CLK),
    .RST(SYNC_RST_1),
    .en_pulse(RX_Data_Valid_sync),
    .sync_bus(RX_P_Data_sync)
);

SYS_CTRL #(.DATA_WIDTH(DATA_WIDTH)) U0_SYS_CTRL (
    .ALU_OUT(ALU_OUT),
    .ALU_OUT_Valid(ALU_OUT_VALID),
    .RX_P_Data(RX_P_Data_sync),
    .RX_Data_Valid(RX_Data_Valid_sync),
    .RdData(RdData),
    .RdData_Valid(RdData_Valid),
    .TX_Busy(FIFO_Full),
    .CLK(REF_CLK),
    .RST(SYNC_RST_1),
    .ALU_EN(ALU_EN),
    .ALU_FUN(ALU_FUN),
    .ALU_CLK_EN(ALU_CLK_EN),
    .Address(Address),
    .WrEN(WrEN),
    .RdEN(RdEN),
    .WrData(WrData),
    .TX_P_Data(TX_P_Data_async),
    .TX_Data_Valid(TX_Data_Valid_async),
    .clk_div_en(clk_div_en)
);

ALU #(.OPER_WIDTH(DATA_WIDTH)) U0_ALU (
    .A(REG0), 
    .B(REG1),
    .EN(ALU_EN),
    .ALU_FUN(ALU_FUN),
    .CLK(ALU_CLK),
    .RST(SYNC_RST_1),  
    .ALU_OUT(ALU_OUT),
    .OUT_VALID(ALU_OUT_VALID)  
);

RegFile #(.WIDTH(DATA_WIDTH), .DEPTH(REG_DEPTH)) U0_RegFile (
    .CLK(REF_CLK),
    .RST(SYNC_RST_1),
    .WrEn(WrEN),
    .RdEn(RdEN),
    .Address(Address),
    .WrData(WrData),
    .RdData(RdData),
    .RdData_VLD(RdData_Valid),
    .REG0(REG0),
    .REG1(REG1),
    .REG2(REG2),
    .REG3(REG3)
);

ASYNC_FIFO #(.DATA_WIDTH(DATA_WIDTH), .MEM_DEPTH(FIFO_DEPTH)) U0_ASYNC_FIFO (
    .wr_data(TX_P_Data_async),
    .wr_clk(REF_CLK),
    .wr_rst(SYNC_RST_1),
    .wr_inc(TX_Data_Valid_async),
    .rd_clk(TX_CLK),
    .rd_rst(SYNC_RST_2),
    .rd_inc(TX_OUT_started),
    .rd_data(TX_P_Data_sync),
    .full(FIFO_Full),
    .empty(FIFO_Empty)
);

CLK_GATE CLK_GATE (
    .CLK(REF_CLK),
    .CLK_EN(ALU_CLK_EN),
    .GATED_CLK(ALU_CLK)
);

RST_SYNC #(.STAGES_NUM(2)) U0_RST_SYNC_1 (
    .RST(RST),
    .CLK(REF_CLK),
    .SYNC_RST(SYNC_RST_1)
);

RST_SYNC #(.STAGES_NUM(2)) U1_RST_SYNC_2 (
    .RST(RST),
    .CLK(UART_CLK),
    .SYNC_RST(SYNC_RST_2)
);

/*
Pulse_GEN U0_Pulse_GEN (
    .in(TX_OUT_Busy),
    .CLK(TX_CLK),
    .RST(SYNC_RST_2),
    .out_pulse(TX_Busy)
);
*/

ClkDiv #(.DIVIDED_RATIO_WIDTH(8)) U0_ClkDiv (
    .i_ref_clk(UART_CLK),
    .i_rst_n(SYNC_RST_2),
    .i_clk_en(1'b1),
    .i_div_ratio(REG3),
    .o_div_clk(TX_CLK)
);

ClkDiv #(.DIVIDED_RATIO_WIDTH(3)) U1_ClkDiv (
    .i_ref_clk(UART_CLK),
    .i_rst_n(SYNC_RST_2),
    .i_clk_en(1'b1),
    .i_div_ratio(div_ratio),
    .o_div_clk(RX_CLK)
);

CLKDIV_MUX #(.PRESCALE(PRESCALE), .DIVIDED_RATIO_WIDTH(3)) U0_CLKDIV_MUX (
    .prescale(REG2[7:2]),
    .div_ratio(div_ratio)
);
endmodule