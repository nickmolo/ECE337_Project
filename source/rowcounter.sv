module rowcounter
	(
	input wire clk,
	input wire n_rst,
	input wire enable,
	input wire pixel_clk,
	output reg [9:0] countout,
	output reg flag
	);
	  
	flex_counter #(10) row(
		.clk(clk),
		.n_rst(n_rst),
		.count_enable(pixel_clk && enable),
		.rollover_val(10'b1000001101),
		.count_out(countout),
		.rollover_flag(flag)
	);

endmodule