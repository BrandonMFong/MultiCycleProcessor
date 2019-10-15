`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2019 09:56:39 AM
// Design Name: 
// Module Name: ALU
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


module ALU 
/*** PARAMETERS ***/
#(parameter
    // WL
    DATA_WL     = 32,
    ADDR_RF_WL  = 5,
    ADDR_MEM    = 32,
    IMMED_WL    = 16,
    JUMP_WL     = 26,
    ALU_WL      = 3,
    
    // Local param
    SHAMT_WL    = 5,
    
    // ALU
    ALU_IDLE                = 3'b000,
    ALU_LW_SW_ADD_ADDI_PC   = 3'b001,
    ALU_SUB_BRANCH          = 3'b010,
    ALU_SLLV                = 3'b011,
    ALU_SRAV                = 3'b100,
    ALU_SRLV                = 3'b101,
    ALU_MULT                = 3'b110,
    ALU_SLL                 = 3'b111,
    ALU_SRA                 = 4'b1000,
    ALU_SRL                 = 4'b1001
)
/*** IN/OUT ***/
(
    // IN
    input                           rst,
    input [SHAMT_WL - 1 : 0]        SHAMT, // shift amount
    input [DATA_WL - 1 : 0]         IN1, 
                                    IN2,
    input [ALU_WL - 1 : 0]          ALUsel,
    
    // OUT
    output reg                      zeroflag,
    output reg [DATA_WL - 1 : 0]    DOUT
);
    reg [2*DATA_WL - 1 : 0] multreg;


    always @(*)
    begin
       if(rst)
       begin
           DOUT = 0;
       end
       else
       begin
           case(ALUsel)
               ALU_IDLE:
               begin
                   DOUT = 0; // Do nothing, out nothing
               end
               ALU_LW_SW_ADD_ADDI_PC:
               begin
                   DOUT = IN1 + IN2;
               end
               ALU_SUB_BRANCH:
               begin
                   DOUT = IN1 - IN2;
               end
               ALU_SLLV:
               begin
                   DOUT = IN2 << IN1;
               end
               ALU_SRAV:
               begin
                   DOUT = IN2 >>> IN1;
               end
               ALU_SRLV:
               begin
                   DOUT = IN2 >> IN1;
               end
               ALU_SLL:
               begin
                   DOUT = IN2 << SHAMT;
               end
               ALU_SRA:
               begin
                   DOUT = IN2 >>> SHAMT;
               end
               ALU_SRL:
               begin
                   DOUT = IN2 >> SHAMT;
               end
               default DOUT = 1'bx;
            endcase
        /* ZERO FLAG */
        zeroflag = (!(IN1 - IN2)) ? 1 : 0; // TODO figure this out
        end
    end
endmodule
