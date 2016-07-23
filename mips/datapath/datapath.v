module datapath (
    input clk, reset,
    // ========= Signal from Controller =========
    // All Signal Varibles are capitalized
    input PCWriteCond, PCWrite,
    input [1   : 0] PCSource,
    input IorD,
    input MemToReg,
    input IRWrite,
    input RegWrite, RegDst,
    input ALUSrcA,
    input [1   : 0] ALUSrcB,
    // ========= Data from ALUController =========
    input zero,
    input [31  : 0] aluResult,
    // ========= Data from Memory =========
    input [31  : 0] memData,
    // ========= Data to Controller =========
    output [5  : 0] op,
    // ========= Data to ALUController =========
    output [5  : 0] funct,
    output [31 : 0] aluParamData1, aluParamData2,
    // ========= Data to Memory =========
    output [31 : 0] writeMemData,
    output [15 : 0] memAddr
    );

    assign writeMemData = regData2;

    // ========= processed PC Signal =========
    wire RealPCWrite;
    assign RealPCWrite = (PCWriteCond & zero) | PCWrite;
    // ==================

    // ========= Instructions Address Used by PC =========
    wire [15 : 0] nextInsAddr;
    wire [15 : 0] currentInsAddr;
    // ==================

    // ========= Data produced by alu in dff =========
    wire [31 : 0] aluOut;
    // ==================

    // ========= Instruction fetched from Memory stored in instr_reg =========
    wire [31 : 0] instruction;
    // ==================

    // ========= Data fetched from Memory stored in mem_reg =========
    wire [31 : 0] memDataInReg;
    // ==================

    // ========= Registry Write Address =========
    wire [4  : 0] writeRegAddr;
    // ==================

    // ========= Registry Write Data =========
    wire [31 : 0] writeRegData;
    // ==================

    // ========= Data directly from Registry =========
    wire [31 : 0] dataFromReg1, dataFromReg2;
    // ==================

    // ========= Data directly from Registry stored in DFF =========
    wire [31 : 0] regData1, regData2;
    // ==================

    // ========= Instruction slices for output =========
    wire [4  : 0] regAddr1FromInstr, regAddr2FromInstr, regAddr3FromInstr; // regAddr3FromInstr is for R-type Instruction
    wire [15 : 0] immFromInstr;
    wire [25 : 0] jumpAddrFromInstr;
    assign op                = instruction[31:26];
    assign funct             = instruction[5:0];
    assign regAddr1FromInstr = instruction[25:21];
    assign regAddr2FromInstr = instruction[20:16];
    assign regAddr3FromInstr = instruction[15:11];
    assign immFromInstr      = instruction[15:0];
    assign jumpAddrFromInstr = instruction[25:0];
    // ==================

    // ========= Sign-Extended Imm=========
    wire [31 : 0] extendedImm;
    // ==================

    // ========= Left 2-bit shifted Values=========
    wire [31 : 0] extendedImmx4;
    wire [27 : 0] jumpAddrFromInstrx4;
    // ==================

    PC mips_pc(clk, reset, nextInsAddr, RealPCWrite, currentInsAddr);
    mux2 #(16) mips_instr_addr_src(currentInsAddr, aluOut[15:0], IorD, memAddr);
    mux2 #(5) mips_reg_write_addr_src(regAddr2FromInstr, regAddr3FromInstr, RegDst, writeRegAddr);
    regfile mips_reg(clk, reset, RegWrite, regAddr1FromInstr, regAddr2FromInstr, writeRegAddr, writeRegData, dataFromReg1, dataFromReg2);
    dff mips_instr_reg(clk, reset, IRWrite, memData, instruction);
    dff mips_aluresult_reg(clk, reset, 1'b1, aluResult, aluOut);
    dff mips_mem_reg(clk, reset, 1'b1, memData, memDataInReg);
    mux2 mips_reg_write_data_src(aluOut, memDataInReg, MemToReg, writeRegData);
    dff mips_dff_a(clk, reset, 1'b1, dataFromReg1, regData1);
    dff mips_dff_b(clk, reset, 1'b1, dataFromReg2, regData2);
    mux2 mips_alu_src1({16'b0, currentInsAddr}, regData1, ALUSrcA, aluParamData1);
    signextend imm_extend(immFromInstr, extendedImm);
    leftshift2 extended_imm_left_shift2(extendedImm, extendedImmx4);
    mux4 mips_alu_src2(regData2, 32'h4, extendedImm, extendedImmx4, ALUSrcB, aluParamData2);
    leftshift2 #(28) jump_addr_left_shift2({2'b0, jumpAddrFromInstr}, jumpAddrFromInstrx4);
    mux4 #(16) next_instr_src(aluResult[15:0], aluOut[15:0], jumpAddrFromInstrx4[15:0], 16'b0, PCSource, nextInsAddr);

    // always @ ( * ) begin
        // $display("[datapath] time: %h, RealPCWrite: %b, nextInsAddr: %h, currentInsAddr: %h, aluResult %h, aluOut: %h, instruction: %h, memAddr: %h, memData: %h, memDataInReg: %h, writeRegAddr: %h, writeRegData: %h, dataFromReg1: %h, dataFromReg2: %h, aluParamData1: %h, aluParamData2: %h, ALUSrcA: %b, ALUSrcB: %b", $time, RealPCWrite, nextInsAddr, currentInsAddr, aluResult, aluOut, instruction, memAddr, memData, memDataInReg, writeRegAddr, writeRegData, dataFromReg1, dataFromReg2, aluParamData1, aluParamData2, ALUSrcA, ALUSrcB);
    // end

endmodule // datapath
