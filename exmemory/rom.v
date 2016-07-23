`ifndef _ROM
`define _ROM

module rom #(parameter WIDTH = 32, ADDR_WIDTH = 10) (
    input [ADDR_WIDTH-1 : 0] addr,
    output [WIDTH-1     : 0] data
    );

    reg [WIDTH-1 : 0] ROM[0:(1<<ADDR_WIDTH)-1];

    initial begin
        $display("initialize rom...");
        $readmemh("/home/g/Desktop/mips.hex", ROM);
    end

    assign data = ROM[addr];

endmodule // rom

//
// module rom_tb ();
//     reg [9:0] addr;
//     wire [31:0] data;
//
//     rom ROM(addr, data);
//
//     initial begin
//         $monitor("addr: %h    data: %h", addr, data);
//         addr <= 10'h0;
//         # 10 addr <= 10'h1;
//         # 10 $finish;
//     end
//
//
//
// endmodule // rom_tb

`endif
