`timescale 1ns / 10ps

module tb_timertop();
  
  // Define parameters
	parameter CLK_PERIOD				= 6.66;

  
  reg tb_clk;
  reg tb_n_rst;
	reg tb_enable;
	reg tb_flag_row;
	reg tb_flag_col;
	reg tb_flag_addr;
	reg tb_pixel_clk;
	reg [9:0] tb_counter_out_row;
	reg [9:0] tb_counter_out_col;
	reg [19:0] tb_counter_out_addr;
	

	timertop DUT
	(
		.clk(tb_clk),
		.n_rst(tb_n_rst),
		.enable(tb_enable),
		.flag_row(tb_flag_row),
		.flag_col(tb_flag_col),
		.flag_addr(tb_flag_addr),
		.pixel_clk(tb_pixel_clk),
		.counter_out_row(tb_counter_out_row),
		.counter_out_col(tb_counter_out_col),
		.counter_out_addr(tb_counter_out_addr)
	);
	
	always
	begin : CLK_GEN
		tb_clk = 1'b0;
		#(CLK_PERIOD / 2);
		tb_clk = 1'b1;
		#(CLK_PERIOD / 2);
	end
	
	initial
	begin 
		tb_n_rst = 0;
		tb_enable = 0;
	  #1;
	  tb_n_rst = 1;
	  tb_enable = 0;
	  #10;
	  tb_enable= 1;
	  
	  
    
	end 
	
endmodule