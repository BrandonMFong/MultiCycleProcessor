# MultiCycleProcessor
 Multi Cycle Processor (CompE 475 Microprocessors)
 
 Programmed in Verilog HDL, this multi-cycle processor microarchitecture uses a finite state machine controller.  
 
 The multi-cycle executes instructions sequentially, only one instruction at a time, but each instruction takes multiple shorter clock cycles.  
 This is done by utilizing non-architectural registers to the multi-cycle processor to hold intermediate results between clock cycles.  
 
 This processor uses parametric modules, such as muxes, program counter, adders, memory, control unit, register file in read-first mode, ALU, and sign extension unit. 
 
 This design supports MIPS assembly language, however is not word addressable.  This architecture is byte addressable (i.e. the program counter is incremented by one, not 4).  
 
