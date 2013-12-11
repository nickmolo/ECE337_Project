//Filename: tb_pixel_gen.sv
//Description: Designed to test the pixel clock generation

`timescale 1ns / 10ps

module tb_pixel_gen();

	// Define parameters
	parameter CLK_PERIOD				= 6.66;
  parameter SR_CLK_PERIOD				= 4;


  reg tb_sr_clk;
  reg tb_n_rst;
  reg tb_enable;
  reg tb_flag_pixel;
  
	pixel_gen DUT
	 (
	   .clk(tb_sr_clk),
	   .n_rst(tb_n_rst),
	   .enable(tb_enable),
	   .flag_pixel(tb_flag_pixel)
	);
	
	always
	begin : SR_CLK_GEN
		tb_sr_clk = 1'b0;
		#(SR_CLK_PERIOD * 1/2);
		tb_sr_clk = 1'b1;
		#(SR_CLK_PERIOD * 1/2);
	end
 	
 	// Actual test bench process
	initial
	begin
	  #1;
	  tb_n_rst = 0;
	  #10;
	  tb_n_rst = 1;
	  tb_enable=1;
	  
	end

endmodule
