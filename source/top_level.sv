module top_level
	(
		input clk,
		input n_rst,
		input enable,
		
		output pixel_clk,
		
		output reg p_tmds0
		output reg p_tmds1,
		output reg p_tmds2,
		
		output reg n_tmds0,
		output reg n_tmds1,
		output reg n_tmds2
	);
	
	
	reg tmds0;
	reg tmds1;
	reg tmds2;
	
	timertop timers
		(
			.clk(clk),
			.n_rst(n_rst),
			enable(enable),
			.flag_row(flag_row),
			.flag_col(flag_col),
			.flag_addr(flag_addr),
			.pixel_clk(pixel_clk),
			.flag_pulse(flag_pulse),
			.counter_out_col(counter_out_col),
			.counter_out_row(counter_out_row),
			.counter_out_addr(counter_out_addr)
		);
		
	


endmodule