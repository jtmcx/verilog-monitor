module test_display;

wire vfront, vsync, vback;
wire hfront, hsync, hback;
wire indisplay;
wire [15:0] row;
wire [15:0] col;

reg clk;

display display(
	.pixelclk(clk),
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

always #1 clk = ~clk;

initial begin
	$dumpfile("display.vcd");
	$dumpvars(0, test_display);
	clk = 0;
	#1000 $finish;
end

endmodule
