`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2019 09:56:39 AM
// Design Name: 
// Module Name: jump
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module jump 
/*** PARAMETERS ***/
#(parameter
    DATA_WL     = 32,
    ADDR_RF_WL  = 5,
    ADDR_MEM    = 32,
    IMMED_WL    = 16,
    JUMP_WL     = 26
)
/*** IN/OUT ***/
(
    // IN
    input                           rst,
    input [JUMP_WL - 1 : 0]         JUMP,
    input [ADDR_MEM - 1 : 0]        PC,
    // OUT
    output reg [ADDR_MEM - 1 : 0]   jaddr
);

    always @(*)
    begin
        if(rst) jaddr = 1'bx;
        else jaddr = {PC[31:26],JUMP};
    end
endmodule
