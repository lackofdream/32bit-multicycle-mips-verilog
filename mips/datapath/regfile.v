module regfile #(parameter WIDTH = 32, ADDR_WIDTH = 5) (
    input clk, reset,
    input regWrite,
    input [ADDR_WIDTH-1 : 0] readAddr1, readAddr2, writeAddr,
    input [WIDTH-1      : 0] writeData,
    output [WIDTH-1     : 0] readData1, readData2
    );

    integer i;
    reg [WIDTH-1 : 0] MEM[0:(1<<ADDR_WIDTH)-1];

    assign readData1 = MEM[readAddr1];
    assign readData2 = MEM[readAddr2];

    always @ (posedge clk) begin
        if (reset)
            for (i=0;i<(1<<ADDR_WIDTH);i++)
                MEM[i] <= 0;
        else if (regWrite)
            MEM[writeAddr] <= writeData;
    end

    always @ ( posedge clk ) begin
        $display("[regfile] time: %h, regWrite: %b, writeAddr: %h, writeData: %h, $t0: %h, $t1: %h, $t2: %h, $t3: %h", $time, regWrite, writeAddr, writeData, MEM[8], MEM[9], MEM[10], MEM[11]);
    end



endmodule // regfile

//
// module regfile_tb ();
//
//     reg clk, reset, regWrite;
//     reg [4:0] ra1, ra2, wa;
//     reg [31:0] wd;
//     wire [31:0] rd1, rd2;
//
//     regfile ff(clk, reset, regWrite, ra1, ra2, wa, wd, rd1, rd2);
//
//     always #5
//         clk = ~clk;
//
//     initial begin
//         $monitor("time: %d\nra1: %d  rd1: %h\nra2: %d  rd2: %h", $time, ra1, rd1, ra2, rd2);
//         clk = 0;
//         reset = 1;
//         ra1 = 8;
//         ra2 = 9;
//         wa = 10;
//         wd = 32'hdeadbeef;
//         regWrite = 0;
//         # 10 reset = 0;
//         # 10 regWrite = 1;
//         # 10 regWrite = 0;
//         # 10 ra1 = 10;
//         # 10 $finish;
//     end
//
// endmodule // regfile_tb
