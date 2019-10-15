`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2019 09:56:39 AM
// Design Name: 
// Module Name: top_module
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

// TODO check your jump instruction
module top_module 
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
    input clk
    // OUT

);
    /** WIRES **/
    wire [DATA_WL - 1 : 0]      mux3_alu,
                                mux4_alu,
                                alu_reg0_mux5,
                                datareg_mux2,
                                pc_jump_mux2_mux4_mux0,
                                jump_mux5,
                                mux0_memory,
                                reg1_memory_mux3,
                                memory_instreg_datareg,
                                mux1_regfile,
                                reg0_mux2_mux5_mux0,
                                mux2_regfile,
                                signext_mux3,
                                reg1_mux4,
                                mux5_pc,
                                regfile_reg1_RFRD2,
                                regfile_reg1_RFRD1;
    //wire [ADDR_RF_WL - 1 : 0]
    //wire [ADDR_MEM - 1 : 0]
    wire [IMMED_WL - 1 : 0]     instreg_signext;
    wire [JUMP_WL - 1 : 0]      instreg_jump;
    //wire [ALU_WL - 1 : 0]
    wire [5 : 0]                instreg_controlunit_OP,
                                instreg_controlunit_FUNCT;
    wire [4 : 0]                instreg_alu,
                                instreg_regfile,
                                instreg_mux1_regfile,
                                instreg_mux1;
    wire [2 : 0]                controlunit_mux1,
                                controlunit_mux2,
                                controlunit_mux3,
                                controlunit_alu,
                                controlunit_mux5;
    wire                        control_unit_reset_everyone,
                                alu_and0,
                                controlunit_and0,
                                and0_or0,
                                controlunit_mux0,
                                controlunit_mux4,
                                controlunit_or0,
                                controlunit_memory,
                                controlunit_instreg,
                                controlunit_regfile,
                                or0_pc;           
    
    /** MODULES **/
    ALU 
            /* PARAMETERS */
            #(
                .DATA_WL(DATA_WL),
                .ADDR_RF_WL(ADDR_RF_WL),
                .ADDR_MEM(ADDR_MEM),
                .IMMED_WL(IMMED_WL),
                .JUMP_WL(JUMP_WL),
                .ALU_WL(ALU_WL),
                .ALU_IDLE(ALU_IDLE),
                .ALU_LW_SW_ADD_ADDI_PC(ALU_LW_SW_ADD_ADDI_PC),
                .ALU_SUB_BRANCH(ALU_SUB_BRANCH),
                .ALU_SLLV(ALU_SLLV),
                .ALU_SRAV(ALU_SRAV),
                .ALU_SRLV(ALU_SRLV),
                .ALU_MULT(ALU_MULT),
                .ALU_SLL(ALU_SLL),
                .ALU_SRA(ALU_SRA),
                .ALU_SRL(ALU_SRL)
            )
        mod0
            /* IN & OUT */
            (
                // IN
                .rst(control_unit_reset_everyone),
                .SHAMT(instreg_alu),
                .IN1(mux4_alu), 
                .IN2(mux3_alu),
                .ALUsel(controlunit_alu),
                // OUT
                .zeroflag(alu_and0),
                .DOUT(alu_reg0_mux5)
             ); 
             
    and0 
            /* PARAMETERS */
            #(
                .DATA_WL(DATA_WL),
                .ADDR_RF_WL(ADDR_RF_WL),
                .ADDR_MEM(ADDR_MEM),
                .IMMED_WL(IMMED_WL),
                .JUMP_WL(JUMP_WL)
            )
        mod1
            /* IN & OUT */
            (
                // IN
                .zeroflag(alu_and0),
                .branch_en(controlunit_and0),
                .rst(control_unit_reset_everyone),
                // OUT
                .dout(and0_or0)
             );
                  
    control_unit 
            /* PARAMETERS */
            #(
                // WL
                .DATA_WL(DATA_WL),
                .ADDR_RF_WL(ADDR_RF_WL),
                .ADDR_MEM(ADDR_MEM),
                .IMMED_WL(IMMED_WL),
                .JUMP_WL(JUMP_WL),
                .ALU_WL(ALU_WL),
                .OP_WL(OP_WL),
                .FUNCT_WL(FUNCT_WL),
                .LW(LW),
                .SW(SW),
                .ADDI(ADDI),
                .JUMP(JUMP),
                .R(R),
                .BEQ(BEQ),
                .BNE(BNE),
                .ADD(ADD),
                .SUB(SUB),
                .SLL(SLL),
                .SRA(SRA),
                .SRL(SRL),
                .SLLV(SLLV),
                .SRAV(SRAV),
                .SRLV(SRL),
                .DIV(DIV),
                .ALU_IDLE(ALU_IDLE),
                .ALU_LW_SW_ADD_ADDI_PC(ALU_LW_SW_ADD_ADDI_PC),
                .ALU_SUB_BRANCH(ALU_SUB_BRANCH),
                .ALU_SLLV(ALU_SLLV),
                .ALU_SRAV(ALU_SRAV),
                .ALU_SRLV(ALU_SRLV),
                .ALU_MULT(ALU_MULT),
                .ALU_SLL(ALU_SLL),
                .ALU_SRA(ALU_SRA),
                .ALU_SRL(ALU_SRL)
            )
        mod2
            /* IN & OUT */
            (
                // IN
                .clk(clk),
                .OPCODE(instreg_controlunit_OP),
                .FUNCT(instreg_controlunit_FUNCT),
                // OUT
                .mux0sel(controlunit_mux0),
                .mux4sel(controlunit_mux4),
                .branch(controlunit_and0),
                .PC_EN(controlunit_or0),
                .MEMW_EN(controlunit_memory),
                .IR_EN(controlunit_instreg),
                .RF_WE(controlunit_regfile),
                .mux1sel(controlunit_mux1),
                .mux2sel(controlunit_mux2),
                .mux3sel(controlunit_mux3),
                .mux5sel(controlunit_mux5), 
                .ALUsel(controlunit_alu),
                .rst(control_unit_reset_everyone)
             ); 
                  
    data_register 
            /* PARAMETERS */
            #(
                // WL
                .DATA_WL(DATA_WL),
                .ADDR_RF_WL(ADDR_RF_WL),
                .ADDR_MEM(ADDR_MEM),
                .IMMED_WL(IMMED_WL),
                .JUMP_WL(JUMP_WL)
            )
        mod3
            /* IN & OUT */
            (
                // IN
                .clk(clk),
                .rst(control_unit_reset_everyone),
                //.DR_EN(), not using this
                .din(memory_instreg_datareg),
                // OUT
                .dout(datareg_mux2)
             );
                  
    inst_register 
            /* PARAMETERS */
            #(
                // WL
                .DATA_WL(DATA_WL),
                .ADDR_RF_WL(ADDR_RF_WL),
                .ADDR_MEM(ADDR_MEM),
                .IMMED_WL(IMMED_WL),
                .JUMP_WL(JUMP_WL)
            )
        mod4
            /* IN & OUT */
            (
                // IN
                .inst(memory_instreg_datareg),
                .IR_EN(controlunit_instreg),
                .clk(clk),
                .rst(control_unit_reset_everyone),
                // OUT
                .RS(instreg_regfile),
                .RT(instreg_mux1_regfile),
                .RD(instreg_mux1),
                .SHAMT(instreg_alu), 
                .OPCODE(instreg_controlunit_OP),
                .FUNCT(instreg_controlunit_FUNCT),
                .IMMED(instreg_signext),
                .JUMP(instreg_jump)
             ); 
                  
    jump 
            /* PARAMETERS */
            #(
                // WL
                .DATA_WL(DATA_WL),
                .ADDR_RF_WL(ADDR_RF_WL),
                .ADDR_MEM(ADDR_MEM),
                .IMMED_WL(IMMED_WL),
                .JUMP_WL(JUMP_WL)
            )
        mod5
            /* IN & OUT */
            (
                // IN
                .rst(control_unit_reset_everyone),
                .JUMP(instreg_jump),
                .PC(pc_jump_mux2_mux4_mux0),
                // OUT
                .jaddr(jump_mux5)
             );
                  
    memory 
            /* PARAMETERS */
            #(
                // WL
                .DATA_WL(DATA_WL),
                .ADDR_RF_WL(ADDR_RF_WL),
                .ADDR_MEM(ADDR_MEM),
                .IMMED_WL(IMMED_WL),
                .JUMP_WL(JUMP_WL)
            )
        mod6
            /* IN & OUT */
            (
                // IN
                .clk(clk),
                .rst(control_unit_reset_everyone),
                .MWE(controlunit_memory),
                .MRA(mux0_memory),
                .MWD(reg1_memory_mux3),
                // OUT
                .MRD(memory_instreg_datareg)
             ); 
                  
    mux0 
            /* PARAMETERS */
            #(
                // WL
                .DATA_WL(DATA_WL),
                .ADDR_RF_WL(ADDR_RF_WL),
                .ADDR_MEM(ADDR_MEM),
                .IMMED_WL(IMMED_WL),
                .JUMP_WL(JUMP_WL)
            )
        mod7
            /* IN & OUT */
            (
                // IN
                .rst(control_unit_reset_everyone),
                .mux0sel(controlunit_mux0),
                .PC(pc_jump_mux2_mux4_mux0),
                .ALU(reg0_mux2_mux5_mux0),
                // OUT
                .dout(mux0_memory)
             ); 
                  
    mux1 
            /* PARAMETERS */
            #(
                // WL
                .DATA_WL(DATA_WL),
                .ADDR_RF_WL(ADDR_RF_WL),
                .ADDR_MEM(ADDR_MEM),
                .IMMED_WL(IMMED_WL),
                .JUMP_WL(JUMP_WL)
            )
        mod8
            /* IN & OUT */
            (
                // IN
                .rst(control_unit_reset_everyone),
                .mux1sel(controlunit_mux1),
                .RT(instreg_mux1_regfile),
                .RD(instreg_mux1),
                // OUT
                .dout(mux1_regfile)
             ); 
                  
    mux2 
            /* PARAMETERS */
            #(
                // WL
                .DATA_WL(DATA_WL),
                .ADDR_RF_WL(ADDR_RF_WL),
                .ADDR_MEM(ADDR_MEM),
                .IMMED_WL(IMMED_WL),
                .JUMP_WL(JUMP_WL)
            )
        mod9
            /* IN & OUT */
            (
                // IN
                .rst(control_unit_reset_everyone),
                .mux2sel(controlunit_mux2),
                .Jal_pc(pc_jump_mux2_mux4_mux0),
                .DMEM(datareg_mux2),
                .ALU(reg0_mux2_mux5_mux0),
                // OUT
                .dout(mux2_regfile)
             );
                  
    mux3 
            /* PARAMETERS */
            #(
                // WL
                .DATA_WL(DATA_WL),
                .ADDR_RF_WL(ADDR_RF_WL),
                .ADDR_MEM(ADDR_MEM),
                .IMMED_WL(IMMED_WL),
                .JUMP_WL(JUMP_WL)
            )
        mod10
            /* IN & OUT */
            (
                // IN
                .rst(control_unit_reset_everyone),
                .mux3sel(controlunit_mux3),
                .RFRD2(reg1_memory_mux3),
                .SIGNED_IMMED(signext_mux3),
                // OUT
                .dout(mux3_alu)
             );
                  
    mux4 
            /* PARAMETERS */
            #(
                // WL
                .DATA_WL(DATA_WL),
                .ADDR_RF_WL(ADDR_RF_WL),
                .ADDR_MEM(ADDR_MEM),
                .IMMED_WL(IMMED_WL),
                .JUMP_WL(JUMP_WL)
            )
        mod11
            /* IN & OUT */
            (
                // IN
                .rst(control_unit_reset_everyone),
                .mux4sel(controlunit_mux4),
                .RFRD1(reg1_mux4),
                .PCin(pc_jump_mux2_mux4_mux0),
                // OUT
                .dout(mux4_alu)
             );
                  
    mux5 
            /* PARAMETERS */
            #(
                // WL
                .DATA_WL(DATA_WL),
                .ADDR_RF_WL(ADDR_RF_WL),
                .ADDR_MEM(ADDR_MEM),
                .IMMED_WL(IMMED_WL),
                .JUMP_WL(JUMP_WL)
            )
        mod12
            /* IN & OUT */
            (
                // IN
                .rst(control_unit_reset_everyone),
                .mux5sel(controlunit_mux5),
                .PC_1(alu_reg0_mux5),
                .PC_SIMM(reg0_mux2_mux5_mux0),
                .Jaddr(jump_mux5),
                // OUT
                .dout(mux5_pc)
             );
                  
    or0 
            /* PARAMETERS */
            #(
                // WL
                .DATA_WL(DATA_WL),
                .ADDR_RF_WL(ADDR_RF_WL),
                .ADDR_MEM(ADDR_MEM),
                .IMMED_WL(IMMED_WL),
                .JUMP_WL(JUMP_WL)
            )
        mod13
            /* IN & OUT */
            (
                // IN
                .rst(control_unit_reset_everyone),
                .jump(and0_or0),
                .PC_EN(controlunit_or0),
                // OUT
                .PCEN(or0_pc)
             );
                  
    program_counter 
            /* PARAMETERS */
            #(
                // WL
                .DATA_WL(DATA_WL),
                .ADDR_RF_WL(ADDR_RF_WL),
                .ADDR_MEM(ADDR_MEM),
                .IMMED_WL(IMMED_WL),
                .JUMP_WL(JUMP_WL)
            )
        mod14
            /* IN & OUT */
            (
                // IN
                .PCEN(or0_pc),
                .clk(clk),
                .rst(control_unit_reset_everyone),
                .PC_1(mux5_pc),
                // OUT
                .PC(pc_jump_mux2_mux4_mux0)
             );
                  
    reg0 
            /* PARAMETERS */
            #(
                // WL
                .DATA_WL(DATA_WL),
                .ADDR_RF_WL(ADDR_RF_WL),
                .ADDR_MEM(ADDR_MEM),
                .IMMED_WL(IMMED_WL),
                .JUMP_WL(JUMP_WL)
            )
        mod15
            /* IN & OUT */
            (
                // IN
                .clk(clk),
                .rst(control_unit_reset_everyone),
                .din(alu_reg0_mux5),
                // OUT
                .dout(reg0_mux2_mux5_mux0)
             );
                  
    reg1 
            /* PARAMETERS */
            #(
                // WL
                .DATA_WL(DATA_WL),
                .ADDR_RF_WL(ADDR_RF_WL),
                .ADDR_MEM(ADDR_MEM),
                .IMMED_WL(IMMED_WL),
                .JUMP_WL(JUMP_WL)
            )
        mod16
            /* IN & OUT */
            (
                // IN
                .clk(clk),
                .rst(control_unit_reset_everyone),
                .din1(regfile_reg1_RFRD1),
                .din2(regfile_reg1_RFRD2),
                // OUT
                .dout1(reg1_mux4),
                .dout2(reg1_memory_mux3)
             );
                  
    reg_file 
            /* PARAMETERS */
            #(
                // WL
                .DATA_WL(DATA_WL),
                .ADDR_RF_WL(ADDR_RF_WL),
                .ADDR_MEM(ADDR_MEM),
                .IMMED_WL(IMMED_WL),
                .JUMP_WL(JUMP_WL)
            )
        mod17
            /* IN & OUT */
            (
                // IN
                .clk(clk),
                .rst(control_unit_reset_everyone),
                .RFWE(controlunit_regfile),
                .RFRA1(instreg_regfile),
                .RFRA2(instreg_mux1_regfile),
                .RFWA(mux1_regfile),
                .RFWD(mux2_regfile),
                // OUT
                .RFRD1(regfile_reg1_RFRD1),
                .RFRD2(regfile_reg1_RFRD2)
             );
                  
    sign_extension 
            /* PARAMETERS */
            #(
                // WL
                .DATA_WL(DATA_WL),
                .ADDR_RF_WL(ADDR_RF_WL),
                .ADDR_MEM(ADDR_MEM),
                .IMMED_WL(IMMED_WL),
                .JUMP_WL(JUMP_WL)
            )
        mod18
            /* IN & OUT */
            (
                // IN
                .rst(control_unit_reset_everyone),
                .IMMED(instreg_signext),
                // OUT
                .SIGNED_IMMED(signext_mux3)
             );
              
endmodule
