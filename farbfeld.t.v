`timescale 1ns / 1ns

module test_farbeld;

reg ready;
reg [7:0] data;
wire [31:0] row;
wire [31:0] col;
wire [15:0] red;
wire [15:0] green;
wire [15:0] blue;
wire pixelready;
   
farbfeld farbfeld(
    .ready(ready),
    .data(data),
    .row(row),
    .col(col),
    .red(red),
    .green(green),
    .blue(blue),
    .pixelready(pixelready)
);

reg [32:0] i;
reg [63:0] magic;

initial begin
    $dumpfile("farbfeld.vcd");
    $dumpvars(0, test_farbeld);

    data = 0;
    ready = 0;

    magic = "dlefbraf";
    for (i = 0; i < 8; i = i + 1) begin
        #5 data = magic >> (i * 8);
        #5 ready = 1;
        #5 ready = 0;
    end

    // Width of "2"
    for (i = 0; i < 4; i = i + 1) begin
        #5 data = i + 1; //(i == 3) ? 2 : 0;
        #5 ready = 1;
        #5 ready = 0;
    end

    // Height of "3"
    for (i = 0; i < 4; i = i + 1) begin
        #5 data = i + 1; //(i == 3) ? 3 : 0;
        #5 ready = 1;
        #5 ready = 0;
    end

    for (i = 0; i < 100; i = i + 1) begin
        #5 data = i;
        #5 ready = 1;
        #5 ready = 0;
    end

    #10 $finish;
end

endmodule
