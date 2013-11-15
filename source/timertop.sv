module timertop
	(
	input wire clk,
	input wire n_rst,
	input wire s_rst,
	input wire enable,
	output reg flag,
	output reg pixel_clk,
	output reg [9:0] countout
	);
	   
	
	clockdivider DIVIDE
	(
		.clk(tb_clk),
		.n_rst(n_rst),
		.s_rst(s_rst),
		.enable(enable),
		.flag(pixel_clk)
	);

endmodule