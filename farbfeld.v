`timescale 1ns / 1ns

module farbfeld(
    input ready,
    input [7:0] data,
    output reg [31:0] row,   // Current row in the image.
    output reg [31:0] col,   // Current column in the image.
    output [15:0] red,
    output [15:0] green,
    output [15:0] blue,
    output reg pixelready
);

localparam
    IDLE = 0,
    MAGIC = 1,
    WIDTH = 2,
    HEIGHT = 3,
    PIXEL = 4,
    ALPHA = 5;

reg [7:0] magic [0:7];  // The magic string "farbfeld".
reg [31:0] width;       // Width of the image.
reg [31:0] height;      // Height of the image.
reg [31:0] bread;       // Number of bytes read.
reg [47:0] pixel;       // The pixel data. Rgb values each 16 bits.
reg [2:0] state;        // FSM state.

assign red = pixel[47:32];
assign green = pixel[31:16];
assign blue = pixel[15:0];

initial begin
    width = 0;
    height = 0;
    row = 0;
    col = 0;
    bread = 0;
    pixel = 0;
    pixelready = 0;
    state = IDLE;

    magic[0] = "f";
    magic[1] = "a";
    magic[2] = "r";
    magic[3] = "b";
    magic[4] = "f";
    magic[5] = "e";
    magic[6] = "l";
    magic[7] = "d";
end


always @(posedge ready) begin
    if (state == IDLE && (magic[0] != data))
        bread <= 0;
    else
        bread <= bread + 1;
end

always @(posedge ready) begin
    case (state)

    // The "idle" state. Wait around for incoming data. Once we receive
    // an 'f', move onto the "magic" state, to listen for the rest of
    // the string "farbfeld".
    IDLE: begin
        pixelready <= 0;
        if (magic[0] == data)
            state <= MAGIC;
        else
            state <= IDLE;
    end

    // Read in the string "farbfeld". Go back to the start if we have an
    // invalid magic.
    MAGIC: begin
        if (data != magic[bread])
            state <= IDLE; // Bad magic.
        else 
            state <= (bread == 7) ? WIDTH : MAGIC;
    end

    // The "width" state. Read in the four bytes that specify the width.
    WIDTH: begin
        width <= (width << 8) | data;
        state <= (bread == 11) ? HEIGHT : WIDTH;
    end

    // The "height" state. Read in the four bytes that specify the height.
    HEIGHT: begin
        height <= (height << 8) | data;
        state <= (bread == 15) ? PIXEL : HEIGHT;
    end

    // Read in size bytes for the red, green, and blue values. Don't
    // read in the alpha value.
    PIXEL: begin
        pixelready <= 0;
        pixel <= (pixel << 8) | data;
        state <= (bread[2:0] == 5) ? ALPHA : PIXEL;
    end

    // The "alpha" state. We use these two ticks to do some house keeping 
    // for the row and column. The alpha values itself is ignored.
    ALPHA: begin
        // First byte, bupdate the column and rows.
        if (bread[0] == 0) begin
            if (col == width - 1) begin
                col <= 0;
                row <= row + 1;
            end else begin
                col <= col + 1;
            end
        end 

        // Second byte, go back to idle if we're done. Set the 'pixelready'
        // flag to high to indicate that this pixel is redy to be consumed.
        else begin
            pixelready <= 1;
            if (col == width - 1 && row == height - 1)
                state <= IDLE;
            else 
                state <= PIXEL;
        end
    end
    endcase
end

endmodule
