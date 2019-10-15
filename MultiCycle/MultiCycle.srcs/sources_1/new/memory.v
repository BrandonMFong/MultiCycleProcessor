`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2019 09:56:39 AM
// Design Name: 
// Module Name: memory
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


module memory 
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
    input                       clk,
                                rst,
                                MWE,
    input [ADDR_MEM - 1 : 0]    MRA,
                                MWD,
    // OUT
    output [DATA_WL - 1 : 0]    MRD
);
    
    reg [DATA_WL - 1 : 0] MEM [0 : 2**(ADDR_MEM-1)];
    
    initial $readmemb("inst_parte.mem", MEM);
    
    always @(posedge clk)
        if(MWE)
        begin
            MEM[MRA] <= MWD;
        end 
    assign MRD = rst ? 1'bx : MEM[MRA];
endmodule
