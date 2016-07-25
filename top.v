module top (
    input clk, reset,
    input [15  : 0] switches,
    input btn_u, btn_d, btn_l, btn_r,
    output [15 : 0] leds,
    output [3  : 0] disp_sel,
    output [7  : 0] disp_dig
    );

    wire [31:0] memData, writeMemData;
    wire MemWrite;
    wire [1:0] MemMode;
    wire [15:0] memAddr;

    mips _mips(clk, reset, memData, MemWrite, MemMode, writeMemData, memAddr);

    exmemory _ex_mem(clk, reset, MemWrite, MemMode, memAddr, writeMemData, switches, btn_u, btn_d, btn_l, btn_r, leds, disp_sel, disp_dig, memData);


endmodule // top


module top_tb ();
    reg clk, reset;
    reg [15:0] switches;
    wire [15:0] leds;
    wire [3:0] disp_sel;
    wire [7:0] disp_dig;
    reg btn_u, btn_d, btn_l, btn_r;
    top _top(clk, reset, switches, btn_u, btn_d, btn_l, btn_r, leds, disp_sel, disp_dig);

    always #5
        clk = ~clk;

    initial begin
        $dumpvars(0, _top);
        clk = 0;
        reset = 0;
        btn_u = 0;
        btn_d = 0;
        btn_l = 0;
        btn_r = 0;
        switches = 16'h1000;
        # 100 reset = 1;
        # 200 reset = 0;
        # 500 btn_u = 1;
        # 10 btn_u = 0;
        # 100 btn_d = 1;
        # 10 btn_d = 0;
        # 500 btn_l = 1;
        # 10 begin
            btn_l = 0;
            switches = 16'hbeef;
        end
        # 100 btn_d = 1;
        # 10 btn_d = 0;
        # 100 switches = 16'h1000;
        # 100 btn_r = 1;
        # 10 btn_r = 0;
        # 100 btn_d = 1;
        # 10 btn_d = 0;

        # 1000 $finish;
    end


endmodule // top_tb
