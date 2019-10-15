`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2019 09:56:39 AM
// Design Name: 
// Module Name: program_counter
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


module program_counter 
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
    input                           PCEN,
                                    clk,
                                    rst,
    input [ADDR_MEM - 1 : 0]        PC_1,
    // OUT
    output [ADDR_MEM - 1 : 0]   PC
);

    reg [ADDR_MEM - 1 : 0] pc_reg1, pc_reg0;
    /* Why 100: I experienced an error, when adding immed with $0.  $0 is meant to be solely zero.  
     * I initialized $0 in the regfile to be 19 to read where I stored my default values for the assignment
     * I shifted the instructions 101 rows in the .mem files so program must start at [101 - 1]
     */
    initial 
    begin
        pc_reg1 = 100;
        pc_reg0 = 100;
    end
    
    //always block when rst is true
    always @(*)
    begin
        if(rst) 
        begin
            pc_reg0 = 100;
            pc_reg1 = 100;
        end
        else pc_reg0 = PC_1;
    end
    
    //always block for passing pc = pc + 1
    always @(posedge clk)
    begin
        if(PCEN) pc_reg1 <= pc_reg0; // pc_reg0 will have pc + 1 regardless of the pcen
    end
    
    assign PC = pc_reg1;
endmodule
