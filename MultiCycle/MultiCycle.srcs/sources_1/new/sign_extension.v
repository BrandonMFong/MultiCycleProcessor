`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2019 09:56:39 AM
// Design Name: 
// Module Name: sign_extension
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


module sign_extension
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
    input                                   rst,
    input signed [IMMED_WL - 1 : 0]         IMMED,
    // OUT
    output reg signed [DATA_WL - 1 : 0]     SIGNED_IMMED
);
    reg signed [DATA_WL - 1 : 0]   temp;
    always @(*)
    begin
        if(rst) SIGNED_IMMED = 1'bx;
        else
        begin
            temp = {IMMED, 16'b0000000000000000};
            SIGNED_IMMED = temp >>> 16; // check if your arithmetic is correct
        end
    end
endmodule
