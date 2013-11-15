module clockdivider
	(
	input wire clk,
	input wire n_rst,
	input wire s_rst,
	input wire enable,
	output reg flag
	);
	  
	reg [2:0] tmp;
	  
	flex_counter #(3) divide(
		.clk(clk),
		.n_rst(n_rst),
		.s_rst(s_rst),
		.count_enable(enable),
		.rollover_val(3'b110),
		.count_out(tmp),
		.rollover_flag(flag)
	);

endmodule