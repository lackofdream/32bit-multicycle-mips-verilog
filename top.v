module top (
    input clk, reset,
    input [15:0] switches,
    output [15:0] leds
    );

    wire [31:0] memData, writeMemData;
    wire MemWrite;
    wire [1:0] MemMode;
    wire [15:0] memAddr;

    mips _mips(clk, reset, memData, MemWrite, MemMode, writeMemData, memAddr);

    exmemory _ex_mem(clk, reset, MemWrite, MemMode, memAddr, writeMemData, switches, leds, memData);


endmodule // top


module top_tb ();
    reg clk, reset;
    reg [15:0] switches;
    wire [15:0] leds;
    top _top(clk, reset, switches, leds);

    always #5
        clk = ~clk;

    initial begin
        clk = 0;
        reset = 0;
        switches = 16'h0004;
        # 10 reset = 1;
        # 20 reset = 0;
        # 10000 $finish;
    end

    always @ ( * ) begin
        $display("[top] time: %h, leds: %h", $time, leds);
    end


endmodule // top_tb
