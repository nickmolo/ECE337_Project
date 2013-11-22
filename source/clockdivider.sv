module clockdivider
	(
	input wire clk,
	input wire n_rst,
	input wire enable,
	output reg flag
	);
	
	reg [2:0] cnt;
	reg clk_out;

	
	
	always @ (posedge clk, negedge n_rst) begin
		if( n_rst == 1'b0) begin
			//reset everything
			cnt <= 0;
			clk_out <= 0;
		end else begin
			
			flag <= clk_out;
							
			if (cnt == 3) begin
				cnt <= 0;
				clk_out <= ~clk_out;
			end else begin
				cnt <= cnt +1;
			end
		end
	end



endmodule
