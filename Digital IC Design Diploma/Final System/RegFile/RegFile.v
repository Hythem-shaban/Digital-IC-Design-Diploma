`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hythem Ahmed Shaban
// Diploma: By Eng. Ali Mohamed Eltemsah
// Create Date: 07/27/2023 07:24:59 PM
// Design Name: DigIC_Dip08_09_RegFile
// Module Name: RegFile
// Project Name: Register File
//////////////////////////////////////////////////////////////////////////////////


module RegFile #(parameter WIDTH = 8, DEPTH = 16, ADDR = $clog2(DEPTH))
(
    input    wire                       CLK,
    input    wire                       RST,
    input    wire                       WrEn,
    input    wire                       RdEn,
    input    wire   [ADDR  - 1 : 0]     Address,
    input    wire   [WIDTH - 1 : 0]     WrData,
    output   reg    [WIDTH - 1 : 0]     RdData,
    output   reg                        RdData_VLD,
    output   wire   [WIDTH - 1 : 0]     REG0,
    output   wire   [WIDTH - 1 : 0]     REG1,
    output   wire   [WIDTH - 1 : 0]     REG2,
    output   wire   [WIDTH - 1 : 0]     REG3
);

integer i ; 
  
// register file of 8 registers each of 16 bits width
reg [WIDTH-1:0] regArr [DEPTH-1:0] ;    

always @(posedge CLK or negedge RST)
    begin
        if(!RST)  // Asynchronous active low reset 
            begin
                RdData_VLD <= 1'b0 ;
                RdData     <= 1'b0 ;
                for (i = 0; i < DEPTH; i = i + 1)
                    begin
                        if(i==2)
                            regArr[i] <= 'b100000_01 ;
                        else if (i==3) 
                            regArr[i] <= 'b0010_0000 ;
                        else
                            regArr[i] <= 'b0 ;		 
                    end
            end
        else if (WrEn && !RdEn) // Register Write Operation
            begin
                regArr[Address] <= WrData ;
            end
        else if (RdEn && !WrEn) // Register Read Operation
            begin    
                RdData <= regArr[Address] ;
                RdData_VLD <= 1'b1 ;
            end  
        else
            begin
                RdData_VLD <= 1'b0 ;
            end	 
    end

assign REG0 = regArr[0] ;
assign REG1 = regArr[1] ;
assign REG2 = regArr[2] ;
assign REG3 = regArr[3] ;


endmodule
