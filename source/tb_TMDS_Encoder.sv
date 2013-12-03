`timescale 1ns / 10ps

module tb_TMDS_Encoder();

	// Define parameters
	parameter CLK_PERIOD				= 6.66;
  parameter SR_CLK_PERIOD				= 4;

  reg tb_clk;
  reg tb_sr_clk;
  reg tb_n_rst;
  reg tb_s_rst;
  
  reg tb_D1_load;
  reg tb_D2_load;
  reg tb_S1_load;
  reg tb_S2_load;
  reg tb_L2_load;
  reg tb_SR0_load;
  reg tb_SR1_load;
  
  reg [7:0] tb_pixel_data;
  reg [9:0] tb_preamble_data;
  reg [9:0] tb_guard_data;
  reg [1:0] tb_out_sel;
  reg tb_shiftmuxsel;

  reg tb_TMDS_out;
  reg [9:0] tb_pixel_encoded;
  
  reg [7:0] decoded_pixel;
  
  reg [9:0] tb_pixel_copy;
  reg fail;
  
  integer max;
  integer i;
  integer count;
  reg [7:0] pixel_data2;
	
	TMDS_Encoder DUT
	 (
	   .clk(tb_clk),
	   .sr_clk(tb_sr_clk),
	   .n_rst(tb_n_rst),
	   .s_rst(tb_s_rst),
	   	
	   .D1_load(tb_D1_load),
	   .D2_load(tb_D2_load),
	   .S1_load(tb_S1_load),
	   .S2_load(tb_S2_load),
	   .L2_load(tb_L2_load),
	   .SR0_load(tb_SR0_load),
	   .SR1_load(tb_SR1_load),
	   
	   .pixel_data(tb_pixel_data),
	   .preamble_data(tb_preamble_data),
	   .guard_data(tb_guard_data),
	   .shiftmuxsel(tb_shiftmuxsel),
	   .out_sel(tb_out_sel),
	   
	   .TMDS_out(tb_TMDS_out),
	   
	   .pixel_encoded(tb_pixel_encoded)
	);
	
	always
	begin : CLK_GEN
		tb_clk = 1'b0;
		#(CLK_PERIOD * 1/2);
		tb_clk = 1'b1;
		#(CLK_PERIOD * 1/2);
	end
	
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
	  #10;
	  tb_pixel_data = 8'b01010101;
	  tb_n_rst = 1'b0;
	  tb_s_rst = 1'b0;
	  fail = 1'b0;
	  #10;
	  tb_n_rst = 1'b1;
	  tb_s_rst = 1'b0;
	  #50;
	  tb_D1_load = 1'b0;
	  tb_D2_load = 1'b0;
	  tb_S1_load = 1'b0;
	  tb_S2_load = 1'b0;
	  tb_L2_load = 1'b0;
	  tb_SR0_load = 1'b0;
	  tb_SR1_load = 1'b0;
	  tb_out_sel = 2'b10;
	  tb_shiftmuxsel = 1'b1;
	  #10;
	  
	  count =0;
	  
	  max = 255;
	  for(i = 1; i < max; i = i + 1) begin
	  
	  
	  fail = 1'b0;
	  tb_pixel_data = i;
	  
	  #10;
	  
	  count = count +1;
	  tb_D1_load = 1'b0;
	  tb_D2_load = 1'b1;
	  tb_S1_load = 1'b1;
	  tb_S2_load = 1'b1;
	  tb_L2_load = 1'b1;
	  #10;
	  
	  tb_D1_load = 1'b1;
	  tb_D2_load = 1'b0;
	  tb_S1_load = 1'b0;
	  tb_S2_load = 1'b0;
	  tb_L2_load = 1'b0;
	  #10;
	  tb_D1_load = 1'b0;
	  tb_SR0_load = 1'b1;
	  
	  //#10;
	  
	  tb_SR0_load = 1'b0;
	  
	  tb_pixel_copy = tb_pixel_encoded;
	  //#10;
	  
	  if(tb_pixel_copy[9] == 1'b1) begin
	    tb_pixel_copy[7:0] = ~tb_pixel_copy[7:0];
	  end
	  
	  if(tb_pixel_encoded[8] == 1'b1) begin
	    decoded_pixel[0] = tb_pixel_copy[0];
      decoded_pixel[1] = tb_pixel_copy[1] ^ tb_pixel_copy[0];
      decoded_pixel[2] = tb_pixel_copy[2] ^ tb_pixel_copy[1];
      decoded_pixel[3] = tb_pixel_copy[3] ^ tb_pixel_copy[2];
      decoded_pixel[4] = tb_pixel_copy[4] ^ tb_pixel_copy[3];
      decoded_pixel[5] = tb_pixel_copy[5] ^ tb_pixel_copy[4];
      decoded_pixel[6] = tb_pixel_copy[6] ^ tb_pixel_copy[5];
      decoded_pixel[7] = tb_pixel_copy[7] ^ tb_pixel_copy[6];
	  end else begin
	    decoded_pixel[0] = tb_pixel_copy[0];
      decoded_pixel[1] = tb_pixel_copy[1] ~^ tb_pixel_copy[0];
      decoded_pixel[2] = tb_pixel_copy[2] ~^ tb_pixel_copy[1];
      decoded_pixel[3] = tb_pixel_copy[3] ~^ tb_pixel_copy[2];
      decoded_pixel[4] = tb_pixel_copy[4] ~^ tb_pixel_copy[3];
      decoded_pixel[5] = tb_pixel_copy[5] ~^ tb_pixel_copy[4];
      decoded_pixel[6] = tb_pixel_copy[6] ~^ tb_pixel_copy[5];
      decoded_pixel[7] = tb_pixel_copy[7] ~^ tb_pixel_copy[6];
    end
	   
	  //#10;
	  pixel_data2 = i -2;
	  
	  assert( decoded_pixel == pixel_data2) begin
	    $display("it works");
	  end else begin
	    $error("it fails!");
	    fail = 1'b1;
	  end
	  
	  //#10;
	  
	  end
	end

endmodule
