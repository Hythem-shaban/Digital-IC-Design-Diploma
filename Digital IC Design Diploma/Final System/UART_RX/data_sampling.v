`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 08/30/2023 04:49:15 PM
// Design Name: DigIC_Dip08_09_UART_RX
// Module Name: data_sampling
// Project Name: UART_RX
//////////////////////////////////////////////////////////////////////////////////


module data_sampling #(parameter PRESCALE = 8)(
    input   wire                                    CLK,
    input   wire                                    RST,
    input   wire                                    data_samp_en,
    input   wire                                    RX_IN,
    input   wire    [$clog2(PRESCALE) : 0]          prescale,
    input   wire    [$clog2(PRESCALE) : 0]          edge_cnt,
    output  wire                                    sampled_bit
    );
  
reg sample_1_reg, sample_1_next;
reg sample_2_reg, sample_2_next;
reg sample_3_reg, sample_3_next;
wire [$clog2(PRESCALE) : 0] middle_sample;

always @(posedge CLK, negedge RST)
    begin
        if (!RST)
            begin
                sample_1_reg <= 1'b1;
                sample_2_reg <= 1'b1;
                sample_3_reg <= 1'b1;
            end
        else
            begin
                sample_1_reg <= sample_1_next;
                sample_2_reg <= sample_1_next;
                sample_3_reg <= sample_1_next;
            end
    end 
   
always @(*)
    begin
        if (data_samp_en)
            begin
                sample_1_next = sample_1_reg;
                sample_2_next = sample_2_reg;
                sample_3_next = sample_3_reg;
                case (edge_cnt)
                    (middle_sample - 1):
                        begin
                            sample_1_next = RX_IN;
                        end
                    middle_sample:
                        begin
                            sample_2_next = RX_IN;
                        end
                    (middle_sample + 1):
                        begin
                            sample_3_next = RX_IN;
                        end
                    default:
                        begin
                            sample_1_next = sample_1_reg;
                            sample_2_next = sample_2_reg;
                            sample_3_next = sample_3_reg;
                        end
                endcase
            end
        else
            begin
                sample_1_next = sample_1_reg;
                sample_2_next = sample_2_reg;
                sample_3_next = sample_3_reg;
            end
    end

assign middle_sample = (prescale >> 1);
assign sampled_bit = (sample_1_reg && sample_2_reg) || (sample_2_reg && sample_3_reg) || (sample_1_reg && sample_3_reg);
endmodule
