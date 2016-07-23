module leftshift2 #(parameter WIDTH = 32) (
    input [WIDTH-1  : 0] src,
    output [WIDTH-1 : 0] out
    );

    assign out = src << 2;

endmodule // leftshift2

//
// module leftshift2_tb ();
//
//     reg [31:0] src;
//     wire [31:0] out;
//
//     leftshift2 ls2(src, out);
//
//     initial begin
//         $monitor("src: %b(%h)\nout: %b(%h)", src, src, out, out);
//         # 10
//         src = 32'h80000000;
//         # 10
//         src = 32'hdeadbeef;
//         # 10
//         src = 32'hffffffff;
//         # 10
//         src = 32'h00000000;
//         # 10
//         src = 32'h80000001;
//         # 10
//         src = 32'h80000000;
//     end
//
// endmodule // leftshift2_tb
