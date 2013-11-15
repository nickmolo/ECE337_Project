`timescale 1ns / 10ps

module tb_hs_sr();
  
  // Define parameters
parameter CLK_PERIOD = 4;
  
  
  reg tb_clk;
  reg tb_n_rst;
  reg tb_shift_enable;
  reg tb_load_enable;
  reg [9:0] tb_parallel_in;
  reg tb_serial_out;
  
  always
  		begin : CLK_GEN
  			tb_clk = 1'b0;
  			#(CLK_PERIOD / 2);
  			tb_clk = 1'b1;
  			#(CLK_PERIOD / 2);
		end
 
	hs_sr DUT
	(
		.clk(tb_clk),
		.n_rst(tb_n_rst),
		.shift_enable(tb_shift_enable),
		.load_enable(tb_load_enable),
		.parallel_in(tb_parallel_in),
		.serial_out(tb_serial_out)
	);
	
	
	 
  initial begin
  	tb_n_rst = 1;
  	tb_shift_enable = 0;
  	tb_load_enable = 0;
  	tb_parallel_in = 10'b1111001111;
  	
  	#10;
  	
	 tb_n_rst = 0;
  	tb_shift_enable = 0;
  	tb_load_enable = 1;
  	tb_parallel_in = 10'b1111001111;
  	
  	#4;
  	tb_load_enable = 0;
  	
  	#10;
  	
  	tb_shift_enable = 1;
  	
  	#36;
  	tb_parallel_in = 10'b0001111100;
  	tb_load_enable = 1;
  	
  	#4;
  	tb_load_enable = 0;
  	
  	#44;
  	
 	end
 	
  	
  	
endmodule
  	
  	