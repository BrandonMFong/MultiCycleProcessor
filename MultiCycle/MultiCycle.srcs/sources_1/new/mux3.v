`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2019 09:56:39 AM
// Design Name: 
// Module Name: mux3
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


module mux3 
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
    input [2 : 0]                   mux3sel,
    input [DATA_WL - 1 : 0]         RFRD2,
                                    SIGNED_IMMED,
    // OUT
    output reg [DATA_WL - 1 : 0]    dout
);
    always @(*)
    begin
        if(rst) dout = 1'bx;
        else
        begin
            case(mux3sel)
                0:
                begin
                    dout = RFRD2;
                end
                1:
                begin
                    dout = 1;
                end
                2:
                begin
                    dout = SIGNED_IMMED;
                end
                default dout = 1'bx;
            endcase
        end
    end
endmodule
