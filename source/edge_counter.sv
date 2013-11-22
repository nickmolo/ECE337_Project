module edge_counter
      #(
      parameter NUM_CNT_BITS =4
      )
      (
      input wire clk,
      input wire n_rst,
	  		input wire count_enable,
	  		input wire in_edge,
	  		input wire [NUM_CNT_BITS-1:0] rollover_val,
	  		output reg [NUM_CNT_BITS-1:0] count_out,
	  		output wire rollover_flag
      );
	  
	  reg [NUM_CNT_BITS-1:0] counter;
	  reg [NUM_CNT_BITS-1:0] rollval;
	  
	  assign rollover_flag = (counter >= rollover_val) ? 1'b1 : 1'b0;
	  assign count_out = counter;

	  always @ (posedge clk, negedge n_rst) begin 
	   if (n_rst ==0) begin
	     counter[NUM_CNT_BITS-1:0] <= {NUM_CNT_BITS{1'b0}}; //reset flip-flops to initial values
	     rollval <= rollover_val;
	   end
	end
	
	always @(negedge in_edge) begin
		if (count_enable == 1'b1) begin
			
			if(counter == rollval) begin
				counter[NUM_CNT_BITS-1:0] <= {{NUM_CNT_BITS-1{1'b0}},1'b1};
			end else begin
				counter <= counter +1;
			end
			
		end else begin
			counter <= counter;
		end
	end

endmodule