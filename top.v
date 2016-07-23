module top (
    input clk, reset
    );

    wire [31:0] memData, writeMemData;
    wire MemWrite;
    wire [1:0] MemMode;
    wire [15:0] memAddr;

    mips _mips(clk, reset, memData, MemWrite, MemMode, writeMemData, memAddr);

    exmemory _ex_mem(clk, reset, MemWrite, MemMode, memAddr, writeMemData, memData);


endmodule // top


module top_tb ();
    reg clk, reset;

    top _top(clk, reset);

    always #5
        clk = ~clk;

    initial begin
        clk = 0;
        reset = 0;
        # 10 reset = 1;
        # 20 reset = 0;
        # 200 $finish;
    end


endmodule // top_tb
