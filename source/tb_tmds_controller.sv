//Filename: tb_tmds_controller.sv
//Description: Test bench used to test the TMDS Controller

`timescale 1ns / 10ps

module tb_tmds_controller();

	// Define parameters
	parameter CLK_PERIOD				= 4;

  
	
	
	reg tb_clk;
	reg tb_n_rst;
	reg tb_addRollover;
	reg [9:0] tb_rowcount=523;
	reg [9:0] tb_colcount=0;
	reg tb_finished;
	reg tb_n_datavalid;
	reg tb_pixelclk;
	wire tb_addtimerenable;
	wire tb_d1load;
	wire tb_d2load;
	wire tb_s1load;
	wire tb_s2load;
	wire tb_frameswap;
	wire tb_readrequest;
	wire tb_storecnt;
	wire tb_cntreset;

	
	tmds_controller DUT
	(
		.clk(tb_clk),
		.n_rst(tb_n_rst),
    .addRollover(tb_addRollover),
    .rowcount(tb_rowcount),
    .colcount(tb_colcount),
    .finished(tb_finished),
    .n_datavalid(tb_n_datavalid),
    .pixelclk(tb_pixelclk),
    .addtimerenable(tb_addtimerenable),
    .d1load(tb_d1load),
    .d2load(tb_d2load),
    .s1load(tb_s1load),
    .s2load(tb_s2load),
    .frameswap(tb_frameswap),
    .readrequest(tb_readrequest),
    .storecnt(tb_storecnt),
    .cntreset(tb_cntreset)
    
	);
	
	always
	begin : CLK_GEN
		tb_clk = 1'b0;
		#(CLK_PERIOD * 1/2);
		tb_clk = 1'b1;
		#(CLK_PERIOD * 1/2);
	end

  always
  begin : PIX_GEN

    tb_pixelclk = 1'b1;
    #(CLK_PERIOD);
    tb_pixelclk = 1'b0;
    #(24-CLK_PERIOD);
  end
  
  always
  begin : datavalid_yo
      tb_n_datavalid = 1;
      #(CLK_PERIOD);
      tb_n_datavalid = 0;
 	    #(CLK_PERIOD);
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
	
	// Actual test bench process
	initial
	begin : TEST_PROC
		// Initilize all inputs
		tb_n_rst	= 1'b1; // Initially inactive
    tb_n_datavalid = 1'b1;  //Initially inactive
    tb_finished = 0; //Initially inactive
		// Get away from Time = 0
		#0.1; 
		

			// Chip reset
			// Activate reset
			tb_n_rst = 1'b0; 
			// wait for a few clock cycles
			@(posedge tb_clk);
			@(posedge tb_clk);
			// Release on falling edge to prevent hold time violation
			@(negedge tb_clk);
			// Release reset
			tb_n_rst = 1'b1; 
			// Add some space before starting the test case
			@(posedge tb_clk);
			@(posedge tb_clk);
			
			//Set conditions for for system to run prefectly
			tb_n_datavalid = 0;
			tb_finished = 1;
			
			#(100000)
			tb_rowcount = 43;
			tb_colcount = 0;
			#(20000000)
			tb_n_datavalid = 1;
			tb_finished = 0;
			
      
				

			

		
		// Add any special cases here (such as overrun case)
		
	end

endmodule
