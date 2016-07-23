module mux4 #(parameter WIDTH = 32) (
    input      [WIDTH-1 : 0] data1,
    input      [WIDTH-1 : 0] data2,
    input      [WIDTH-1 : 0] data3,
    input      [WIDTH-1 : 0] data4,
    input      [      1 : 0] select,
    output reg [WIDTH-1 : 0] out
    );

    always @ ( * ) begin
        case (select)
            2'b00: out <= data1;
            2'b01: out <= data2;
            2'b10: out <= data3;
            2'b11: out <= data4;
        endcase
    end

endmodule // mux2

//
// module mux4_tb;
//
//     reg [31 : 0]  data1  = 32'hdeadbeef;
//     reg [31 : 0]  data2  = 32'hbeefdead;
//     reg [31 : 0]  data3  = 32'h0000beef;
//     reg [31 : 0]  data4  = 32'hdead0000;
//     reg [ 1 : 0]  select = 2'b00;
//     wire [31 : 0] out;
//
//     mux4 m4 (data1, data2, data3, data4, select, out);
//
//     initial begin
//         $monitor("data1: %h data2: %h\ndata3: %h data4: %h\nselect: %d out: %h", data1, data2, data3, data4, select, out);
//         # 10 select = 2'b01;
//         # 10 select = 2'b10;
//         # 10 select = 2'b11;
//         # 10 $finish;
//     end
//
// endmodule
