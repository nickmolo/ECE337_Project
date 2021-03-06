//Filename: tb_addresscounter.sv
//Description: Used to test the address counter rollover



`timescale 1ns / 10ps

module tb_addresscounter();
  
  // Define parameters
	parameter CLK_PERIOD				= 6.66;
	parameter PIXEL_PERIOD  = 40;
  
  reg tb_clk;
  reg tb_n_rst;
	reg tb_s_rst;
	reg tb_enable;
	reg tb_pixel_clk;
	reg [19:0] tb_countout;
	reg tb_flag;

	addresscounter DUT
	(
		.clk(tb_clk),
		.n_rst(tb_n_rst),
		.s_rst(tb_s_rst),
		.enable(tb_enable),
		.pixel_clk(tb_pixel_clk),
		.countout(tb_countout),
		.flag(tb_flag)
	);
	
	always
	begin : CLK_GEN
		tb_clk = 1'b0;
		#(CLK_PERIOD / 2);
		tb_clk = 1'b1;
		#(CLK_PERIOD / 2);
	end
	
	always
	begin : PIXEL_GEN
		tb_pixel_clk = 1'b0;
		#(PIXEL_PERIOD / 2);
		tb_pixel_clk = 1'b1;
		#(PIXEL_PERIOD / 2);
	end
	
	initial
	begin 
		tb_n_rst = 0;
	  tb_s_rst = 1;
	  tb_enable = 0;
	  #1;
	  tb_n_rst = 1;
	  tb_s_rst = 1;
	  tb_enable = 0;
	  #10;
	  tb_enable= 1;
	  
	  
    
	end 
	
endmodule
