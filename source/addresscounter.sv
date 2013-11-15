module addresscounter
	(
	input wire clk,
	input wire n_rst,
	input wire s_rst,
	input wire enable,
	input wire pixel_clk,
	output reg [19:0] countout,
	output reg flag
	);
	  
	flex_counter #(20) row(
		.clk(clk),
		.n_rst(n_rst),
		.s_rst(s_rst),
		.count_enable(pixel_clk && enable),
		.rollover_val(20'b1001011000000000000),
		.count_out(countout),
		.rollover_flag(flag)
	);

endmodule