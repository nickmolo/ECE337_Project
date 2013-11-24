`timescale 1ns / 10ps

module tb_output_controller();

parameter CLK_PERIOD		= 6.66;	//150 MHZ
parameter CLK_PIXEL_PERIOD	= 40;	//150 MHZ
parameter FRAME_PERIOD		= 16700000; //60 Hz

reg tb_clk;
reg tb_pixel_clk;
reg tb_pixelclk;
reg tb_n_rst;
reg [9:0] tb_rowcount;
reg [9:0] tb_colcount;
reg tb_renable;
reg tb_cenable;
reg tb_1load;
reg tb_2load;
reg tb_sr_sel;
reg [1:0] tb_out_sel;
reg tb_vsync;
reg tb_hsync;
reg tb_addrFlag;
reg [19:0] tb_addrcount;


timertop TIMER(
		.clk(tb_clk),
		.n_rst(tb_n_rst),
		.enable(1'b1),
		.addr_enable(tb_pixelclk),
		.flag_addr(tb_addrFlag),
		.pixel_clk(tb_pixel_clk),
		.flag_pulse(tb_pixelclk),
		.counter_out_col(tb_colcount),
		.counter_out_row(tb_rowcount),
		.counter_out_addr(tb_addrcount)
	);

output_controller CTRL
	(
		.clk(tb_clk),
		.n_rst(tb_n_rst),
		.rowcount(tb_rowcount),
		.colcount(tb_colcount),
		.pixelclk(tb_pixelclk),
		.rowtimerenable(tb_renable),
		.coltimerenable(tb_cenable),
		.shift1load(tb_1load),
		.shift2load(tb_2load),
		.shiftmux_delay(tb_sr_sel),
		.outputmuxsel(tb_out_sel),
		.n_vsync_delay(tb_vsync),
		.n_hsync_delay(tb_hsync)
	);



//Generate clock to 150 MHz
always
begin : CLK_GENERATION
	tb_clk = 1'b0;
	#(CLK_PERIOD / 2);
	tb_clk = 1'b1;
	#(CLK_PERIOD / 2);
end


initial
begin

//Check correct values after inactive reset
//tb_test_case = 4'h1;
	//Get away from Time = 0
		#0.1;
		
		// Chip reset
		// Activate reset
			tb_n_rst = 1'b0; 
		// wait for a few clock cycles
			@(posedge tb_clk);
			@(posedge tb_clk);
		// Release on falling edge to prevent hold time violation
			@(negedge tb_clk);
			tb_n_rst = 1'b1; 		//Release reset

@(posedge tb_clk);
	assert(tb_vsync == 1'b1 && tb_hsync == 1'b1 && tb_sr_sel == 1'b0)else
		$error("Reset registers Failed");


@(posedge tb_clk);
#(FRAME_PERIOD / 100)		//Mid-Frame Reset
	tb_n_rst = 1'b0; 
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(negedge tb_clk);
	tb_n_rst = 1'b1; 		//Release reset
@(posedge tb_clk);
	assert(tb_vsync == 1'b1 && tb_hsync == 1'b1 && tb_sr_sel == 1'b0)else
		$error("Reset registers Failed");
end

endmodule
