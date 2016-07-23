module exmemory #(parameter WIDTH = 32, ADDR_WIDTH = 16) (
    input clk, reset,
    // ========= Signal from Controller =========
    input MemWrite,
    input [ADDR_WIDTH-1 : 0] memAddr,
    input [WIDTH-1      : 0] memWriteData,
    output reg [WIDTH-1 : 0] memReadData
    );

    wire [31 : 0] romData;
    wire [31 : 0] ramData;
    wire RamWrite;

    assign RamWrite = ~reset & MemWrite & (memAddr[15:12]==4'h1);

    rom ROM(memAddr[11:2], romData);
    ram RAM(clk, reset, RamWrite, memAddr[11:2], memWriteData, ramData);

    always @ (posedge clk) begin
        $display("[exmemory] time: %h, read %h", $time, memAddr);
        case (memAddr[15:12])
            4'h0: begin
                memReadData <= romData;
                $display("[exmemory] read from ROM(%h), got %h", memAddr, memReadData);
            end
            4'h1: begin
                memReadData <= ramData;
                $display("[exmemory] read from RAM(%h), got %h", memAddr, memReadData);
            end
            4'hf: $display("[exmemory] read I/O device");
        endcase
        if (~reset && MemWrite && ~RamWrite)
            $display("[exmemory] write to I/O device");
    end


endmodule // exmemory

//
// module exmemory_tb ();
//
//     reg clk, reset, MemWrite;
//     reg [15:0] addr;
//     reg [31:0] inData;
//     wire [31:0] outData;
//
//     exmemory mem(clk, reset, MemWrite, addr, inData, outData);
//
//     always #5
//         clk = ~clk;
//
//     initial begin
//         $display("in exmemory_tb");
//         $monitor("time: %d, addr: %h, outData: %h", $time, addr, outData);
//         clk = 0;
//         reset = 1;
//         MemWrite = 0;
//         addr = 16'h1000;
//         inData = 32'hdeadbeef;
//         # 10 reset = 0;
//         # 10 MemWrite = 1;
//         # 10 MemWrite = 0;
//         # 10 addr = 16'hff00;
//         # 10 MemWrite = 1;
//         # 10 MemWrite = 0;
//         # 10 addr = 16'h0001;
//         # 10 addr = 16'h0002;
//         # 10 addr = 16'h0004;
//         # 10 $finish;
//     end
//
// endmodule // exmemory_tb
