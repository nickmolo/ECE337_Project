module hs_sr
	(
	input wire clk,
	input wire n_rst,
	input wire shift_enable,
	input wire load_enable,
	input wire [9:0] parallel_in,
	output wire serial_out
	);

	reg [7:0] buffer

	always @ (posedge clk, negedge n_rst) begin
		if ( n_rst == 1'b1 ) begin
			buffer[9:0] <= {10{1'b0}}; 					//reset all registers to zero
		end else begin

			if ( load_enable == 1'b1 ) begin
				buffer[9:0] <= parallel_in;
			end

			if( shift_enable == 1'b1 ) begin
				buffer[9:0] <= {1'b0, buffer[9:1]}; 	//LSB currently
			end

		end
	end

	assign serial_out = buffer[9];
endmodule