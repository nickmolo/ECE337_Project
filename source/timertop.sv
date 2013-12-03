module timertop
		(
			input clk,
			input sr_clk,
			input n_rst,
			input enable,
			input addr_enable,
	 		output flag_addr,
			output pixel_clk,
			output flag_pulse,
			output reg [9:0] counter_out_col,
			output reg [9:0] counter_out_row,
			output reg [18:0] counter_out_addr
		);

		reg flag_col;
		reg flag_row;

		clockdivider DIVIDE2
			(
				.clk(clk),
				.n_rst(n_rst),
				.enable(enable),
				.flag_pulse(flag_pulse)
			);
		
		pixel_gen PIXEL_GEN
		  (
		    .clk(sr_clk),
		    .n_rst(n_rst),
		    .enable(enable),
		    .flag_pixel(pixel_clk)
		  );
		

		flex_counter #(10) COL
			(
				.clk(clk),
				.n_rst(n_rst),
				.count_enable(flag_pulse),
				.rollover_val(10'h31f),
				.count_out(counter_out_col),
				.rollover_flag(flag_col)
			);

			flex_counter #(10) ROW
			(
				.clk(clk),
				.n_rst(n_rst),
				.count_enable(flag_pulse&&flag_col),
				.rollover_val(10'h20c),
				.count_out(counter_out_row),
				.rollover_flag(flag_row)
			);


		flex_counter #(19) addr
		  (
		    .clk(clk),
		    .n_rst(n_rst),
		    .count_enable(addr_enable),
		    .rollover_val(19'h4afff),
		    .count_out(counter_out_addr),
		    .rollover_flag(flag_addr)
	     );

endmodule