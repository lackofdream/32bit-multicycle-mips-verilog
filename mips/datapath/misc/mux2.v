module mux2 #(parameter WIDTH = 32) (
    input  [WIDTH-1 : 0] data1,
    input  [WIDTH-1 : 0] data2,
    input                select,
    output [WIDTH-1 : 0] out
    );

    assign out = select ? data2 : data1;

endmodule // mux2

//
// module mux2_tb;
//
//     reg [31 : 0] data1 = 32'hdeadbeef;
//     reg [31 : 0] data2 = 32'hbeefdead;
//     reg select         = 1'b0;
//     wire [31 : 0] out;
//
//     mux2 m2(data1, data2, select, out);
//
//     initial begin
//         $monitor("data1: %h data2: %h select: %b out: %h", data1, data2, select, out);
//         # 10 select = 1'b1;
//         # 10 $finish;
//     end
//
// endmodule
