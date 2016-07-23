module controller (
    input clk, reset,
    // ========= Data from Datapath =========
    input [5      : 0] op,
    // ========= Signal to Memory =========
    output reg [0 : 0] MemWrite,
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
    parameter FETCH                 = 4'b0000;
    parameter DECODE                = 4'b0001;
    parameter MEM_ADDR_COMPUTE      = 4'b0010;
    parameter MEM_READ              = 4'b0011;
    parameter MEM_WRITE_BACK_TO_REG = 4'b0100;
    parameter MEM_WRITE             = 4'b0101;
    parameter RTYPE_EXCUTION        = 4'b0110;
    parameter RTYPE_COMPLETION      = 4'b0111;
    parameter BRANCH_COMPLETION     = 4'b1000;
    parameter JUMP_COMPLETION       = 4'b1001;
    parameter HALT                  = 4'b1111;

    // OP
    parameter LB = 6'b100000;


    always @ (posedge clk) begin
        $display("[controller] time: %h, state: %b, MemWrite: %b, PCWriteCond: %b, PCWrite: %b, PCSource: %b, IorD: %b, MemToReg: %b, IRWrite: %b, RegWrite: %b, RegDst: %b, ALUSrcA: %b, ALUSrcB: %b, ALUOP: %b", $time, state, MemWrite, PCWriteCond, PCWrite, PCSource, IorD, MemToReg, IRWrite, RegWrite, RegDst, ALUSrcA, ALUSrcB, ALUOP);
        if (reset) state <= FETCH;
        else state <= nextState;
    end

    always @ ( * ) begin
        MemWrite    <= 1'b0;
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
            FETCH: begin
                IRWrite <= 1;
                ALUSrcB <= 2'b01;
                PCWrite <= 1;
                nextState <= FETCH;
            end
            HALT: nextState <= HALT;
        endcase
    end

endmodule // controller
