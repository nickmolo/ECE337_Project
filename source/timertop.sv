module timertop
		(
			input clk,
			input n_rst,
			input s_rst,
			input enable,
			
			output flag_row,
			output flag_col,
			output pixel_clk,
			output [9:0] counter_out_col,
			output [9:0] counter_out_row
		);
		
		clockdivider DIVIDE2
			(
				.clk(clk),
				.n_rst(n_rst),
				.s_rst(s_rst),
				.enable(enable),
				.flag(pixel_clk)
			);
			
			
		rowcounter ROW
		(
		.clk(clk),
		.n_rst(n_rst),
		.s_rst(s_rst),
		.enable(enable),
		.pixel_clk(pixel_clk),
		.countout(counter_out_row),
		.flag(flag_row)
		);
		
		colcounter COL
		(
		.clk(clk),
		.n_rst(n_rst),
		.s_rst(s_rst),
		.enable(enable),
		.pixel_clk(pixel_clk),
		.countout(counter_out_col),
		.flag(flag_col)
		);
			
endmodule