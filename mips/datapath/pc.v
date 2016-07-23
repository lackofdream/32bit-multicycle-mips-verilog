module PC (
    input           clk, reset,
    input  [15 : 0] next_ins,
    input           PCWrite,
    output [15 : 0] ins
    );

    dff #(16) _pc(clk, reset, PCWrite, next_ins, ins);

    // always @ ( * ) begin
    //     $display("[pc] time: %h, PCWrite: %b, next_ins: %h, ins: %h", $time, PCWrite, next_ins, ins);
    // end

endmodule // PC
