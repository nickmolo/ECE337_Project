module clockdivider
	(
	input wire clk,
	input wire n_rst,
	input wire enable,
	output reg flag_pixel,
	output reg flag_pulse
	);
	
	reg [2:0] cnt;
	reg [2:0] cnt2;

	
	
	always @ (posedge clk, negedge n_rst) begin
		if( n_rst == 1'b0) begin
			//reset everything
			cnt <= 0;
			cnt2 <= 0;
			flag_pixel <= 0;
			flag_pulse <=0;
		end else begin
			
			if(enable == 1) begin
				
				if (cnt == 3) begin
					cnt <= 0;
					flag_pixel <= ~flag_pixel;
				end else begin
					cnt <= cnt +1;
				end
				
				if (cnt2 == 6) begin
					cnt2 <= 0;
					flag_pulse <= 1;
				end else begin
					flag_pulse <= 0;
					cnt2 <= cnt2 +1;
				end
						
		end
		
	end
end


endmodule
