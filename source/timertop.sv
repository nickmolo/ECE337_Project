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
			
		reg [9:0] X;
		reg [9:0] Y;
	
		assign counter_out_col = X;
		assign counter_out_row = Y;
	
		
		
		always @(posedge pixel_clk) begin
			if (X==799) begin
				X <= 0;
			end else begin
				X <= X+1;
			end
		end
		
		
		always @(posedge pixel_clk) begin
			if(X == 799) begin
				if(Y == 524) begin
					Y <= 0;
				end else begin
					Y <= Y + 1;
				end
			end
		end
		
			
/*		rowcounter ROW
		(
		.clk(clk),
		.n_rst(n_rst),
		.enable(enable),
		.pixel_clk(flag_col),
		.countout(counter_out_row),
		.flag(flag_row)
		);
		
		colcounter COL
		(
		.clk(clk),
		.n_rst(n_rst),
		.enable(enable),
		.pixel_clk(pixel_clk),
		.countout(counter_out_col),
		.flag(flag_col)
		);
*/		
		addresscounter ADDR
		(
			.clk(clk),
			.n_rst(n_rst),
			.enable(enable),
			.pixel_clk(pixel_clk),
			.countout(counter_out_addr),
			.flag(flag_addr)
		);
			
endmodule