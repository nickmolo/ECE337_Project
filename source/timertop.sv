module timertop
		(
			input clk,
			input n_rst,
			input enable,
			input addr_enable,
			output reg flag_row,
			output reg flag_col,
			output flag_addr,
			output pixel_clk,
			output flag_pulse,
			output [9:0] counter_out_col,
			output [9:0] counter_out_row,
			output [19:0] counter_out_addr
		);
		
		clockdivider DIVIDE2
			(
				.clk(clk),
				.n_rst(n_rst),
				.enable(enable),
				.flag_pixel(pixel_clk),
				.flag_pulse(flag_pulse)
			);
		
		flex_counter #(10) COL
			(
				.clk(clk),
				.n_rst(n_rst),
				.count_enable(enable),
				.rollover_val(10'h31f),
				.count_out(counter_out_col),
				.rollover_flag(flag_col)
			);
			
		flex_counter #(10) ROW
			(
				.clk(clk),
				.n_rst(n_rst),
				.count_enable(enable),
				.rollover_val(10'h20c),
				.count_out(counter_out_row),
				.rollover_flag(flag_row)
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