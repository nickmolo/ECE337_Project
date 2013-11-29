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
	wire tb_TMDS_1p;
	wire tb_TMDS_1n;
	wire tb_TMDS_2p;
	wire tb_TMDS_2n;
	wire tb_pixelclk;
	
	//inputs
	reg tb_data_ready;
	reg tb_frame_done;
	reg [23:0]tb_data_line;
	
	
	always
	begin : CLK_GEN
		tb_sys_clk = 1'b1;
		#(CLK_PERIOD / 2);
		tb_sys_clk = 1'b0;
		#(CLK_PERIOD / 2);
	end

	always
	begin : CLK_GEN_2
		tb_sr_clk = 1'b0;
		#(SR_CLK_PERIOD / 2);
		tb_sr_clk = 1'b1;
		#(SR_CLK_PERIOD / 2);
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
	
    while(1) begin
	  
      if(tb_read_request == 1'b1) begin
	     
        @(posedge tb_sys_clk);
	     
        tb_data_ready = 1;
	     
        @(posedge tb_sys_clk);
        @(posedge tb_sys_clk);
	     
      end
    
      tb_data_ready = 0;
      tb_data_line = tb_data_line + 1;
      
      @(posedge tb_sys_clk);
	
    end
  end
	
	
	
endmodule
