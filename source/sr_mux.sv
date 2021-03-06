//Filename: sr_mux.sv
//Description: A simple 2:1 mux

module sr_mux
	(
	input wire select,
	input wire sr0,
	input wire sr1,
	output wire muxout
	);

	assign muxout = (select) ? sr1 : sr0;
	
endmodule
