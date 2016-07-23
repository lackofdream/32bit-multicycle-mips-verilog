module alu #(parameter WIDTH = 32) (
    input clk, reset,
    input [WIDTH-1:0] param1, param2,
    input [4:0] ALUControl,
    output zero,
    output reg [WIDTH-1:0] aluResult
    );

    assign zero = (aluResult == 32'b0) ? 1'b1 : 1'b0;

    always @ ( * ) begin
        if (reset) aluResult <= 32'b0;
        else begin
            case (ALUControl)
                5'b00010: aluResult <= param1 + param2;
            endcase
        end
    end

    always @ ( * ) begin
        $display("[alu] time: %h, src1: %h, src2: %h, alucontrol: %h, aluResult: %h", $time, param1, param2, ALUControl, aluResult);
    end

endmodule // alu
