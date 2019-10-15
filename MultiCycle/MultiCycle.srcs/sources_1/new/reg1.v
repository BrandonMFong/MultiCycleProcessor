`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2019 09:56:39 AM
// Design Name: 
// Module Name: reg1
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


module reg1 
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
    input [DATA_WL - 1 : 0]         din1,
                                    din2,
    // OUT
    output reg [DATA_WL - 1 : 0]    dout1,
                                    dout2
);

    always @(posedge clk)
    begin
        if(rst) 
        begin
            dout1 <= 1'bx;
            dout2 <= 1'bx;
        end
        else
        begin
            dout1 <= din1;
            dout2 <= din2;
        end
    end
endmodule
