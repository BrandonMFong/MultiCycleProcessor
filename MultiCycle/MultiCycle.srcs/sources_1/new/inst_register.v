`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2019 09:56:39 AM
// Design Name: 
// Module Name: inst_register
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


module inst_register 
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
    input                               IR_EN,
                                        clk,
                                        rst,
    input [DATA_WL - 1 : 0]             inst,                                
    // OUT
    output reg [ADDR_RF_WL - 1 : 0]     RS,
                                        RT,
                                        RD,
                                        SHAMT, // can use this wl
    output reg [5 : 0]                  OPCODE,
                                        FUNCT,
    output reg [IMMED_WL - 1 : 0]       IMMED,
    output reg [JUMP_WL - 1 : 0]        JUMP
);

    reg [DATA_WL - 1 : 0]   inst_reg;
    
    // This ensures that whatever the input inst is changed to, we still have the right instruction
    always @(posedge clk)
    begin
        if(IR_EN) inst_reg <= inst;
    end
    
    always @(*)
    begin
        if(rst)
        begin
            OPCODE      = 0; //might be {}
            FUNCT       = 0;
            RS          = 0;
            RT          = 0;
            RD          = 0;
            SHAMT       = 0;
            IMMED       = 0;
            JUMP        = 0;
        end
        else
        begin
            OPCODE      = inst_reg[31 : 26]; //might be {}
            FUNCT       = inst_reg[5 : 0];
            RS          = inst_reg[25 : 21];
            RT          = inst_reg[20 : 16];
            RD          = inst_reg[15 : 11];
            SHAMT       = inst_reg[10 : 6];
            IMMED       = inst_reg[15 : 0];
            JUMP        = inst_reg[25 : 0];
        end
    end

endmodule
