module button (
    input clk, reset,
    input btn_u, btn_d, btn_l, btn_r,
    // 0: Wait for operation
    // 1: Wait for address input to write ram
    // 2: Wait for address input to read ram
    // 3: Wait for data input to write ram

    output reg [1:0] IOState
    );

    initial begin
        IOState = 0;
    end

    always @ (posedge clk) begin
        if (reset | btn_d) IOState <= 2'b00;
        else if (btn_u) IOState    <= 2'b01;
        else if (btn_l) IOState    <= 2'b11;
        else if (btn_r) IOState    <= 2'b10;
    end

endmodule // button


module button_tb ();
    reg clk, reset;
    reg btn_u, btn_d, btn_l, btn_r;
    wire [1:0] IOState;

    button _button(clk, reset, btn_u, btn_d, btn_l, btn_r, IOState);


    initial begin
        $dumpvars(0, _button);
        clk =  0;
        btn_u = 0;
        btn_d = 0;
        btn_l = 0;
        btn_r = 0;
        # 20 reset = 1;
        # 10 reset = 0;
        # 20 btn_u = 1;
        # 10 btn_u = 0;
        # 500 btn_d = 1;
        # 10 btn_d = 0;
        # 10 btn_d = 1;
        # 10 btn_d = 0;
        # 20 btn_l = 1;
        # 10 btn_l = 0;
        # 500 btn_d = 1;
        # 10 btn_d = 0;
        # 20 btn_r = 1;
        # 10 btn_r = 0;
        # 50 btn_d = 1;
        # 10 btn_d = 0;
        # 50 $finish;
    end

    always #5
        clk = ~clk;

endmodule // button_tb
