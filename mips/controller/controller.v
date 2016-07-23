module controller (
    input clk, reset,
    // ========= Data from Datapath =========
    input [5      : 0] op,
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
    output reg [0 : 0] ALUSrcA,
    output reg [1 : 0] ALUSrcB,
    // ========= Signal to Datapath =========
    output reg [5 : 0] ALUOP
    );

    // Runtime States
    reg [3:0] state, nextState;

    // States
    parameter FETCH                  = 4'b0000;
    parameter DECODE                 = 4'b0001;
    parameter MEM_ADDR_COMPUTE       = 4'b0010;
    parameter MEM_READ_WORD          = 4'b0011;
    parameter MEM_READ_SIGNED_BYTE   = 4'b0100;
    parameter MEM_READ_UNSIGNED_BYTE = 4'b0101;
    parameter MEM_WRITE_BACK_TO_REG  = 4'b0110;
    parameter MEM_WRITE_WORD         = 4'b0111;
    parameter MEM_WRITE_BYTE         = 4'b1000;
    parameter RTYPE_EXCUTION         = 4'b1001;
    parameter RTYPE_COMPLETION       = 4'b1010;
    parameter BRANCH_COMPLETION      = 4'b1011;
    parameter JUMP_COMPLETION        = 4'b1100;
    parameter HALT                   = 4'b1111;
    parameter RESET                  = 4'b1110;

    // OP
    parameter LW  = 6'b100011;
    parameter LB  = 6'b100000;
    parameter LBU = 6'b100100;
    parameter J   = 6'b000010;


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
        ALUSrcA     <= 0;
        ALUSrcB     <= 2'b0;
        ALUOP       <= 6'b0;
        case (state)
            RESET: begin
                $display("[controller] time: %h, current State: RESET", $time);
                nextState <= FETCH;
            end
            FETCH: begin
                $display("[controller] time: %h, current State: FETCH", $time);
                IRWrite <= 1;
                ALUSrcB <= 2'b01;
                PCWrite <= 1;
                nextState <= DECODE;
            end
            DECODE: begin
                $display("[controller] time: %h, current State: DECODE", $time);
                ALUSrcB <= 2'b11;
                case (op)
                    LW: nextState <= MEM_ADDR_COMPUTE;
                    LB: nextState <= MEM_ADDR_COMPUTE;
                    LBU: nextState <= MEM_ADDR_COMPUTE;
                    J: nextState <= JUMP_COMPLETION;
                endcase
            end
            JUMP_COMPLETION: begin
                $display("[controller] time: %h, current State: JUMP_COMPLETION", $time);
                PCWrite <= 1;
                PCSource <= 2'b10;
                nextState <= FETCH;
            end
            MEM_ADDR_COMPUTE: begin
                $display("[controller] time: %h, current State: MEM_ADDR_COMPUTE", $time);
                ALUSrcA <= 1;
                ALUSrcB <= 2'b10;
                ALUOP   <= 2'b00;
                case (op)
                    LW: nextState <= MEM_READ_WORD;
                    LB: nextState <= MEM_READ_SIGNED_BYTE;
                    LBU: nextState <= MEM_READ_UNSIGNED_BYTE;
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
            MEM_WRITE_BACK_TO_REG: begin
                $display("[controller] time: %h, current State: MEM_WRITE_BACK_TO_REG", $time);
                MemToReg <= 1;
                RegWrite <= 1;
                RegDst   <= 0;
                nextState <= FETCH;
            end
            HALT: nextState <= HALT;
        endcase
    end

endmodule // controller
