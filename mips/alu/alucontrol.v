module alucontrol (
    input clk, reset,
    input [5:0] funct,
    input [5:0] ALUOP,
    input [31:0] aluParamData1, aluParamData2,
    output zero,
    output [31:0] aluResult
    );

    reg [4:0] ALUControl;

    always @ ( * ) begin
        case (ALUOP)
            6'b000000: ALUControl <= 5'b00010; // PC = PC + 4
        endcase
    end

    alu _alu(clk, reset, aluParamData1, aluParamData2, ALUControl, zero, aluResult);

endmodule // alucontrol
