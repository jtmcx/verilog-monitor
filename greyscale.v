
module greyscale(
    input [15:0] red,
    input [15:0] green,
    input [15:0] blue,
    output [15:0] grey
);

assign grey = red * 7/32 + green * 23/32 + blue * 2/32;

endmodule
