module alu #(parameter WIDTH = 32) (
    input [WIDTH-1:0] param1, param2,
    input [4:0] ALUControl,
    output zero,
    output reg [WIDTH-1:0] aluResult
    );

    // ALUOP
    parameter SUM  = 5'b00000;
    parameter OR   = 5'b00001;
    parameter AND  = 5'b00011;
    parameter SL   = 5'b00100;
    parameter SRL  = 5'b00101;
    parameter SRA  = 5'b00110;
    parameter LUI  = 5'b00111;
    parameter ORI  = 5'b01000; // param2 is 16-bits, needs zero-extend.
    parameter SUB  = 5'b01001;


    assign zero = (aluResult == 32'b0) ? 1'b1 : 1'b0;

    always @ ( * ) begin
        case (ALUControl)
            SUM: aluResult <= param1 + param2;
            OR: aluResult  <= param1 | param2;
            AND: aluResult <= param1 & param2;
            SL: aluResult  <= (param2 << param1[10:6]);
            SRL: aluResult <= (param2 >> param1[10:6]);
            SRA: aluResult <= (param2[31] == 0) ? (param2 >> param1[10:6]) : ((~(1<<param1[10:6])<<(32-param1[10:6])) | (param2>>param1[10:6]));
            LUI: aluResult <= (param2 << 16);
            ORI: aluResult <= (32'h0000ffff & param2) | param1;
            SUB: aluResult <= param1 - param2;
        endcase
    end

    // always @ ( * ) begin
    //     $display("[alu] time: %h, src1: %h, src2: %h, alucontrol: %h, aluResult: %h", $time, param1, param2, ALUControl, aluResult);
    // end

endmodule // alu
