module ram #(parameter WIDTH = 32, ADDR_WIDTH = 10) (
    input clk, reset,
    input write,
    input [ADDR_WIDTH-1 : 0] addr,
    input [WIDTH-1 : 0] inData,
    output [WIDTH-1 : 0] outData
    );

    reg [WIDTH-1 : 0] RAM[0:(1<<ADDR_WIDTH)-1];
    integer i;

    assign outData = RAM[addr];

    always @ (posedge clk) begin
        if (reset) begin
            for (i=0; i<(1<<ADDR_WIDTH); i++)
                RAM[i] <= 0;
        end
        else if (write)
            RAM[addr] <= inData;
    end

endmodule // ram

//
// module ram_tb ();
//
//     reg clk, reset, memWrite;
//     reg [9:0] addr;
//     reg [31:0] inData;
//     wire [31:0] outData;
//
//     always #5
//         clk = ~clk;
//
//     ram RAM(clk, reset, memWrite, addr, inData, outData);
//
//     initial begin
//         $monitor("time: %d, addr: %h, outData: %h, write: %b", $time, addr, outData, memWrite);
//         clk = 0;
//         reset = 1;
//         memWrite = 1;
//         addr = 10'h12;
//         inData = 32'hdeadbeef;
//         # 50 reset = 0;
//         # 10 memWrite = 0;
//         inData = 32'h0000beef;
//         # 10 memWrite = 1;
//         # 10 memWrite = 0;
//         reset = 1;
//         # 10 reset = 0;
//         # 100 $finish;
//     end
//
// endmodule // ram_tb
