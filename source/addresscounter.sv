module addresscounter
	(
	input wire clk,
	input wire n_rst,
	input wire enable,
	input wire pixel_clk,
	input wire [9:0] colcnt,
	input wire [9:0] rowcnt,
	output reg [19:0] countout,
	output reg flag
	);
	
reg enable2;

always @(colcnt, rowcnt) begin
	if (colcnt < 160 || rowcnt < 45) begin
		enable2 <=0;
	end else begin
		enable2 <= 1;
	end
end

	
	
	  
	edge_counter #(20) addr(
		.clk(clk),
		.n_rst(n_rst),
		.count_enable(enable2),
		.in_edge(pixel_clk),
		.rollover_val(20'h4afff),
		.count_out(countout),
		.rollover_flag(flag)
	);

endmodule