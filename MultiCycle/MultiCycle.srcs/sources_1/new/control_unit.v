`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2019 09:56:39 AM
// Design Name: 
// Module Name: control_unit
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


module control_unit
/*** PARAMETERS ***/
#(parameter
    // WL
    DATA_WL     = 32,
    ADDR_RF_WL  = 5,
    ADDR_MEM    = 32,
    IMMED_WL    = 16,
    JUMP_WL     = 26,
    ALU_WL      = 3,
    
    // Local param WL
    OP_WL       = 6,
    FUNCT_WL    = 6,
    
    // OPCODE
    LW          = 6'b100011,
    SW          = 6'b101011,
    ADDI        = 6'b001000,
    JUMP        = 6'b000010,
    R           = 6'b000000,
    BEQ         = 6'b000100,
    BNE         = 6'b000101,
    
    // FUNCT
    ADD         = 6'b100000,
    SUB         = 6'b100010,
    SLL         = 6'b000000,
    SRA         = 6'b000011,
    SRL         = 6'b000010,
    SLLV        = 6'b000100,
    SRAV        = 6'b000111,
    SRLV        = 6'b000110,
    /* TODO implement the bottom two functions if you have time */
    DIV         = 6'B011010,
    
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
    input                       clk,
    input [OP_WL - 1 : 0]       OPCODE,
    input [FUNCT_WL - 1 : 0]    FUNCT,
    
    // OUT
    output reg                  mux0sel, // 1 = pc, 0 = alu 
                                mux4sel, // 0 = rfrd1, 1 = pcin
                                branch,
                                PC_EN,
                                MEMW_EN,
                                IR_EN,
                                //DR_EN,
                                RF_WE,
                                
    output reg [2 : 0]          mux1sel, // 0 = rt, 1= rd, 2 = $31
                                mux2sel, // 0 = dmem, 1 = alu, 2 = jal_pc
                                mux3sel, // 0 = rfrd2, 1 = 1, 2 = signed immed
                                mux5sel, // 0 = jaddr, 1 = pc_1, 2 = pc_simm
                                
    output reg [ALU_WL - 1 : 0] ALUsel,
    output reg                  rst
);
    // Local parameters
    localparam  s0  = 0,
                s1  = 1,
                s2  = 2,
                s3  = 3;
    // Registers          
    reg             trigger; // local reset
    reg [4 : 0]     STATE;
    reg [4 : 0]     statecounter0;
    
    initial
    begin
        rst     = 1;
        #10 rst = 0;
    end
    
    // reset
    
    always @(rst)
    begin
        if (rst) 
        begin
            STATE           = 0;
            statecounter0   = 0;
        end
    end

    // we have statecounter and STATE
    always @(posedge clk)
    begin
        if(((STATE < 2) || (STATE == 5'b11111)) && !(rst))
        begin
            STATE <= STATE + 1;
        end
        if(!rst) statecounter0 <= statecounter0 + 1;
        
    end
    
    // FSM
    always @(*)
    begin
        case(STATE)
            s0: //FETCH
            begin
                // bit
                mux0sel     = 1'b1; // choose pc 
                mux4sel     = 1'b1; // choose pc
                // multi bit
                mux1sel     = 1'bx; // passing nothing into regfile
                mux2sel     = 1'bx; // passing nothing into regfile
                mux3sel     = 1'b1; // passing one into alu to pc + 1
                mux5sel     = 1'b1; // passing pc + 1
                // enabler
                branch      = 1'b0; // don't branch HAVE TO PASS A 0
                PC_EN       = 1'b1; // pc = pc + 1
                MEMW_EN     = 1'bx; // reading not writing 
                IR_EN       = 1'b1; // passing inst from mem
                //DR_EN       = 1'bx;
                RF_WE       = 1'bx; // not reading/writing regfile yet
                ALUsel      = ALU_LW_SW_ADD_ADDI_PC;
            end
            s1: //DECODE
            begin
                // bit
                mux0sel     = 1'b0; // choose pc CUZ you are still reading from instruction
                mux4sel     = 1'b1; // if it's branch, will have the jump address by the 3rd clock cycle
                // multi bit
                mux1sel     = 1'bx; // passing nothing into regfile
                mux2sel     = 1'bx; // passing nothing into regfile
                mux3sel     = 2'b10; // if it's branch, will have the jump address by the 3rd clock cycle
                mux5sel     = 1'bx; // passing nothing, it's connected to output of alu
                // enablers
                branch      = 1'b0; // don't branch
                PC_EN       = 1'b0; // don't pass new
                MEMW_EN     = 1'b0; // not writing anything into mem 
                IR_EN       = 1'b0; // don't change inst reg
                //DR_EN       = 1'bx;
                RF_WE       = 1'b0; // not writing anything into regfile 
                ALUsel      = ALU_LW_SW_ADD_ADDI_PC;
            end
            s2: //EXECUTE
            begin
                case(OPCODE)
                    LW:
                    begin
                        // bit
                        mux0sel     = 1'b0; // choose pc CUZ you are still ready from instruction
                        mux4sel     = 1'b0; // calc effective address
                        mux1sel     = 1'b0; // write address at Rt
                        // multi bit
                        mux2sel     = 2'b00; // passing data from mem
                        mux3sel     = 2'b10; // passing efffective address
                        mux5sel     = 1'bx; // passing nothing, it's connected to output of alu
                        // enablers
                        branch      = 1'b0; // don't branch
                        PC_EN       = 1'b0; // don't pass new
                        MEMW_EN     = 1'b0; // not writing anything into mem 
                        IR_EN       = 1'b0; // still reading current instruction 
                        //DR_EN       = 1'b1;
                         
                        // alu
                        ALUsel      = ALU_LW_SW_ADD_ADDI_PC;
                        
                        if(statecounter0 == 4)// Check your logic here
                        begin
                            // setting state to -1 because STATE and statecounter0 is being driven by the outside always block
                            STATE           = s0 - 1; // go back to fetch
                            statecounter0   = -1;
                            RF_WE           = 1;
                        end
                        else RF_WE          = 1'b0; // not writing anything into regfile
                    end
                    SW:
                    begin
                        // bit
                        mux0sel     = 1'b0; // alu output
                        mux4sel     = 1'b0; // base address
                        mux1sel     = 1'bx; // not writing into reg file
                        // multi bit
                        mux2sel     = 2'bxx; // writing nothing into regfile
                        mux3sel     = 2'b10; // 
                        mux5sel     = 1'bx; //
                        // enablers
                        branch      = 1'b0; // 
                        PC_EN       = 1'b0; // 
                         
                        IR_EN       = 1'bx; // 
                        //DR_EN       = 1'b1;
                        RF_WE       = 1'b0; // 
                        // alu
                        ALUsel      = ALU_LW_SW_ADD_ADDI_PC;
                        
                        if(statecounter0 == 3)// Check your logic here.  One less than lw
                        begin
                            STATE           = s0 - 1; // go back to fetch
                            statecounter0   = -1;
                            MEMW_EN         = 1'b1;
                        end
                        else MEMW_EN     = 1'b0; //don't write until the last clock cycle, or else you'll write random data
                    end
                    ADDI:
                    begin
                        // bit
                        mux0sel     = 1'bx; // 
                        mux4sel     = 1'b0; // 
                        mux1sel     = 1'b0; // 
                        // multi bit
                        mux2sel     = 2'b01; // 
                        mux3sel     = 2'b10; // 
                        mux5sel     = 1'bx; //
                        // enablers
                        branch      = 1'b0; // 
                        PC_EN       = 1'b0; // 
                        MEMW_EN     = 1'b0; // 
                        IR_EN       = 1'bx; // 
                        //DR_EN       = 1'b1;
                        
                        // alu
                        ALUsel      = ALU_LW_SW_ADD_ADDI_PC;
                        
                        if(statecounter0 == 3)// Check your logic here.  One less than lw
                        begin
                            STATE           = s0 - 1; // go back to fetch
                            statecounter0   = -1;
                            RF_WE       = 1'b1; // 
                        end
                        else RF_WE       = 1'b0; // 
                    end
                    JUMP: //might be problematic
                    begin
                        // bit
                        mux0sel     = 1'b0; // 
                        mux4sel     = 1'bx; // 
                        mux1sel     = 1'b0; // 
                        // multi bit
                        mux2sel     = 2'b01; // 
                        mux3sel     = 2'bxx; // 
                        mux5sel     = 1'b0; //
                        // enablers
                        branch      = 1'b1; // 
                        PC_EN       = 1'b1; // refer to the book
                        MEMW_EN     = 1'b0; // 
                        IR_EN       = 1'bx; // 
                        //DR_EN       = 1'b1;
                        RF_WE       = 1'b0; // 
                        // alu
                        ALUsel      = 1'bx; //alu does nothing
                        
                        if(statecounter0 == 2)// Check your logic here
                        begin
                            STATE           = s0 - 1; // go back to fetch
                            statecounter0   = -1;
                        end
                    end
                    R: //
                    begin
                        // bit
                        mux0sel     = 1'bx; // 
                        mux4sel     = 1'b0; // 
                        mux1sel     = 1'b1; // 
                        // multi bit
                        mux2sel     = 2'b01; // 
                        mux3sel     = 2'b00; // 
                        mux5sel     = 1'bx; //
                        // enablers
                        branch      = 1'b0; // 
                        PC_EN       = 1'b0; // refer to the book
                        MEMW_EN     = 1'b0; // 
                        IR_EN       = 1'bx; // 
                        //DR_EN       = 1'b1;
                        
                        /*** FUNCT SELECTS ***/
                        case(FUNCT)
                            ADD:
                            begin
                               ALUsel = ALU_LW_SW_ADD_ADDI_PC;
                            end
                            SUB:
                            begin
                               ALUsel = ALU_SUB_BRANCH;
                            end
                            SLL:
                            begin
                               ALUsel = ALU_SLL;
                            end
                            SLLV:
                            begin
                               ALUsel = ALU_SLLV;
                            end
                            SRA:
                            begin
                               ALUsel = ALU_SRA;
                            end
                            SRAV:
                            begin
                               ALUsel = ALU_SRAV;
                            end
                            SRL:
                            begin
                               ALUsel = ALU_SRL;
                            end
                            SRLV:
                            begin
                               ALUsel = ALU_SRLV;
                            end  
                        default ALUsel = ALU_IDLE;
                        endcase
                        
                        // keeping count out of case statement.  Still the same as if I put this in each case.  saving space
                        if(statecounter0 == 3)// Check your logic here
                        begin
                            STATE           = s0 - 1; // go back to fetch
                            statecounter0   = -1;
                            RF_WE           = 1'b1; // good to write
                        end
                        else RF_WE          = 1'b0; // don't write until you reach the end of the inst
                    end
                    BEQ:
                    begin
                        // bit
                        mux0sel     = 1'bx; // not accessing memory
                        mux4sel     = 1'b0; // comparing rs and rt 
                        mux1sel     = 1'bx; // 
                        // multi bit
                        mux2sel     = 2'bxx; // passing data from mem
                        mux3sel     = 2'b00; // comparing rs and rt 
                        mux5sel     = 2'b10; // passing pc+simm to pc IFF zero flag is true
                        // enablers
                        branch      = 1'b1; // don't branch
                        PC_EN       = 1'b0; // don't pass new
                        MEMW_EN     = 1'b0; // not writing anything into mem 
                        IR_EN       = 1'b0; // still reading current instruction 
                        //DR_EN       = 1'b1;
                        RF_WE       = 1'b0; // not writing anything into regfile 
                        // alu
                        ALUsel      = ALU_SUB_BRANCH;
                        
                        if(statecounter0 == 2)// Check your logic here
                        begin
                            STATE           = s0 - 1; // go back to fetch
                            statecounter0   = -1;
                        end
                    end
                    //BNE: TODO implement.  activate zeroflag IFF rt - rs != 0
                endcase
            end
            //default trigger = 0;
        endcase
    end
endmodule
