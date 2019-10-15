`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2019 09:56:39 AM
// Design Name: 
// Module Name: mux0
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


module mux0 
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
    input                       rst,
                                mux0sel,
    input [ADDR_MEM - 1 : 0]    PC, // mux0sel = 1
                                ALU, // mux0sel = 0
    // OUT
    output reg [ADDR_MEM - 1 : 0]   dout
);
    always @(*)
    begin
        if(rst) dout = 1'bx;
        else
        begin
            case(mux0sel)
            0:
            begin
                dout = ALU;
            end
            1:
            begin
                dout = PC;
            end
            default dout = 1'bx;
            endcase
        end
    end
endmodule
