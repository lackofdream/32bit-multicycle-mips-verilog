module signextend (
    input [15  : 0] srcImm,
    output [31 : 0] res
    );

    assign res = {{16{srcImm[15]}}, srcImm};

endmodule // signextend

//
// module signextend_tb ();
//     reg [15:0] imm;
//     wire [31:0] out;
//
//     signextend se(imm, out);
//
//     initial begin
//         $monitor("imm: %b\nout: %b", imm, out);
//         imm = 16'hbeef;
//         imm = 16'h7ead;
//     end
//
// endmodule // signextend_tb
