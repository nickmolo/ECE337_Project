module shift_top
	(
	input wire clk,
	input wire n_rst,
	input wire shift_enable,
	input wire load_enable,
	input wire [9:0] parallel_in,
	input wire select,
	output wire output
	)

	reg s0_out;
	reg s1_out;

	hr_sv S0(
			.clk(clk),
			.n_rst(n_rst),
			.shift_enable(shift_enable),
			.load_enable(!load_enable),
			.parallel_in(parallel_in),
			.serial_out(s0_out)
	)

	hr_sv S1(
			.clk(clk),
			.n_rst(n_rst),
			.shift_enable(!shift_enable),
			.load_enable(load_enable),
			.parallel_in(parallel_in),
			.serial_out(s1_out)
	)

	sr_mux MUX(
				.select(select),
				.sr0(s0_out),
				.sr1(s1_out),
				.output(output)
	)

endmodule
