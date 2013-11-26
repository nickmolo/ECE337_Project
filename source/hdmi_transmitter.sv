module hdmi_transmitter
  
  (
    input wire system_clk,
    input wire sr_clk,
    input wire n_rst,
    input wire data_ready,
    input wire [23:0]data_line,
    input wire frame_done,
    output wire [19:0]address_line,
    output wire read_request,
    output wire TMDS_0p,
    output wire TMDS_0n,
    output wire TMDS_1p,
    output wire TMDS_1n,
    output wire TMDS_2p,
    output wire TMDS_2n,
    output wire pixelclk
  );
    
    
  //signals from the output controller to the TMDS encoder block
  wire [1:0]Output_Controller_to_TMDS_outputmuxsel;
  wire Output_Controller_to_TMDS_shift1load;
  wire Output_Controller_to_TMDS_shift2load;
  wire Output_Controller_to_TMDS_shiftmuxsel;
  
  //signals from the TMDS controller to the TMDS encoder block
  wire TMDS_Controller_to_TMDS_loadD1;
  wire TMDS_Controller_to_TMDS_loadD2;
  wire TMDS_Controller_to_TMDS_loadS1;
  wire TMDS_Controller_to_TMDS_loadS2;
  wire TMDS_Controller_to_TMDS_loadL2;
  wire TMDS_Controller_to_TMDS_srst;
  
  //signals from timer block to tmds controller
  wire Timers_to_TMDS_Controller_addrrollover;
  
  //signals from timer block to both controllers
  wire Timers_to_Controllers_pixelclk;
  wire [9:0]Timers_to_Controllers_rowcount;
  wire [9:0]Timers_to_Controllers_colcount;
  
  //signals from output controller to timer block
  wire Output_Controller_to_Timers_rowtimerenable;
  wire Output_Controller_to_Timers_coltimerenable;
  
  //signals from TMDS controller to timer block
  wire TMDS_Controller_to_Timers_addrenable;
  
  //signals form TMDS controller to bitflip
  wire TMDS_Controller_to_bitflip_frameswap;
  
  //assign differential outputs
  wire channel_0_out;
  wire channel_1_out;
  wire channel_2_out;
  
  assign TMDS_0p = channel_0_out;
  assign TMDS_0n = ~channel_0_out;
  assign TMDS_1p = channel_1_out;
  assign TMDS_1n = ~channel_1_out;
  assign TMDS_2p = channel_2_out;
  assign TMDS_2n = ~channel_2_out;
  
  //create and assign preamble data
  reg [29:0]preamble_data;
  reg Hsync;
  reg Vsync;
  
  always@(*) begin
  
    preamble_data[29:20] = 10'b1101010100;
    preamble_data[19:10] = 10'b0010101011;
    
    case({Vsync, Hsync})
      
      2'b00: begin
        preamble_data[9:0] = 10'b1101010100;
      end
      
      2'b01: begin
        preamble_data[9:0] = 10'b0010101011;
      end
      
      2'b10: begin
        preamble_data[9:0] = 10'b0101010100;
      end
      
      2'b11: begin
        preamble_data[9:0] = 10'b1010101011;
      end
      
    endcase
  end
  
  //create and assign guard data
  wire [29:0]guard_data;
  
  assign guard_data[9:0] = 10'b1011001100;
  assign guard_data[19:10] = 10'b0100110011;
  assign guard_data[29:20] = 10'b1011001100;

  //create encoders
  TMDS_Encoder
  
	TMDS_channel_0
	(
	      .clk(system_clk),
	      .sr_clk(sr_clk),
	      .n_rst(n_rst),
	      .s_rst(TMDS_Controller_to_TMDS_srst),
        .pixel_data(data_line[7:0]),
        .preamble_data(preamble_data[9:0]),
        .guard_data(guard_data[9:0]),
        .shiftmuxsel(output_Controller_to_TMDS_shiftmuxsel),
        .D1_load(TMDS_Controller_to_TMDS_loadD1),
        .D2_load(TMDS_Controller_to_TMDS_loadD2),
        .S1_load(TMDS_Controller_to_TMDS_loadS1),
        .S2_load(TMDS_Controller_to_TMDS_loadS2),
        .L2_load(TMDS_Controller_to_TMDS_loadL2),
        .SR0_load(Output_Controller_to_TMDS_shift1load),
        .SR1_load(Output_Controller_to_TMDS_shift2load),
        .out_sel(Output_Controller_to_TMDS_outputmuxsel),
        .TMDS_out(channel_0_out)
	);
	
	TMDS_Encoder
	
	TMDS_channel_1
	(
	      .clk(system_clk),
	      .n_rst(n_rst),
	      .sr_clk(sr_clk),
	      .s_rst(TMDS_Controller_to_TMDS_srst),
        .pixel_data(data_line[15:8]),
        .preamble_data(preamble_data[19:10]),
        .guard_data(guard_data[19:10]),
        .shiftmuxsel(output_Controller_to_TMDS_shiftmuxsel),
        .D1_load(TMDS_Controller_to_TMDS_loadD1),
        .D2_load(TMDS_Controller_to_TMDS_loadD2),
        .S1_load(TMDS_Controller_to_TMDS_loadS1),
        .S2_load(TMDS_Controller_to_TMDS_loadS2),
        .L2_load(TMDS_Controller_to_TMDS_loadL2),
        .SR0_load(Output_Controller_to_TMDS_shift1load),
        .SR1_load(Output_Controller_to_TMDS_shift2load),
        .out_sel(Output_Controller_to_TMDS_outputmuxsel),
        .TMDS_out(channel_1_out)
	);
	
	TMDS_Encoder

	TMDS_channel_2
	(
	      .clk(system_clk),
	      .sr_clk(sr_clk),
	      .n_rst(n_rst),
	      .s_rst(TMDS_Controller_to_TMDS_srst),
        .pixel_data(data_line[23:16]),
        .preamble_data(preamble_data[29:20]),
        .guard_data(guard_data[29:20]),
        .shiftmuxsel(output_Controller_to_TMDS_shiftmuxsel),
        .D1_load(TMDS_Controller_to_TMDS_loadD1),
        .D2_load(TMDS_Controller_to_TMDS_loadD2),
        .S1_load(TMDS_Controller_to_TMDS_loadS1),
        .S2_load(TMDS_Controller_to_TMDS_loadS2),
        .L2_load(TMDS_Controller_to_TMDS_loadL2),
        .SR0_load(Output_Controller_to_TMDS_shift1load),
        .SR1_load(Output_Controller_to_TMDS_shift2load),
        .out_sel(Output_Controller_to_TMDS_outputmuxsel),
        .TMDS_out(channel_2_out)
	);
	
	//create controllers
	output_controller
	
	Output_Controller
	(
	      .clk(system_clk),
	      .n_rst(n_rst),
	      .rowcount(Timers_to_Controllers_rowcount),
	      .colcount(Timers_to_Controllers_colcount),
	      .pixelclk(Timers_to_Controllers_pixelclk),
	      .rowtimerenable(Output_Controller_to_Timers_rowtimerenable),
	      .coltimerenable(Output_Controller_to_Timers_coltimerenable),
	      .shift1load(Output_Controller_to_TMDS_shift1load),
	      .shift2load(Output_Controller_to_TMDS_shift2load),
	      .shiftmux_delay(Output_Controller_to_TMDS_shiftmuxsel),
	      .outputmuxsel(Output_Controller_to_TMDS_outputmuxsel),
	      .n_vsync_delay(Vsync),
	      .n_hsync_delay(Hsync)      
	);
	
	tmds_controller

  TMDS_Controller
  (
	      .clk(system_clk),
	      .n_rst(n_rst),
	      .addRollover(Timers_to_TMDS_Controller_addrrollover),
	      .rowcount(Timers_to_Controllers_rowcount),
	      .colcount(Timers_to_Controllers_colcount),
	      .finished(frame_done),
	      .n_datavalid(data_ready),
	      .pixelclk(Timers_to_Controllers_pixelclk),
	      .addtimerenable(TMDS_Controller_to_Timers_addrenable),
	      .d1load(TMDS_Controller_to_TMDS_loadD1),
	      .d2load(TMDS_Controller_to_TMDS_loadD2),
	      .s1load(TMDS_Controller_to_TMDS_loadS1),
	      .s2load(TMDS_Controller_to_TMDS_loadS2),
	      .frameswap(TMDS_Controller_to_bitflip_frameswap),
	      .readrequest(read_request),
	      .storecnt(TMDS_Controller_to_TMDS_loadL2),
	      .cntreset(TMDS_Controller_to_TMDS_srst)
  );
  
  timertop
  
  Timertop
  (
	      .clk(system_clk),
	      .n_rst(n_rst),
	      .enable(1'b1),
	      .addr_enable(TMDS_Controller_to_Timers_addrenable),
	      .flag_addr(Timers_to_TMDS_Controller_addrrollover),
	      .pixel_clk(pixelclk),
	      .flag_pulse(Timers_to_Controllers_pixelclk),
	      .counter_out_col(Timers_to_Controllers_colcount),
	      .counter_out_row(Timers_to_Controllers_rowcount),
	      .counter_out_addr(address_line[18:0])
  );
  
  addr_bit_flip
  
  Addr_Bit
  (
	      .clk(system_clk),
	      .n_rst(n_rst),
	      .frameswap(TMDS_Controller_to_bitflip_frameswap),
	      .addr_bit(address_line[19])
  );
  
endmodule
