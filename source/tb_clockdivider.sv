//Filename: tb_clockdivider.sv
//Description: Test bench for the timer block

`timescale 1ns / 10ps

module tb_clockdivider();
  
  // Define parameters
	parameter CLK_PERIOD				= 6.66;

  
  reg tb_clk;
  reg tb_n_rst;
	reg tb_enable;
	reg tb_flag;

	clockdivider DUT
	(
		.clk(tb_clk),
		.n_rst(tb_n_rst),
		.enable(tb_enable),
		.flag_pulse(tb_flag)
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
