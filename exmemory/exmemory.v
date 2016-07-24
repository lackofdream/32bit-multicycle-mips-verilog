module exmemory #(parameter WIDTH = 32, ADDR_WIDTH = 16) (
    input clk, reset,
    // ========= Signal from Controller =========
    input MemWrite,
    input [1            : 0] MemMode,
    input [ADDR_WIDTH-1 : 0] memAddr,
    input [WIDTH-1      : 0] memWriteData,
    // ========= I/O Devices =========
    input [15           : 0] switches,
    output reg [15      : 0] leds,


    output reg [WIDTH-1 : 0] memReadData
    );

    wire [31 : 0] romData;
    wire [31 : 0] ramData;
    wire RamWrite;

    assign RamWrite = ~reset & MemWrite & (memAddr[15:12]==4'h1);

    rom ROM(memAddr[11:2], romData);
    ram RAM(clk, reset, RamWrite, memAddr[11:2], memWriteData, ramData);

    always @ ( * ) begin
        // $display("[exmemory] time: %h, mode: %b, read %h", $time, MemMode, memAddr);
        case (memAddr[15:12])
            4'h0: begin
                case (MemMode)
                    2'b00: memReadData <= romData;
                    2'b01: begin
                        case (memAddr[1:0])
                            2'b00: memReadData <= {{24{romData[7]}}, romData[7:0]};
                            2'b01: memReadData <= {{24{romData[15]}}, romData[15:8]};
                            2'b10: memReadData <= {{24{romData[23]}}, romData[23:16]};
                            2'b11: memReadData <= {{24{romData[31]}}, romData[31:24]};
                        endcase
                    end
                    2'b10: begin
                        case (memAddr[1:0])
                            2'b00: memReadData <= {24'b0, romData[7:0]};
                            2'b01: memReadData <= {24'b0, romData[15:8]};
                            2'b10: memReadData <= {24'b0, romData[23:16]};
                            2'b11: memReadData <= {24'b0, romData[31:24]};
                        endcase
                    end
                endcase
                // $display("[exmemory] read from ROM(%h), got %h", memAddr, memReadData);
            end
            4'h1: begin
                case (MemMode)
                    2'b00: memReadData <= ramData;
                    2'b01: begin
                        case (memAddr[1:0])
                            2'b00: memReadData <= {{24{ramData[7]}}, ramData[7:0]};
                            2'b01: memReadData <= {{24{ramData[15]}}, ramData[15:8]};
                            2'b10: memReadData <= {{24{ramData[23]}}, ramData[23:16]};
                            2'b11: memReadData <= {{24{ramData[31]}}, ramData[31:24]};
                        endcase
                    end
                    2'b10: begin
                        case (memAddr[1:0])
                            2'b00: memReadData <= {24'b0, ramData[7:0]};
                            2'b01: memReadData <= {24'b0, ramData[15:8]};
                            2'b10: memReadData <= {24'b0, ramData[23:16]};
                            2'b11: memReadData <= {24'b0, ramData[31:24]};
                        endcase
                    end
                endcase
                // $display("[exmemory] read from RAM(%h), got %h", memAddr, memReadData);
            end
            4'hf: begin
                case (memAddr)
                    16'hfffe: memReadData <= {24'b0, switches[7:0]};
                    16'hffff: memReadData <= {24'b0, switches[15:8]};
                endcase
            end
        endcase
    end

    always @ (posedge clk) begin
        if (~reset && MemWrite && ~RamWrite) begin
            $display("[exmemory] time: %h, Write memWriteData: %h to I/O device addr: %h", $time, memWriteData[7:0], memAddr);
            case (memAddr)
                16'hfffc: leds <= {8'bz, memWriteData[7:0]};
                16'hfffd: leds <= {memWriteData[7:0], 8'bz};
            endcase
        end
    end

    // always @ ( * ) begin
    //     $display("[exmemory] time: %h, romData: %h, ramData: %h", $time, romData, ramData);
    // end

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
