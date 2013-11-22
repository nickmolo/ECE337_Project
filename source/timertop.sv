module timertop
		(
			input clk,
			input n_rst,
			input enable,
			output reg flag_row,
			output reg flag_col,
			output flag_addr,
			output pixel_clk,
			output [9:0] counter_out_col,
			output [9:0] counter_out_row,
			output [19:0] counter_out_addr
		);
		
		clockdivider DIVIDE2
			(
				.clk(clk),
				.n_rst(n_rst),
				.enable(enable),
				.flag(pixel_clk)
			);
		
		edge_counter #(10) COL
			(
				.clk(clk),
				.n_rst(n_rst),
				.count_enable(enable),
				.in_edge(pixel_clk),
				.rollover_val(799),
				.count_out(counter_out_col),
				.rollover_flag(flag_col)
			);
			
		edge_counter #(10) ROW
			(
				.clk(clk),
				.n_rst(n_rst),
				.count_enable(enable),
				.in_edge(flag_col),
				.rollover_val(524),
				.count_out(counter_out_row),
				.rollover_flag(flag_row)
			);
		
		addresscounter ADDR
			(
				.clk(clk),
				.n_rst(n_rst),
				.enable(enable),
				.pixel_clk(pixel_clk),
				.colcnt(counter_out_col),
				.rowcnt(counter_out_row),
				.countout(counter_out_addr),
				.flag(flag_addr)
			);
			
endmodule