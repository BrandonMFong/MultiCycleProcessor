`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2019 09:56:39 AM
// Design Name: 
// Module Name: reg_file
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


module reg_file 
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
                                RFWE,
    input [ADDR_RF_WL - 1 : 0]  RFRA1,
                                RFRA2,
                                RFWA,
    input [DATA_WL - 1 : 0]     RFWD,
    // OUT
    output [DATA_WL - 1 : 0]    RFRD1,
                                RFRD2
);

    reg [DATA_WL - 1 : 0] registers [0 : 2**ADDR_RF_WL];
    
    initial
    begin
        registers[0] = 32'b00000000000000000000000000000000;
        registers[1] = 32'b00000000000000000000000000000000;
        registers[2] = 32'b00000000000000000000000000000000;
        registers[3] = 32'b00000000000000000000000000000000;
        registers[4] = 32'b00000000000000000000000000000000;
        registers[5] = 32'b00000000000000000000000000000000;
        registers[6] = 32'b00000000000000000000000000000000;
        registers[7] = 32'b00000000000000000000000000000000;
        registers[8] = 32'b00000000000000000000000000000000;
        registers[9] = 32'b00000000000000000000000000000000;
        registers[10] = 32'b00000000000000000000000000000000;
        registers[11] = 32'b00000000000000000000000000000000;
        registers[12] = 32'b00000000000000000000000000000000;
        registers[13] = 32'b00000000000000000000000000000000;
        registers[14] = 32'b00000000000000000000000000000000;
        registers[15] = 32'b00000000000000000000000000000000;
        registers[16] = 32'b00000000000000000000000000000000; 
        registers[17] = 32'b00000000000000000000000000000000;
        registers[18] = 32'b00000000000000000000000000000000;
        registers[19] = 32'b00000000000000000000000000000000;
        registers[20] = 32'b00000000000000000000000000000000;
        registers[21] = 32'b00000000000000000000000000000000;
        registers[22] = 32'b00000000000000000000000000000000;
        registers[23] = 32'b00000000000000000000000000000000;
        registers[24] = 32'b00000000000000000000000000000000;
        registers[25] = 32'b00000000000000000000000000000000;
        registers[26] = 32'b00000000000000000000000000000000;
        registers[27] = 32'b00000000000000000000000000000000;
        registers[28] = 32'b00000000000000000000000000000000;
        registers[29] = 32'b00000000000000000000000000000000;
        registers[30] = 32'b00000000000000000000000000000000;
        registers[31] = 32'b00000000000000000000000000000000;
    end
    
    always @(posedge clk)
    begin
        if(RFWE) registers[RFWA] = RFWD;
    end
    
    assign RFRD1 = rst ? 1'bx : registers[RFRA1];
    assign RFRD2 = rst ? 1'bx : registers[RFRA2];
endmodule
