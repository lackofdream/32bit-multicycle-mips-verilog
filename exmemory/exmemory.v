module exmemory #(parameter WIDTH = 32, ADDR_WIDTH = 16) (
    input clk, reset,
    // ========= Signal from Controller =========
    input MemWrite,
    input [1            : 0] MemMode,
    input [ADDR_WIDTH-1 : 0] memAddr,
    input [WIDTH-1      : 0] memWriteData,
    // ========= I/O Devices =========
    input [15           : 0] switches,
    input [0            : 0] btn_u, btn_d, btn_l, btn_r,
    output reg [15      : 0] leds,
    output reg [3       : 0] disp_sel,
    output reg [7       : 0] disp_dig,

    output reg [WIDTH-1 : 0] memReadData
    );

    wire [31 : 0] romData;
    wire [31 : 0] ramData;
    wire RamWrite;

    wire [1:0] IOState;

    button _btn(clk, reset, btn_u, btn_d, btn_l, btn_r, IOState);

    assign RamWrite = ~reset & MemWrite & (memAddr[15:12]==4'h1);

    rom ROM(memAddr[11:2], romData);
    ram RAM(clk, RamWrite, memAddr[11:2], memWriteData, ramData);

    initial begin
        leds = 0;
        disp_sel = 4'hf;
        disp_dig = 8'hff;
    end

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
                    16'hfffb: memReadData <= {28'b0, IOState};
                endcase
            end
        endcase
    end

    always @ (posedge clk) begin
        if (reset) begin
            leds <= 0;
            disp_sel <= 4'b1111;
            disp_dig <= 8'hff;
        end else if (MemWrite && ~RamWrite) begin
            $display("[exmemory] time: %h, Write memWriteData: %h to I/O device addr: %h", $time, memWriteData[7:0], memAddr);
            case (memAddr)
                16'hfffc: leds     <= {8'bz, memWriteData[7:0]};
                16'hfffd: leds     <= {memWriteData[7:0], 8'bz};
                16'hfffa: disp_sel <= memWriteData[3:0];
                16'hfff9: disp_dig <= memWriteData[7:0];
            endcase
        end
    end

endmodule // exmemory

//
// module exmemory_tb ();
//
//     reg clk, reset, MemWrite;
//     reg [15:0] addr;
//     reg [31:0] inData;
//     wire [31:0] outData;
//     reg btn_u, btn_d, btn_l, btn_r;
//     reg [15  : 0] switches;
//     wire [15 : 0] leds;
//     wire [3  : 0] disp_sel;
//     wire [7  : 0] disp_dig;
//     reg [1:0] MemMode;
//
//     exmemory mem(clk, reset, MemWrite, MemMode, addr, inData, switches, btn_u, btn_d, btn_l, btn_r, leds, disp_sel, disp_dig, outData);
//
//     always #5
//         clk = ~clk;
//
//     initial begin
//         $dumpvars(0, mem);
//         MemMode = 0;
//         btn_u = 0;btn_d = 0;btn_l = 0;btn_r = 0;
//         switches = 0;
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
//         # 10 addr = 16'h1000;
//         # 10 addr = 16'hfffb;
//         # 200 btn_u = 1;
//         # 10 btn_u = 0;
//         # 50 btn_d = 1;
//         # 10 btn_d = 0;
//         # 10 btn_d = 1;
//         # 10 btn_d = 0;
//         # 20 btn_l = 1;
//         # 10 btn_l = 0;
//         # 50 btn_d = 1;
//         # 10 btn_d = 0;
//         # 20 btn_r = 1;
//         # 10 btn_r = 0;
//         # 50 btn_d = 1;
//         # 10 btn_d = 0;
//         # 50 $finish;
//     end
//
// endmodule // exmemory_tb
