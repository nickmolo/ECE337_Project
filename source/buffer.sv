//Filename: buffer.sv
//Description: Designed as a flexible use case register buffer

module buffer
	#(NUMBITS=8
	)
	(
	input wire clk,
	input wire n_rst,
	input wire load_enable,
	input wire [NUMBITS-1:0] p_in,
	output wire [NUMBITS-1:0] p_out
	);

	reg [NUMBITS-1:0] buffer;
	
	always @ (posedge clk, negedge n_rst) begin
		if ( n_rst == 1'b0 ) begin
			buffer[NUMBITS-1:0] <= {NUMBITS{1'b0}}; 					//reset all registers to zero
		end else begin

			if ( load_enable == 1'b1 ) begin
				buffer[NUMBITS-1:0] <= p_in;
			end

		end
	end

	assign p_out = buffer;
endmodule
