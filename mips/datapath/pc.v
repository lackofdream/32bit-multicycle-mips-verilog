`ifdef IVERILOG
`include "misc/dff.v"
`endif

`ifndef _PC
`define _PC

module PC (
    input                clk, reset,
    input       [31 : 0] next_ins,
    input                PCWrite,
    output wire [31 : 0] ins
    );

    dff pc(clk, reset, PCWrite, next_ins, ins);

endmodule // PC

`endif
