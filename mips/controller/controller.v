module controller (
    input clk, reset,
    // ========= Data from Datapath =========
    input [5      : 0] op,
    input [5      : 0] funct,
    // ========= Signal to Memory =========
    output reg [0 : 0] MemWrite,
    // Word or Byte
    // 2'b00: Word
    // 2'b01: Signed Byte
    // 2'b10: Unsigned Byte
    output reg [1 : 0] MemMode,
    // ========= Signal to Datapath =========
    output reg [0 : 0] PCWriteCond, PCWrite,
    output reg [1 : 0] PCSource,
    output reg [0 : 0] IorD,
    output reg [0 : 0] MemToReg,
    output reg [0 : 0] IRWrite,
    output reg [0 : 0] RegWrite, RegDst,
    output reg [1 : 0] ALUSrcA, ALUSrcB,
    // ========= Signal to Datapath =========
    output reg [4 : 0] ALUOP
    );

    // Runtime States
    reg [5:0] state, nextState;

    // States
    parameter FETCH                  = 6'b000000;
    parameter DECODE                 = 6'b000001;
    parameter MEM_ADDR_COMPUTE       = 6'b000010;
    parameter MEM_READ_WORD          = 6'b000011;
    parameter MEM_READ_SIGNED_BYTE   = 6'b000100;
    parameter MEM_READ_UNSIGNED_BYTE = 6'b000101;
    parameter MEM_WRITE_BACK_TO_REG  = 6'b000110;
    parameter MEM_WRITE_WORD         = 6'b000111;
    parameter MEM_WRITE_BYTE         = 6'b001000;
    parameter RTYPE_EXCUTION         = 6'b001001;
    parameter RTYPE_COMPLETION       = 6'b001010;
    parameter BRANCH_COMPLETION      = 6'b001011;
    parameter JUMP_COMPLETION        = 6'b001100;
    parameter IMM_EXCUTION           = 6'b001101;
    parameter IMM_COMPLETION         = 6'b001110;
    parameter RESET                  = 6'b111110;
    parameter HALT                   = 6'b111111;

    // OP
    parameter LW    = 6'b100011;  // test passed
    parameter LB    = 6'b100000;  // test passed
    parameter LBU   = 6'b100100;  // test passed
    parameter J     = 6'b000010;  // test passed
    parameter RTYPE = 6'b000000;
    parameter SB    = 6'b101000;
    parameter ORI   = 6'b001101;  // test passed
    parameter LUI   = 6'b001111;  // test passed

    // funct
    parameter SLL   = 6'b000000;  // test passed
    parameter SRL   = 6'b000010;  // test passed
    parameter SRA   = 6'b000011;  // test passed
    parameter OR    = 6'b100101;  // test passed
    parameter ADDU  = 6'b100001;  // test passed
    parameter ADD   = 6'b100000;  // test passed

    always @ (posedge clk) begin
        // $display("[controller] time: %h, state: %b, MemWrite: %b, MemMode: %b, PCWriteCond: %b, PCWrite: %b, PCSource: %b, IorD: %b, MemToReg: %b, IRWrite: %b, RegWrite: %b, RegDst: %b, ALUSrcA: %b, ALUSrcB: %b, ALUOP: %b", $time, state, MemWrite, MemMode, PCWriteCond, PCWrite, PCSource, IorD, MemToReg, IRWrite, RegWrite, RegDst, ALUSrcA, ALUSrcB, ALUOP);
        if (reset) state <= RESET;
        else state <= nextState;
    end

    always @ ( * ) begin
        MemWrite    <= 1'b0;
        MemMode     <= 2'b00;
        PCWriteCond <= 1'b0;
        PCWrite     <= 1'b0;
        PCSource    <= 2'b00;
        IorD        <= 1'b0;
        MemToReg    <= 1'b0;
        IRWrite     <= 1'b0;
        RegWrite    <= 1'b0;
        RegDst      <= 0;
        ALUSrcA     <= 2'b0;
        ALUSrcB     <= 2'b0;
        ALUOP       <= 5'b0;
        case (state)
            RESET: begin
                $display("[controller] time: %h, current State: RESET", $time);
                nextState <= FETCH;
            end
            FETCH: begin
                $display("[controller] time: %h, current State: FETCH", $time);
                IRWrite   <= 1;
                ALUSrcB   <= 2'b01;
                PCWrite   <= 1;
                nextState <= DECODE;
            end
            DECODE: begin
                $display("[controller] time: %h, current State: DECODE", $time);
                ALUSrcB <= 2'b11;
                case (op)
                    LW: nextState      <= MEM_ADDR_COMPUTE;
                    LB: nextState      <= MEM_ADDR_COMPUTE;
                    LBU: nextState     <= MEM_ADDR_COMPUTE;
                    J: nextState       <= JUMP_COMPLETION;
                    RTYPE: nextState   <= RTYPE_EXCUTION;
                    SB: nextState      <= MEM_ADDR_COMPUTE;
                    ORI: nextState     <= IMM_EXCUTION;
                    LUI: nextState     <= IMM_EXCUTION;
                    default: nextState <= HALT;
                endcase
            end
            IMM_EXCUTION: begin
                $display("[controller] time: %h, current State: IMM_EXCUTION", $time);
                ALUSrcA   <= 2'b01;
                case (op)
                    ORI: ;
                    default: ;
                endcase
                ALUSrcB   <= 2'b10;
                case (op)
                    ORI: ALUOP <= 5'b01000;
                    LUI: ALUOP <= 5'b00111;
                endcase
                nextState <= IMM_COMPLETION;
            end
            IMM_COMPLETION: begin
                $display("[controller] time: %h, current State: IMM_COMPLETION", $time);
                RegWrite  <= 1;
                nextState <= FETCH;
            end
            RTYPE_EXCUTION: begin
                $display("[controller] time: %h, current State: RTYPE_EXCUTION", $time);
                case (funct)
                    SLL: ALUSrcA     <= 2'b10;
                    SRL: ALUSrcA     <= 2'b10;
                    SRA: ALUSrcA     <= 2'b10;
                    default: ALUSrcA <= 2'b01;
                endcase
                ALUSrcB   <= 2'b00;
                case (funct)
                    SLL: ALUOP  <= 5'b00100;
                    SRL: ALUOP  <= 5'b00101;
                    SRA: ALUOP  <= 5'b00110;
                    OR : ALUOP  <= 5'b00001;
                    ADDU: ALUOP <= 5'b00000;
                    ADD: ALUOP  <= 5'b00000;
                endcase
                nextState <= RTYPE_COMPLETION;
            end
            RTYPE_COMPLETION: begin
                $display("[controller] time: %h, current State: RTYPE_COMPLETION", $time);
                RegDst    <= 1;
                RegWrite  <= 1;
                MemToReg  <= 0;
                nextState <= FETCH;
            end
            JUMP_COMPLETION: begin
                $display("[controller] time: %h, current State: JUMP_COMPLETION", $time);
                PCWrite   <= 1;
                PCSource  <= 2'b10;
                nextState <= FETCH;
            end
            MEM_ADDR_COMPUTE: begin
                $display("[controller] time: %h, current State: MEM_ADDR_COMPUTE", $time);
                ALUSrcA <= 2'b01;
                ALUSrcB <= 2'b10;
                case (op)
                    LW: nextState      <= MEM_READ_WORD;
                    LB: nextState      <= MEM_READ_SIGNED_BYTE;
                    LBU: nextState     <= MEM_READ_UNSIGNED_BYTE;
                    SB: nextState      <= MEM_WRITE_BYTE;
                    default: nextState <= FETCH;
                endcase
            end
            MEM_READ_WORD: begin
                $display("[controller] time: %h, current State: MEM_READ_WORD", $time);
                IorD      <= 1;
                nextState <= MEM_WRITE_BACK_TO_REG;
            end
            MEM_READ_SIGNED_BYTE: begin
                $display("[controller] time: %h, current State: MEM_READ_SIGNED_BYTE", $time);
                MemMode   <= 2'b01;
                IorD      <= 1;
                nextState <= MEM_WRITE_BACK_TO_REG;
            end
            MEM_READ_UNSIGNED_BYTE: begin
                $display("[controller] time: %h, current State: MEM_READ_UNSIGNED_BYTE", $time);
                MemMode   <= 2'b10;
                IorD      <= 1;
                nextState <= MEM_WRITE_BACK_TO_REG;
            end
            MEM_WRITE_BYTE: begin
                $display("[controller] time: %h, current State: MEM_WRITE_BYTE", $time);
                MemWrite  <= 1;
                IorD      <= 1;
                MemMode   <= 2'b01;
                nextState <= FETCH;
            end
            MEM_WRITE_BACK_TO_REG: begin
                $display("[controller] time: %h, current State: MEM_WRITE_BACK_TO_REG", $time);
                MemToReg  <= 1;
                RegWrite  <= 1;
                RegDst    <= 0;
                nextState <= FETCH;
            end
            HALT: begin
                $display("SYSTEM HALT!");
                nextState <= HALT;
            end
        endcase
    end

endmodule // controller
