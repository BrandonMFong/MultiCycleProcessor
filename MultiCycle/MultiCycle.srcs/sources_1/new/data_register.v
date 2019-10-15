`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2019 09:56:39 AM
// Design Name: 
// Module Name: data_register
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


module data_register 
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
    input                           clk,
                                    rst,
                                    DR_EN,
    input [DATA_WL - 1 : 0]         din,
    
    // OUT
    output reg [DATA_WL - 1 : 0]    dout
);

    always @(posedge clk)
    begin
        if (rst) dout <= 1'bx;
        else dout <= din;
    end
    
endmodule
