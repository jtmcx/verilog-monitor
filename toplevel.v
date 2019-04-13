module toplevel(
    input  clk,
    output hsyncout,
    output vsyncout,
    output dataout
);

wire pixelclk;

pll pll(
    .clock_in(clk),
    .clock_out(pixelclk)
);

wire vfront, vsync, vback;
wire hfront, hsync, hback;
wire indisplay;
wire [31:0] row;
wire [31:0] col;

display display(
	.pixelclk(pixelclk),
	.vfront(vfront),
	.vsync(vsync),
	.vback(vback),
	.hfront(hfront),
	.hsync(hsync),
	.hback(hback),
	.indisplay(indisplay),
	.row(row),
	.col(col)
);

wire pixeldata;

videoram videoram(
    .clk(pixelclk),
    .raddr({row[15:0], col[15:0]}),
    .rdata(pixeldata)
);

assign vsyncout = ~vsync;
assign hsyncout = hsync;
assign dataout = indisplay ? pixeldata : 0;

endmodule
