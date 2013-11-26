module TMDS_Encoder
(
	input wire clk,
	input wire sr_clk,
	input wire n_rst,
	input wire s_rst,		//Sync reset to stage 2 from TMDS controller
	input reg D1_load,		//load enables from TMDS controller
	input reg D2_load,
	input reg S1_load,
	input reg S2_load,
	input reg L2_load,
	input reg SR0_load,		//load enables from Output controller
	input reg SR1_load,
	input reg [7:0] pixel_data,
	input reg [9:0] preamble_data,
	input reg [9:0] guard_data,
	input wire [1:0] out_sel,
	input wire shiftmuxsel,
	output wire TMDS_out,
	output reg [9:0] pixel_encoded
);

//Internal Transitional Registers
reg [7:0] D2_input;	//D2 input from D1
reg [7:0] L1_input;	//L1 input from D2
reg [8:0] S1_input;	//S1 input from L1
reg [8:0] L2_input;	//L2 input from S1
reg [9:0] S2_input;	//S2 input from L2
//reg [9:0] pixel_encoded;	//Final encoded pixel data
reg [9:0] SR_input;


//Updated with valid video or blanking data
buffer #(8) D1BUFF
	(
		.clk(clk),
		.n_rst(n_rst),
		.p_in(pixel_data),
		.p_out(D2_input),
		.load_enable(D1_load)
	);

//Stores input to first stage of encoder
buffer #(8) D2BUFF
	(
		.clk(clk),
		.n_rst(n_rst),
		.p_in(D2_input),
		.p_out(L1_input),
		.load_enable(D2_load)
	);

//Computes new 9-bit value using the 8-bits from D2
stageOne LOGIC1
	(
		.st1_in(L1_input),
		.st1_out(S1_input)
	);	
	
//Stores 9-bit value from stage 1
buffer #(9) S1BUFF
	(
		.clk(clk),
		.n_rst(n_rst),
		.p_in(S1_input),
		.p_out(L2_input),
		.load_enable(S1_load)
	);

//10-bit from D2, 9-bit output to S1
stage_2 LOGIC2
	(
		.clk(clk),
		.n_rst(n_rst),
		.s_rst(s_rst),
		.load(L2_load),
		.data_in(L2_input),
		.data_out(S2_input)
	);

//Stores 10-bit value from stage 2
buffer #(10) S2BUFF
	(
		.clk(clk),
		.n_rst(n_rst),
		.p_in(S2_input),
		.p_out(pixel_encoded),
		.load_enable(S2_load)
	);

//Selects between various inputs
outputMux BMUX
	(
		.videoData(pixel_encoded),
		.blankData(preamble_data),
		.guardData(guard_data),
		.sel(out_sel),
		.out(SR_input)
	);


//SR0, shifts while SR1 is loading
hs_sr SR0
	(
                .clk(sr_clk),
                .n_rst(n_rst),
                .load_enable(SR0_load),
                .parallel_in(SR_input),
                .serial_out(SR0_out)
        );

//SR1, shifts while SR0 is loading
hs_sr SR1
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
                .select(shiftmuxsel),
                .sr0(SR0_out),
                .sr1(SR1_out),
                .muxout(TMDS_out)
        );



endmodule
