module clockdivider
	(
	input wire clk,
	input wire n_rst,
	input wire s_rst,
	input wire enable,
	input wire pixel_clk,
	output reg flag
	);
	  
	flex_counter #(3) row(
		.clk(clk),
		.n_rst(n_rst),
		.s_rst(s_rst),
		.count_enable(pixel_clk && enable),
		.rollover_val(3'b110),
		.rollover_flag(flag)
	);

endmodule