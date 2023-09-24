`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 08/17/2023 12:26:07 AM
// Design Name: DigIC_Dip08_09_UART_TX
// Module Name: UART_TX
// Project Name: UART_TX
//////////////////////////////////////////////////////////////////////////////////


module UART_TX #(parameter DATA_WIDTH = 8)(
        input                       CLK, RST,
        input                       PAR_TYP, PAR_EN,
        input [DATA_WIDTH - 1 : 0]  P_Data,
        input                       Data_Valid,
        output                      TX_Out,
        output                      Busy  
    );
    
    wire ser_en, ser_done, ser_data;
    serializer #(.DATA_WIDTH(DATA_WIDTH)) u0_serializer (
        .CLK(CLK),
        .RST(RST),
        .P_Data(P_Data),
        .S_EN(ser_en),
        .S_Done(ser_done),
        .S_Data(ser_data)
    );
    
    wire [2 : 0] mux_sel;
    transmission_controller u0_transmission_controller (
        .CLK(CLK),
        .RST(RST),
        .Data_Valid(Data_Valid),
        .PAR_EN(PAR_EN),
        .S_Done(ser_done),
        .S_EN(ser_en),
        .Frame_Bit_SEL(mux_sel),
        .Busy(Busy)
    );
    
    wire par_bit;
    parity_generator #(.DATA_WIDTH(DATA_WIDTH)) u0_parity_generator (
        .CLK(CLK),
        .RST(RST),
        .EN(Data_Valid),
        .P_Data(P_Data),
        .PAR_TYP(PAR_TYP),
        .PAR_Bit(par_bit)
    );
    
    localparam  idle_bit  = 1'b1,
                start_bit = 1'b0,
                stop_bit  = 1'b1;
    mux u0_mux (
        .CLK(CLK),
        .RST(RST),
        .SEL(mux_sel),
        .IN0(idle_bit),
        .IN1(start_bit),
        .IN2(ser_data),
        .IN3(par_bit),
        .IN4(stop_bit),
        .OUT(TX_Out)
    );
endmodule
