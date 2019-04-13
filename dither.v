module dither(
    input [31:0] row,
    input [31:0] col,
    input [15:0] pixelin,
    output pixelout
);

wire [5:0] index;
reg [15:0] matrix [0:63];

initial begin
    $readmemh("bayer.rom", matrix);
end

assign index = {row[2:0], col[2:0]};
assign pixelout = matrix[index];

endmodule
