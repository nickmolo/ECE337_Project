`timescale 1ns / 10ps

module tb_hdmi_transmitter();

	parameter CLK_PERIOD = 5.0;
	parameter PIXEL_PERIOD = 40;
	parameter SR_CLK_PERIOD = 4.0;
	
	//flip-flops
	reg tb_sys_clk;
	reg tb_sr_clk;
	reg tb_n_rst;
	
	//outputs
	reg tb_read_request;
	
	wire [19:0]tb_address_line;
	wire tb_TMDS_0p;
	wire tb_TMDS_0n;
	wire [9:0]tb_TMDS_0;
	wire tb_TMDS_1p;
	wire tb_TMDS_1n;
	wire [9:0]tb_TMDS_1;
	wire tb_TMDS_2p;
	wire tb_TMDS_2n;
	wire [9:0]tb_TMDS_2;
	wire tb_pixelclk;
	
	
	//inputs
	reg tb_data_ready;
	reg tb_frame_done;
	reg [23:0]tb_data_line;
	
	reg [7:0] decoded_pixel;
	reg [9:0] tb_pixel_copy;

	integer max;
	integer i;
	
	always
	begin : CLK_GEN
		tb_sys_clk = 1'b1;
		#(CLK_PERIOD / 2);
		tb_sys_clk = 1'b0;
		#(CLK_PERIOD / 2);
	end

	always
	begin : CLK_GEN_2
		#(SR_CLK_PERIOD / 4);
		tb_sr_clk = 1'b0;
		#(SR_CLK_PERIOD / 2);
		tb_sr_clk = 1'b1;
		#(SR_CLK_PERIOD / 4);
	end
	
	
	hdmi_transmitter hdmi_transmitter_DUT
	(
		.system_clk(tb_sys_clk),
		.sr_clk(tb_sr_clk),
    .n_rst(tb_n_rst),
    .data_ready(tb_data_ready),
    .data_line(tb_data_line),
    .frame_done(tb_frame_done),
    .address_line(tb_address_line),
    .read_request(tb_read_request),
    .TMDS_0p(tb_TMDS_0p),
    .TMDS_0n(tb_TMDS_0n),
    .TMDS_1p(tb_TMDS_1p),
    .TMDS_1n(tb_TMDS_1n),
    .TMDS_2p(tb_TMDS_2p),
    .TMDS_2n(tb_TMDS_2n),
    .pixelclk(tb_pixelclk)
	);

tb_stp_sr
	
#(
.NUM_BITS(10),
.SHIFT_MSB(0)
)
  
  stp_sr_DUT_0
(
  .clk(tb_sr_clk),
  .n_rst(tb_n_rst),
  .shift_enable(1'b1),
  .serial_in(tb_TMDS_0p),
  .parallel_out(tb_TMDS_0)
);

tb_stp_sr
	
#(
.NUM_BITS(10),
.SHIFT_MSB(0)
)
  
  stp_sr_DUT_1
(
  .clk(tb_sr_clk),
  .n_rst(tb_n_rst),
  .shift_enable(1'b1),
  .serial_in(tb_TMDS_1p),
  .parallel_out(tb_TMDS_1)
);


tb_stp_sr
	
#(
.NUM_BITS(10),
.SHIFT_MSB(0)
)
  
  stp_sr_DUT_2
(
  .clk(tb_sr_clk),
  .n_rst(tb_n_rst),
  .shift_enable(1'b1),
  .serial_in(tb_TMDS_2p),
  .parallel_out(tb_TMDS_2)
);
	
	
	initial begin : tb_proc
	  
	  tb_data_line = 0;
	  tb_data_ready = 0;
	  tb_n_rst = 1;
	  #0.1; 
	  
	  tb_n_rst = 0; 
	  
	  @(posedge tb_sys_clk);
		@(posedge tb_sys_clk);
		@(negedge tb_sys_clk);
		
		tb_n_rst = 1; 
		
		@(posedge tb_sys_clk);
		@(posedge tb_sys_clk);	
	
    max = 255;
	  for(i = 1; i < max; i=i) begin
	   
	     if(i == 254) begin 
	       i=0;
	     end
	     
	     if(tb_read_request == 1'b1) begin
	       
	    	     
	    	   //basically the tb_read_requests come in too late to be used as an indicator to pull the correct value
	    	   //by delaying it a clock cycle I can fetch it on the by the next pixel clk
	    	     
	    	  @(posedge tb_sys_clk);
	    	  @(posedge tb_sys_clk);
	    	  @(posedge tb_sys_clk);
	    	  @(posedge tb_sys_clk);
	    	  @(posedge tb_sys_clk);
	    	  @(posedge tb_sys_clk);
	    	  @(posedge tb_sys_clk);
		  @(posedge tb_sr_clk);
	    	  
	    	  
	       tb_pixel_copy = tb_TMDS_0;
	       
	       if(tb_pixel_copy[9] == 1'b1) begin
	         tb_pixel_copy[7:0] = ~tb_pixel_copy[7:0];
	       end
	       
	       if(tb_pixel_copy[8] == 1'b1) begin
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
	       
	       tb_data_line = i;
	       tb_data_ready = 1;
	       i=i+1;
  
     end
	      
        
	     
	     tb_data_ready = 0;
	     
	     @(posedge tb_sys_clk);
	   
	  end
	 
  end

endmodule
