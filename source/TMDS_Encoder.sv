module TMDS_Encoder
(
	input reg [7:0] video_data,
	input reg [7:0] blank_data,
	input wire [1:0] blank_sel,
	input wire D1_load,
	input wire D2_load,
	input wire S1_load,
	input wire S2_load,
	input wire SR0_load,
	input wire SR1_load,
	input wire out_sel,
	output wire TMDS_out
);

//Internal Transitional Registers
reg [7:0] D1_input_data;	//D1 input from Blanking mux
reg [7:0] D2_input_data;	//D2 input from D1
reg [7:0] L1_input_data;	//L1 input from D2
reg [8:0] S1_input_data;	//S1 input from L1
reg [8:0] L2_input_data;	//L2 input from S1
reg [9:0] S2_input_data;	//S2 input from L2

//Select between input video data and blanking mode data
blankMux BMUX
	(
		.videoData(video_data),
		.blankData(blank_data),
		.guardData(guard_data),
		.sel(blank_sel),
		.out(D1_input)
	);

//Updated with valid video or blanking data
buffer D1BUFF
	(
		.clk(clk),
		.n_rst(n_rst),
		.p_in(D1_input),
		.p_out(D2_input)
	);

//Stores input to first stage of encoder
buffer D2BUFF
	(
		.clk(clk),
		.n_rst(n_rst),
		.p_in(D2_input),
		.p_out(L1_input)
	);

//Computes new 9-bit value using the 8-bits from D2
stageOne LOGIC1
	(
		.st1_in(L1_input),
		.st1_out(S1_input)
	);	
	
//Stores 9-bit value from stage 1
buffer S1BUFF
	(
		.clk(clk),
		.n_rst(n_rst),
		.p_in(S1_input),
		.p_out(L2_input)
	);

//10-bit from D2, 9-bit output to S1
stageTwo LOGIC2
	(
		.clk(clk),
		.n_rst(n_rst),
		.load(L2_load),
		.data_in(L2_input),
		.data_out(S2_input)
	);

//Stores 10-bit value from stage 2
buffer S2BUFF
	(
		.clk(clk),
		.n_rst(n_rst),
		.p_in(S2_input),
		.p_out(SR_input)
	);

//SR0, shifts while SR1 is loading
hr_sv SR0
	(
                .clk(clk),
                .n_rst(n_rst),
                .load_enable(SR0_load),
                .parallel_in(SR_input),
                .serial_out(SR0_out)
        );

//SR1, shifts while SR0 is loading
hr_sv SR1
	(
                .clk(clk),
                .n_rst(n_rst),
                .load_enable(SR1_load),
                .parallel_in(SR_input),
                .serial_out(SR1_out)
        );

//Choosese the SR that is currently shifting out
sr_mux SRMUX
	(
                .select(out_sel),
                .sr0(SR0_out),
                .sr1(SR1_out),
                .muxout(TMDS_out)
        );

endmodule
