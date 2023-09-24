`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 09/09/2023 10:41:53 PM
// Design Name: DigIC_Dip08_09_CDC
// Module Name: Data_SYNC
// Project Name: Data Synchronizer
//////////////////////////////////////////////////////////////////////////////////

module Data_SYNC #(parameter STAGES_NUM = 2, BUS_WIDTH = 8) (
    input   wire    [BUS_WIDTH - 1 : 0]     async_bus,
    input   wire                            async_bus_en,
    input   wire                            CLK,
    input   wire                            RST,
    output  wire                            en_pulse,
    output  wire    [BUS_WIDTH - 1 : 0]     sync_bus
    );

reg     [STAGES_NUM - 1 : 0]    bit_sync_reg, bit_sync_next; 
reg                             out_pulse_reg,  out_pulse_next;   
reg     [BUS_WIDTH - 1 : 0]     sync_bus_reg, sync_bus_next;
reg                             en_pulse_reg, en_pulse_next;
wire                            sync_bus_en;
wire                            sync_bus_en_pulse;

// bit synchronizer
always @(posedge CLK, negedge RST)
    begin
        if (!RST)
            begin
                bit_sync_reg <= 0;
            end
        else
            begin
                bit_sync_reg <= bit_sync_next;
            end
    end

always @(*)
    begin
        bit_sync_next = {bit_sync_reg[STAGES_NUM - 2 : 0], async_bus_en};
    end

assign sync_bus_en = bit_sync_reg[STAGES_NUM - 1];


// Pulse Generator
always @(posedge CLK, negedge RST)
    begin
        if (!RST)
            begin
                out_pulse_reg <= 0;
            end
        else
            begin
                out_pulse_reg <= out_pulse_next;
            end
    end

always @(*)
    begin
        out_pulse_next = sync_bus_en;
    end

assign sync_bus_en_pulse = sync_bus_en && (~out_pulse_reg);


// register sync_bus output
always @(posedge CLK, negedge RST)
    begin
        if (!RST)
            begin
                sync_bus_reg <= 0;
            end
        else
            begin
                sync_bus_reg <= sync_bus_next;
            end
    end

always @(*)
    begin
        sync_bus_next = sync_bus_en_pulse? async_bus : sync_bus_reg;
    end

assign sync_bus = sync_bus_reg;
 

// register en_pulse output   
always @(posedge CLK, negedge RST)
    begin
        if (!RST)
            begin
                en_pulse_reg <= 0;
            end
        else
            begin
                en_pulse_reg <= en_pulse_next;
            end
    end

always @(*)
    begin
        en_pulse_next = sync_bus_en_pulse;
    end

assign en_pulse = en_pulse_reg;
endmodule
