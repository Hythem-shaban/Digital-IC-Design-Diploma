`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 09/15/2023 07:16:58 PM
// Design Name: DigIC_Dip08_09_Final_System
// Module Name: SYS_TOP_tb
// Project Name: Final System
//////////////////////////////////////////////////////////////////////////////////

module SYS_TOP_tb();

///////////////////// Parameters ////////////////////////
parameter PRESCALE          = 32;
parameter DATA_WIDTH        = 8;
parameter REG_DEPTH         = 16; 
parameter FIFO_DEPTH        = 16;
parameter REF_CLK_PERIOD    = 10;
parameter UART_CLK_PERIOD   = 1/0.0036864;

//////////////////// DUT Signals ////////////////////////

reg     REF_CLK_tb;
reg     UART_CLK_tb;
reg     RST_tb;
reg     RX_IN_tb;
wire    TX_OUT_tb;
wire    PAR_ERR_tb;
wire    FRAME_ERR_tb;

////////////////// initial block ///////////////////////

initial 
    begin
        // System Functions
        $dumpfile("SYS_TOP_DUMP.vcd");       
        $dumpvars; 
        
        // initialization
        initialize();
        
        // reset
        reset();
        
        // Test Cases
        
        // set configuration (PAR_EN = 0, PAR_TYP = 0, Prescale = 32, TX_div_ratio = 32)
        set_config(0, 0, 32, 32);
        
        // check configuration
        chk_config({6'd32, 1'b0, 1'b0}, {8'd32});
        
        // read command
        RF_Rd_CMD(8'h03);
        
        // check transmitted data
        chk_tx_out(DUT.U0_RegFile.REG3);
        
        // ALU Operation add A + B
        ALU_CMD_OP(8'hFF, 8'hFF, 8'h00);
        
        // check transmitted data
        chk_tx_out(8'hFE);
        chk_tx_out(8'h01);
                
        // ALU Operation subtract A - B
        ALU_CMD_OP(8'h02, 8'h02, 8'h01);
        
        // check transmitted data
        chk_tx_out(8'h00);
        chk_tx_out(8'h00);
        
        // ALU Operation multiplication A * B
        ALU_CMD_NOP(8'h02);
        
        // check transmitted data
        chk_tx_out(8'h04);
        chk_tx_out(8'h00);
        
        // ALU Operation AND A / B
        ALU_CMD_OP(8'h02, 8'h02, 8'h03);
        
        // check transmitted data
        chk_tx_out(8'h01);
        chk_tx_out(8'h00);
        
        // ALU Operation AND A & B
        ALU_CMD_NOP(8'h04);
        
        // check transmitted data
        chk_tx_out(8'h02);
        chk_tx_out(8'h00);
        
        // ALU Operation OR A | B
        ALU_CMD_OP(8'h04, 8'h02, 8'h05);
        
        // check transmitted data
        chk_tx_out(8'h06);
        chk_tx_out(8'h00);
        
        // reset
        reset();
        
        // set configuration (PAR_EN = 1, PAR_TYP = 0, Prescale = 16, TX_div_ratio = 32)
        set_config(1, 0, 16, 32); 
        
        // check configuration
        chk_config({6'd16, 1'b0, 1'b1}, {8'd32});
        
        // read command
        RF_Rd_CMD(8'h02);
        
        // check transmitted data
        chk_tx_out(DUT.U0_RegFile.REG2);
        
        // write command
        RF_Wr_CMD(8'h05, 8'hAA);
        
        // read command
        RF_Rd_CMD(8'h05);
        
        // check transmitted data
        chk_tx_out(DUT.U0_RegFile.regArr[5]);
        
        // reset
        reset();
                
        // set configuration (PAR_EN = 1, PAR_TYP = 1, Prescale = 8, TX_div_ratio = 32)
        set_config(1, 1, 8, 32);
        
        // check configuration
        chk_config({6'd8, 1'b1, 1'b1}, {8'd32});
        
        // read command
        RF_Rd_CMD(8'h02);
        
        // check transmitted data
        chk_tx_out(DUT.U0_RegFile.REG2);
         
        $stop;
    end
/////////////////////// TASKS //////////////////////////
    
/////////////// Signals Initialization //////////////////

task initialize;
    begin
        REF_CLK_tb      = 1'b0;
        UART_CLK_tb     = 1'b0;
        RST_tb          = 1'b0;
        RX_IN_tb        = 1'b1;
    end
endtask

///////////////////////// RESET /////////////////////////

task reset;
    begin
        RST_tb  = 'b1;
        #(REF_CLK_PERIOD)
        RST_tb  = 'b0;
        #(REF_CLK_PERIOD)
        RST_tb  = 'b1;
    end
endtask

/////////////////// Parity Calculation //////////////////

task calc_parity_bit;
    input [DATA_WIDTH - 1 : 0] type;
    output parity_bit;
    begin
        if (DUT.U0_RegFile.REG2[1])
            begin
                parity_bit = ~(^type);
            end
        else
            begin
                parity_bit = (^type);
            end
    end
endtask

///////////////////// CMD operation /////////////////////

task CMD_type;
    input   [DATA_WIDTH - 1 : 0] type;
    integer i;
    begin
        RX_IN_tb = 1'b0;
        #(UART_CLK_PERIOD*(DUT.U0_RegFile.REG3));
        for(i = 0; i < DATA_WIDTH; i = i + 1)
            begin
                RX_IN_tb = type[i];
                #(UART_CLK_PERIOD*(DUT.U0_RegFile.REG3));
            end
        if (DUT.U0_RegFile.REG2[0])
            begin
                calc_parity_bit(type, RX_IN_tb);
                #(UART_CLK_PERIOD*(DUT.U0_RegFile.REG3));
            end
        RX_IN_tb = 1'b1;
        #(UART_CLK_PERIOD*(DUT.U0_RegFile.REG3));
    end
endtask

//////////////////// RF_Wr_CMD (0xAA) ///////////////////

task RF_Wr_CMD;
    input   [DATA_WIDTH - 1 : 0] RF_Wr_Addr;
    input   [DATA_WIDTH - 1 : 0] RF_Wr_Data;
    integer i;
    localparam [DATA_WIDTH - 1 : 0] RF_WR_CMD = 8'hAA;
    begin
        CMD_type(RF_WR_CMD);
        CMD_type(RF_Wr_Addr);
        CMD_type(RF_Wr_Data);
    end
endtask

///////////////// System Congiguations //////////////////

task set_config;
    input   parity_enable;
    input   parity_type;
    input   [$clog2(PRESCALE) : 0] prescale;
    input   [$clog2(PRESCALE) : 0] div_ratio;
    integer i;
    begin
        RF_Wr_CMD(8'h02, {prescale, parity_type, parity_enable});
        RF_Wr_CMD(8'h03, div_ratio);
    end
endtask

////////////////// Check Configurations /////////////////

task chk_config;
    input   [DATA_WIDTH - 1 : 0]    RF_reg2;
    input   [DATA_WIDTH - 1 : 0]    RF_reg3;
    begin
        if (DUT.U0_RegFile.REG2 == RF_reg2 && DUT.U0_RegFile.REG3 == RF_reg3)
            $display("Configuartions are set correctly, REG2 = %h, REG3 = %h", DUT.U0_RegFile.REG2, DUT.U0_RegFile.REG3);
        else
            $display("Configuartions are not set correctly, REG2 = %h, REG3 = %h", DUT.U0_RegFile.REG2, DUT.U0_RegFile.REG3);
    end
endtask

//////////////////// RF_Rd_CMD (0xBB) ///////////////////

task RF_Rd_CMD;
    input   [DATA_WIDTH - 1 : 0] RF_Rd_Addr;
    integer i;
    localparam [DATA_WIDTH - 1 : 0] RF_RD_CMD = 8'hBB;
    begin
        CMD_type(RF_RD_CMD);
        CMD_type(RF_Rd_Addr);
    end
endtask

//////////////////// Check TX output ////////////////////

task chk_tx_out;
    input   [DATA_WIDTH - 1 : 0] expec_tx_out;
    integer k;
    reg     [(DATA_WIDTH + 3) - 1 : 0] gener_tx_out;
    begin
        @(negedge TX_OUT_tb);
        for (k = 0; k < (DATA_WIDTH + 2 + DUT.U0_RegFile.REG2[0]); k = k + 1)
            begin
                #(UART_CLK_PERIOD*(DUT.U0_RegFile.REG3));
                gener_tx_out[k] = TX_OUT_tb;
            end
        if (gener_tx_out[8:1] == expec_tx_out)
            $display("TX output is correct, expec_tx_out = %h, gener_tx_out = %h, %t", expec_tx_out, gener_tx_out[8:1], $time);
        else
            $display("TX output is not correct, expec_tx_out = %h, gener_tx_out = %h, %t", expec_tx_out, gener_tx_out[8:1], $time);
    end
endtask

/////////// ALU_Operation with Operand (0xCC) ///////////

task ALU_CMD_OP;
    input   [DATA_WIDTH - 1 : 0] OP_A;
    input   [DATA_WIDTH - 1 : 0] OP_B;
    input   [DATA_WIDTH - 1 : 0] ALU_FUN;
    integer i;
    localparam [DATA_WIDTH - 1 : 0] ALU_OPER_W_OP_CMD = 8'hCC;
    begin
        CMD_type(ALU_OPER_W_OP_CMD);
        CMD_type(OP_A);
        CMD_type(OP_B);
        CMD_type(ALU_FUN);
    end
endtask

////////// ALU_Operation with no Operand (0xDD) /////////

task ALU_CMD_NOP;
    input   [DATA_WIDTH - 1 : 0] ALU_FUN;
    integer i;
    localparam [DATA_WIDTH - 1 : 0] ALU_OPER_W_NOP_CMD = 8'hDD;
    begin
        CMD_type(ALU_OPER_W_NOP_CMD);
        CMD_type(ALU_FUN);
    end
endtask

////////////////// Clock Generator  ////////////////////

always #(REF_CLK_PERIOD/2.0)    REF_CLK_tb  = ~REF_CLK_tb;
always #(UART_CLK_PERIOD/2.0)   UART_CLK_tb = ~UART_CLK_tb;

/////////////////// DUT Instantation ///////////////////

SYS_TOP #(.PRESCALE(PRESCALE), .DATA_WIDTH(DATA_WIDTH), .REG_DEPTH(REG_DEPTH), .FIFO_DEPTH(FIFO_DEPTH)) DUT (
    .REF_CLK(REF_CLK_tb),
    .UART_CLK(UART_CLK_tb),
    .RST(RST_tb),
    .RX_IN(RX_IN_tb),
    .TX_OUT(TX_OUT_tb),
    .PAR_ERR(PAR_ERR_tb),
    .FRAME_ERR(FRAME_ERR_tb)
);
endmodule

