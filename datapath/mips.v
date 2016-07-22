module mips (
    input clk, reset,
    // ========= Data from Memory =========
    input [31  : 0] memData,
    // ========= Signal to Memory =========
    output MemWrite,
    // ========= Data to Memory =========
    output [31 : 0] writeMemData,
    output [15 : 0] memAddr
    );

    

endmodule // mips
