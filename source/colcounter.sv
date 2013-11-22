module colcounter
	(
	input wire clk,
	input wire n_rst,
	input wire enable,
	input wire pixel_clk,
	output reg [9:0] countout,
	output reg flag
	);
	  
	edge_counter #(10) COL(
		.clk(clk),
		.n_rst(n_rst),
		.count_enable(enable),
		.in_edge(pixel_clk),
		.rollover_val(10'b1100100000),
		.count_out(countout),
		.rollover_flag(flag)
	);

endmodule