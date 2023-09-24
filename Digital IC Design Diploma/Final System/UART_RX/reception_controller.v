`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 08/30/2023 04:48:24 PM
// Design Name: DigIC_Dip08_09_UART_RX
// Module Name: reception_controller
// Project Name: UART_RX
//////////////////////////////////////////////////////////////////////////////////


module reception_controller #(parameter PRESCALE = 8, DATA_WIDTH = 8)(
    input   wire                                CLK,
    input   wire                                RST,
    input   wire                                RX_IN,
    input   wire                                PAR_EN,
    input   wire    [$clog2(DATA_WIDTH) : 0]    bit_cnt, 
    input   wire    [$clog2(PRESCALE) : 0]      edge_cnt,
    input   wire    [$clog2(PRESCALE) : 0]      prescale,
    input   wire                                strt_glitch,
    input   wire                                stp_error,
    input   wire                                par_error,
    output  reg                                 cnt_en,
    output  reg                                 data_samp_en,
    output  reg                                 strt_chk_en,
    output  reg                                 stp_chk_en,
    output  reg                                 par_chk_en,
    output  reg                                 deser_en,
    output  wire                                Data_Valid
    );

localparam  idle    = 0,
            start   = 1,
            data    = 2,
            parity  = 3,
            stop    = 4;

           
reg     [2 : 0]                 state_reg, state_next;
reg                             Data_Valid_reg, Data_Valid_next;
wire    [$clog2(PRESCALE) : 0]  middle_sample;

always @(posedge CLK, negedge RST)
    begin
        if (~RST)
            begin
                Data_Valid_reg <= 0;
            end
        else
            begin
                Data_Valid_reg <= Data_Valid_next;
            end
    end

always @(posedge CLK, negedge RST)
    begin
        if (~RST)
            begin
                state_reg <= idle;
            end
        else
            begin
                state_reg <= state_next;
            end
    end
    
always @(*)
    begin
        state_next = state_reg;
        cnt_en = 0;
        data_samp_en = 0;
        strt_chk_en = 0;
        stp_chk_en = 0;
        par_chk_en = 0;
        deser_en = 0;
        Data_Valid_next = 0;
        case (state_reg)
            idle:
                begin
                    if (!RX_IN)
                        begin
                            cnt_en = 1;
                            data_samp_en = 1;
                            state_next = start; 
                        end
                    else
                        begin
                            state_next = idle;
                        end
                end
            start:
                begin
                    cnt_en = 1;
                    data_samp_en = 1;
                    if (edge_cnt == middle_sample + 1)
                        strt_chk_en = 1;
                    else
                        strt_chk_en = 0;
                    if (bit_cnt == 1)
                        begin
                            state_next = data;
                        end
                    else
                        begin
                             if (strt_glitch)
                                   begin
                                       state_next = idle;
                                       cnt_en = 0;
                                       data_samp_en = 0;
                                   end
                               else
                                   begin
                                       state_next = start;                                 
                                   end
                        end
                end
            data:
                begin
                    cnt_en = 1;
                    data_samp_en = 1; 
                    if (bit_cnt == 9)
                        begin
                            if (PAR_EN)
                                begin
                                    state_next = parity;
                                end
                            else
                                begin
                                    state_next = stop;
                                end
                        end
                    else
                        begin
                            if (edge_cnt == middle_sample + 1)
                                deser_en = 1;
                            else
                                deser_en = 0;
                            state_next = data;
                        end
                end
            parity:
                begin
                    cnt_en = 1;
                    data_samp_en = 1;
                    if (edge_cnt == middle_sample + 1)
                        par_chk_en = 1;
                    else
                        par_chk_en = 0;
                    if (bit_cnt == 10)
                        begin
                            state_next = stop;
                        end
                    else
                        begin
                            state_next = parity;
                        end
                end
            stop:
                begin
                    cnt_en = 1;
                    data_samp_en = 1;
                    if (edge_cnt == middle_sample + 1)
                        stp_chk_en = 1;
                    else
                        stp_chk_en = 0;
                    if (edge_cnt == (prescale - 1))
                        begin
                            cnt_en = 0;
                            data_samp_en = 0; 
                            if (stp_error || par_error)
                                begin
                                    Data_Valid_next = 0;
                                    state_next = idle;
                                end
                            else if (!RX_IN)
                                begin 
                                    state_next = start;
                                    Data_Valid_next = 1;
                                end
                            else
                                begin
                                    state_next = idle;
                                    Data_Valid_next = 1;
                                end
                        end
                    else
                        begin
                            state_next = stop;
                        end
                end
            default:
                begin
                    state_next = idle;
                    cnt_en = 0;
                    data_samp_en = 0;
                    strt_chk_en = 0;
                    stp_chk_en = 0;
                    par_chk_en = 0;
                    deser_en = 0;
                    Data_Valid_next = 0;
                end
        endcase
    end

assign middle_sample = (prescale >> 1); 
assign Data_Valid = Data_Valid_reg;
endmodule
