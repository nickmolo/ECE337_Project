//Filename: tb_output_controller.sv
//Description: Test bench for the output controller

`timescale 1ns / 10ps

module tb_output_controller();

parameter CLK_PERIOD		= 4;//6.66;	//150 MHZ
//parameter CLK_PIXEL_PERIOD	= 40;	//150 MHZ
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
reg [18:0] tb_addrcount;
int err_flag = 0;
int err_flag2 = 0;
int err_flag3 = 0;

int tb_blankCheck = 0;
int tb_guardCheck = 0;
int tb_videoCheck = 0;
int tb_HSyncCheck = 0;
int tb_VSyncCheck = 0;
reg tb_addRollover;

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
		.shiftmuxsel(tb_sr_sel),
		.outputmuxsel(tb_out_sel),
		.n_vsync(tb_vsync),
		.n_hsync(tb_hsync)
	);


  always
  begin : PIX_GEN

    tb_pixelclk = 1'b1;
    #(CLK_PERIOD);
    tb_pixelclk = 1'b0;
    #(24-CLK_PERIOD);
  end
  
 always @ (posedge tb_pixelclk) begin : row_col_counts
   tb_addRollover = 0;
   if (tb_rowcount == 524 && tb_colcount == 794) begin
     tb_addRollover = 1;
   end
   if (tb_colcount <799) begin
     tb_colcount++; 
   end
   else begin
     tb_colcount = 0;
 	if (tb_rowcount < 524) begin
	  tb_rowcount++;
 	end
 	else begin
 	  tb_rowcount=0;
 	end
   end
 end 	   



//Generate clock to 150 MHz
always
begin : CLK_GENERATION
	tb_clk = 1'b0;
	#(CLK_PERIOD / 2);
	tb_clk = 1'b1;
	#(CLK_PERIOD / 2);
end

always @(tb_colcount, tb_rowcount, tb_pixelclk) begin
if(tb_colcount > 15 && tb_colcount < 112) 
	tb_HSyncCheck = 1;
else
	tb_HSyncCheck = 0;

if(tb_rowcount < 2)
	tb_VSyncCheck = 1;
else
	tb_VSyncCheck = 0;

if(tb_colcount < 159 || tb_rowcount < 44) begin
	tb_blankCheck = 1;
	tb_guardCheck = 0;
	tb_videoCheck = 0;
end

if(tb_rowcount > 44 && ((tb_colcount == 159) || (tb_colcount == 158))) begin
	tb_blankCheck = 0;
	tb_guardCheck = 1;
	tb_videoCheck = 0;
end

if(tb_rowcount > 44 && tb_colcount > 159) begin
	tb_blankCheck = 0;
	tb_guardCheck = 0;
	tb_videoCheck = 1;
end

end

always @(tb_blankCheck) begin
@(negedge tb_pixelclk);
if(tb_blankCheck == 1 && tb_out_sel != 2'b00) begin
	err_flag2 = 1;
	$error("Blanking Data Period Fail");

end
if(tb_guardCheck == 1 && tb_out_sel != 2'b01) begin
	err_flag2 = 1;
	$error("Guard Data Period Fail");
end
if(tb_videoCheck == 1 && tb_out_sel != 2'b10) begin
	err_flag2 = 1;
	$error("Video Data Period Fail");
end
if(tb_HSyncCheck == 1 && tb_hsync != 1'b0 && tb_n_rst == 1) begin
	err_flag3 = 1;
	$error("HSync Period Fail");
end
if(tb_VSyncCheck == 1 && tb_vsync != 1'b0 && tb_n_rst == 1) begin
	err_flag3 = 1;
	$error("VSync Period Fail");
end

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

$display("I. Testing Initial Reset Conditions");
@(posedge tb_clk);
	assert(tb_vsync == 1'b1)
		else begin
			err_flag = 1;
			$error("VSync Reset Failed");
		end
	assert(tb_hsync == 1'b1)
		else begin
			err_flag = 1;
			$error("HSync Reset Failed");
		end
	assert(tb_sr_sel == 1'b1)
		else begin
			err_flag = 1;
			$error("SR Reset Failed");
		end
	assert(tb_out_sel == 2'b00)
		else begin
			err_flag = 1;
			$error("OutSel Reset Failed");
		end
	assert(err_flag == 0) begin
		$display("   I.Passed");
		end else begin
			err_flag = 0;
			$display("   I.Failed");
		end


$display("\nII. Testing Mid-Frame Reset Conditions");
@(posedge tb_clk);
#(FRAME_PERIOD / 1000)			//Mid-Frame Reset
	tb_n_rst = 1'b0; 
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(negedge tb_clk);
	tb_n_rst = 1'b1; 		//Release reset
@(posedge tb_clk);
	assert(tb_vsync == 1'b1)
		else begin
			err_flag = 1;
			$error("VSync Reset Failed");
		end
	assert(tb_hsync == 1'b1)
		else begin
			err_flag = 1;
			$error("HSync Reset Failed");
		end
	assert(tb_sr_sel == 1'b1)
		else begin
			err_flag = 1;
			$error("SR Reset Failed");
		end
	assert(tb_out_sel == 2'b00)
		else begin
			err_flag = 1;
			$error("OutSel Reset Failed");
		end
	assert(err_flag == 0) begin
		$display("   II.Passed");
		end else begin
			err_flag = 0;
			$display("   II.Failed");
		end

$display("\nNote: Final two tests will cover two frame periods\n");
$display("III. Testing Blanking,Guard,and Video Period Timing");
$display("IV. Testing HSync, VSync Period Timing");
#(FRAME_PERIOD * 2)
	assert(err_flag2 == 0) begin
		$display("   III.Passed");
		end else begin
			err_flag2 = 0;
			$display("III. Failed");
		end
	assert(err_flag3 == 0) begin
		$display("   IV.Passed");
		end else begin
			err_flag3 = 0;
			$display("   IV.Failed");
		end
	

end

endmodule
