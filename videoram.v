module videoram(
    input clk,           // System clock.
    input we,            // Write enable.
    input [31:0] waddr,  // High 16 bits are "row", low 16 bits are "col".
    input [31:0] raddr,  // High 16 bits are "row", low 16 bits are "col".
    input wdata,         // Input data at 'waddr'.
    output rdata         // Output data from 'raddr'.
);

localparam RLOG2 = 7; //9;   // log2(350) + 1
localparam CLOG2 = 8; //10;  // log2(720) + 1

// The number of bits held in RAM.
localparam DATASIZE = 1 << (RLOG2 + CLOG2);

wire [RLOG2-1:0] wrow = waddr[RLOG2-1+16:16];
wire [CLOG2-1:0] wcol = waddr[CLOG2-1:0];
wire [RLOG2-1:0] rrow = raddr[RLOG2-1+16:16];
wire [CLOG2-1:0] rcol = raddr[CLOG2-1:0];

reg data [0:DATASIZE];
reg rdata;

initial begin
    $readmemb("videoram.rom", data);
end

// TOOD!
// always @(posedge clk) begin
//     if (we)
//         data[{wrow, wcol}] <= wdata;
// end

wire outside;
assign outside = raddr[31:RLOG2+16] != 0 || raddr[16:CLOG2] != 0;

always @(posedge clk) begin
    rdata <= outside ? 0 : data[{rrow, rcol}];
end

endmodule
