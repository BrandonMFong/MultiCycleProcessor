`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2019 09:56:39 AM
// Design Name: 
// Module Name: mux4
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


module mux4 
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
                                    mux4sel,
    input [DATA_WL - 1 : 0]         RFRD1,
    input [ADDR_MEM - 1 : 0]        PCin,
    // OUT
    output reg [DATA_WL - 1 : 0]    dout
);
    always @(*)
    begin
        if(rst) dout = 1'bx;
        else
        begin
            case(mux4sel)
                0:
                begin
                    dout = RFRD1;
                end
                1:
                begin
                    dout = PCin;
                end
                default dout = 1'bx;
            endcase
        end
    end
endmodule
