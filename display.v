module display(
    input pixelclk,
    output vfront,
    output vsync,
    output vback,
    output hfront,
    output hsync,
    output hback,
    output indisplay,
    output reg [31:0] row,
    output reg [31:0] col
);

localparam 
    HDISPLAY = 720,
    HFRONT   = 736,
    HSYNC    = 854,
    HBACK    = 880;

localparam 
    VDISPLAY = 350,
    VFRONT   = 353,
    VSYNC    = 365,
    VBACK    = 370;

wire vdisplay, hdisplay;

initial begin
    col = 0;
    row = 0;	
end

assign vdisplay = (0        <= row) && (row < VDISPLAY);
assign vfront   = (VDISPLAY <= row) && (row < VFRONT); 
assign vsync    = (VFRONT   <= row) && (row < VSYNC); 
assign vback    = (VSYNC    <= row) && (row < VBACK); 

assign hdisplay = (0        <= col) && (col < HDISPLAY);
assign hfront   = (HDISPLAY <= col) && (col < HFRONT); 
assign hsync    = (HFRONT   <= col) && (col < HSYNC); 
assign hback    = (HSYNC    <= col) && (col < HBACK); 

assign indisplay = hdisplay & vdisplay;

always @(posedge pixelclk) begin
    if (col == HBACK - 1) begin
        if (row == VBACK - 1)
            row <= 0;
        else 
            row <= row + 1;
        col <= 0;
    end else begin
        col <= col + 1;
    end
end

endmodule
