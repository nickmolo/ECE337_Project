module addresscounter
	(
	input wire clk,
	input wire n_rst,
	input wire enable,
	input wire pixel_clk,
	output reg [19:0] countout,
	output reg flag
	);

	
	  
	flex_counter #(20) addr(
		.clk(clk),
		.n_rst(n_rst),
		.count_enable(enable),
		.rollover_val(20'h4afff),
		.count_out(countout),
		.rollover_flag(flag)
	);

endmodule