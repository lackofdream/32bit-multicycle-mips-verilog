module top (
    input clk, reset
    );

    wire [31:0] memData, writeMemData;
    wire MemWrite;
    wire [15:0] memAddr;

    mips _mips(clk, reset, memData, MemWrite, writeMemData, memAddr);

    exmemory _ex_mem(clk, reset, MemWrite, memAddr, writeMemData, memData);


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
