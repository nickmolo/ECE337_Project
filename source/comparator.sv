module comparator(
input wire clk,
input wire nrst,
input reg [7:0] dataIn,
output wire true
);

assign true = (dataIn > 3'b101) ? 1'b1 : 1'b0;


endmodule
