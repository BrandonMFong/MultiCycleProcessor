`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2019 09:56:39 AM
// Design Name: 
// Module Name: mux5
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


module mux5 
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
    input [2 : 0]                   mux5sel,
    input [ADDR_MEM - 1 : 0]        PC_1,
                                    PC_SIMM,
                                    Jaddr,
    // OUT
    output reg [DATA_WL - 1 : 0]    dout
);
    always @(*)
    begin
        if(rst) dout = 1'bx;
        else
        begin
            case(mux5sel)
                0:
                begin
                    dout = Jaddr;
                end
                1:
                begin
                    dout = PC_1;
                end
                2:
                begin
                    dout = PC_SIMM;
                end
                default dout = 1'bx;
            endcase
        end
    end
endmodule
