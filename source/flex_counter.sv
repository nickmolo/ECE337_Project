module flex_counter#(parameter NUM_CNT_BITS = 4)(
input wire clk,
input wire n_rst,
input wire count_enable,
input wire [NUM_CNT_BITS-1:0] rollover_val,
output wire [NUM_CNT_BITS-1:0] count_out,
output wire rollover_flag
);

reg [NUM_CNT_BITS-1:0] state;
reg [NUM_CNT_BITS-1:0] nextstate;

reg rflag;        //Reset on positive Clock edge and enable
reg nextrflag;

assign count_out = state;

//REG
always @ (posedge clk, negedge n_rst) begin
	if(n_rst == 1'b0) begin
		state <= {NUM_CNT_BITS{1'b0}}; //Reset to 0
		rflag <= 1'b0;
	end else begin
		state <= nextstate;
		rflag <= nextrflag;
	end
end

always @ (state, rollover_val,count_enable) begin
	nextstate = state;
	if(count_enable == 1'b1)begin
		if(state != rollover_val)
			nextstate = state + 1;
		else
			nextstate = {{NUM_CNT_BITS-1{1'b0}},1'b1}; //Reset to 1
	end
end

always @ (state,rflag,rollover_val,count_enable) begin
	nextrflag = rflag;
	if(count_enable == 1'b1)begin
		if(rollover_val == 1)
			nextrflag = 1'b1;
		else if(state == (rollover_val - 1) )
			nextrflag = 1'b1;
		else
			nextrflag = 1'b0;
		end
	end

assign rollover_flag = rflag;

endmodule
