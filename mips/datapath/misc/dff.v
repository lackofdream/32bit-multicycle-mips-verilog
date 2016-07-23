module dff #(parameter WIDTH = 32) (
    input clk, reset, en,
    input      [WIDTH-1 : 0] d,
    output reg [WIDTH-1 : 0] q
    );

    always @ (posedge clk) begin
        if (reset)
            q <= {(WIDTH-1) {1'b0}};
        else if (en)
            q <= d;
    end

endmodule // dff

//
// module dff_tb ();
//
//     reg clk, reset, en;
//     reg [31  : 0] d;
//     wire [31 : 0] q;
//
//     dff DFF(clk, reset, en, d, q);
//
//     initial begin
//         $monitor("time: %d q: %h", $time, q);
//         clk   = 0;
//         en    = 1;
//         reset = 1;
//         d     = 32'hdeadbeef;
//         # 50 reset = 0;
//         # 100 $finish;
//     end
//
//     always #5
//         clk = ~clk;
//
// endmodule // dff_tb
