`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 09/15/2023 03:08:24 AM
// Design Name: DigIC_Dip08_09_Final_System
// Module Name: SYS_CTRL
// Project Name: Final System
//////////////////////////////////////////////////////////////////////////////////

module SYS_CTRL #(parameter DATA_WIDTH = 8, OUT_WIDTH = DATA_WIDTH*2)(
    input   wire    [OUT_WIDTH  - 1  : 0]   ALU_OUT,
    input   wire                            ALU_OUT_Valid,
    input   wire    [DATA_WIDTH - 1  : 0]   RX_P_Data,
    input   wire                            RX_Data_Valid,
    input   wire    [DATA_WIDTH - 1  : 0]   RdData,
    input   wire                            RdData_Valid,
    input   wire                            TX_Busy,
    input   wire                            CLK,
    input   wire                            RST,
    output  reg                             ALU_EN,
    output  reg     [3  : 0]                ALU_FUN,
    output  reg                             ALU_CLK_EN,
    output  reg     [3  : 0]                Address,
    output  reg                             WrEN,
    output  reg                             RdEN,
    output  reg     [DATA_WIDTH - 1  : 0]   WrData,
    output  reg     [DATA_WIDTH - 1  : 0]   TX_P_Data,
    output  reg                             TX_Data_Valid,
    output  reg                             clk_div_en
    );

reg     [3 : 0] state_reg, state_next;
reg     [3 : 0] ADDR_reg;
reg             clk_div_en_reg;

localparam  IDLE                = 4'b0000,
            RF_WR_ADDR          = 4'b0001,
            RF_WR_DATA          = 4'b0011,
            RF_RD_ADDR          = 4'b0010,
            RF_FIFO_WR          = 4'b0110,
            ALU_A               = 4'b0100,
            ALU_B               = 4'b0101,
            ALU_FUNC            = 4'b0111,
            ALU_FIFO_WR1        = 4'b1111,
            ALU_FIFO_WR2        = 4'b1011;
    
always @(posedge CLK, negedge RST)
    begin
        if (!RST)
            begin
                clk_div_en_reg <= 0;
            end
        else
            begin
                clk_div_en_reg <= clk_div_en;
            end
    end

always @(posedge CLK, negedge RST)
    begin
        if (!RST)
            begin
                ADDR_reg <= 0;
            end
        else
            begin
                ADDR_reg <= Address;
            end
    end
    
// state reg
always @(posedge CLK, negedge RST)
    begin
        if (!RST)
            begin
                state_reg <= 0;
            end
        else
            begin
                state_reg <= state_next;
            end
    end 

// next state logic       
 always @(*)
    begin
        state_next = state_reg;
        ALU_EN = 'b0;
        ALU_FUN = 'b0;
        ALU_CLK_EN = 'b0;
        Address = ADDR_reg;
        WrEN = 'b0;
        RdEN = 'b0;
        WrData = 'b0;
        TX_P_Data = 'hFF;
        TX_Data_Valid = 'b0;
        clk_div_en = clk_div_en_reg;
        case (state_reg)
        IDLE:
            begin
                if (RX_Data_Valid)
                    begin
                        case (RX_P_Data)
                            8'hAA:      state_next = RF_WR_ADDR;
                            8'hBB:      state_next = RF_RD_ADDR;
                            8'hCC:      state_next = ALU_A;
                            8'hDD:      state_next = ALU_FUNC;
                            default:    state_next = IDLE;
                        endcase
                    end
                else
                    begin
                        state_next = IDLE;
                    end
            end
        RF_WR_ADDR:
            begin
                if (RX_Data_Valid)
                    begin
                        state_next = RF_WR_DATA;
                        Address = RX_P_Data;
                    end
                else
                    begin
                        state_next = RF_WR_ADDR;
                    end
            end
        RF_WR_DATA:
            begin
                if (RX_Data_Valid)
                    begin
                        state_next = IDLE;
                        WrEN = 'b1;
                        WrData = RX_P_Data;
                    end
                else
                    begin
                        state_next = RF_WR_DATA;
                    end
            end
        RF_RD_ADDR:
            begin
                if (RX_Data_Valid)
                    begin
                        RdEN = 'b1;
                        Address = RX_P_Data;
                        WrData = RX_P_Data;
                        state_next = RF_FIFO_WR;
                    end
                else
                    begin
                        state_next = RF_RD_ADDR;
                    end 
            end
        RF_FIFO_WR:
            begin
                if (RdData_Valid && !TX_Busy)
                    begin
                        clk_div_en = 1'b1;
                        TX_P_Data = RdData;
                        TX_Data_Valid = 'b1;
                        state_next = IDLE;
                    end
                else
                    begin
                        TX_P_Data = 'hFF;
                        TX_Data_Valid = 'b0;
                        state_next = RF_FIFO_WR;
                    end
            end
        ALU_FIFO_WR1:
            begin
                if (ALU_OUT_Valid && !TX_Busy)
                    begin
                        clk_div_en = 1'b1;
                        ALU_CLK_EN = 'b1;
                        ALU_EN = 'b1;
                        TX_P_Data = ALU_OUT[7 : 0];
                        TX_Data_Valid = 'b1;
                        state_next = ALU_FIFO_WR2;
                    end
                else
                    begin
                        TX_P_Data = 'hFF;
                        TX_Data_Valid = 'b0;
                        state_next = ALU_FIFO_WR1;
                    end
            end
        ALU_FIFO_WR2:
            begin
                clk_div_en = 1'b1;
                ALU_CLK_EN = 'b1;
                TX_P_Data = ALU_OUT[15 : 8];
                TX_Data_Valid = 'b1;
                state_next = IDLE;
            end
        ALU_A:
            begin
                if (RX_Data_Valid)
                    begin
                        WrEN = 'b1;
                        Address = 4'h00;
                        WrData = RX_P_Data;
                        state_next = ALU_B;
                    end
                else
                    begin
                        state_next = ALU_A;
                    end
            end
        ALU_B:
            begin
                if (RX_Data_Valid)
                    begin
                        WrEN = 'b1;
                        Address = 4'h01;
                        WrData = RX_P_Data;
                        state_next = ALU_FUNC;
                    end
                else
                    begin
                        state_next = ALU_B;
                    end
            end
        ALU_FUNC:
            begin
                if (RX_Data_Valid)
                    begin
                        ALU_FUN = RX_P_Data;
                        ALU_EN = 'b1;
                        ALU_CLK_EN = 'b1;
                        state_next = ALU_FIFO_WR1;
                    end
                else
                    begin
                        state_next = ALU_FUNC;
                    end
            end
        default:
            begin
                state_next = IDLE;
                ALU_EN = 'b0;
                ALU_FUN = 'b0;
                ALU_CLK_EN = 'b0;
                Address = 'b0;
                WrEN = 'b0;
                RdEN = 'b0;
                WrData = 'b0;
                TX_P_Data = 'hFF;
                TX_Data_Valid = 'b0;
            end
        endcase
    end
    
endmodule
