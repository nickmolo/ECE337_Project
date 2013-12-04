`timescale 1ns / 10ps

module tb_timertop();
  
  // Define parameters
	parameter CLK_PERIOD				= 6.66;
	parameter SR_CLK_PERIOD				= 4;
  parameter PIXEL_PERIOD = 40;
  
  
  reg tb_clk;
  reg tb_pixel_test;
  reg tb_sr_clk;
  reg tb_n_rst;
	reg tb_enable;
	reg tb_addr_enable;
	reg tb_flag_addr;
	reg tb_pixel_clk;
	reg tb_flag_pulse;
	reg [9:0] tb_counter_out_row;
	reg [9:0] tb_counter_out_col;
	reg [19:0] tb_counter_out_addr;

  	timertop DUT
	(
		.clk(tb_clk),
		.sr_clk(tb_sr_clk),
		.n_rst(tb_n_rst),
		.enable(tb_enable),
		.addr_enable(tb_flag_pulse),
		.flag_addr(tb_flag_addr),
		.pixel_clk(tb_pixel_clk),
		.flag_pulse(tb_flag_pulse),
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
	
	
	always
	begin : SR_CLK_GEN
		tb_sr_clk = 1'b0;
		#(SR_CLK_PERIOD / 2);
		tb_sr_clk = 1'b1;
		#(SR_CLK_PERIOD / 2);
	end
	
	always
	begin : PIXEL_CLK_GEN
		tb_pixel_test = 1'b0;
		#(PIXEL_PERIOD / 2);
		tb_pixel_test = 1'b1;
		#(PIXEL_PERIOD / 2);
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
	  #23000000;
	  tb_n_rst = 0;
	  #400;
	  tb_n_rst = 1;
	  
    
	end 
	
endmodule