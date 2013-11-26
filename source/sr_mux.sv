module sr_mux
	(
	input wire select,
	input wire sr0,
	input wire sr1,
	output wire muxout
	);

	assign muxout = (select) ? sr0 : sr1;
	
endmodule