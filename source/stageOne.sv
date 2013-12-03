//Stage one outputs a transition minimized 9-bit code based on an 8-bit input
module stageOne
(
	input wire [7:0] st1_in,		//8-bit input from databuffer
	output wire [8:0] st1_out	//9-bit output to stageTwo encoding
);

reg [4:0] num_ones;
genvar i;

always_comb begin
num_ones = st1_in[0] + st1_in[1] + st1_in[2] + st1_in[3] + st1_in[4] + st1_in[5] + st1_in[6] + st1_in[7];	//Counts number of high bits in input byte
end

assign st1_out[0] = st1_in[0];
generate
for(i = 0; i < 7; i = i + 1) begin

assign st1_out[i+1] = (num_ones > 4 || (num_ones == 4 && st1_in[0] == 1'b0)) ? st1_out[i] ~^ st1_in[i+1] : st1_out[i] ^ st1_in[i+1];
	
end
endgenerate

assign st1_out[8] = (num_ones > 4 || (num_ones == 4 && st1_in[0] == 1'b0)) ? 1'b0 : 1'b1;

/*
always_comb begin												//Choose correct encoding, either XOR or XNOR
if(num_ones > 4 || (num_ones == 4 && st1_in[0] == 1'b0) ) begin
	st1_out[0] = st1_in[0];
	st1_out[1] = st1_out[0] ~^ st1_in[1];
	st1_out[2] = st1_out[1] ~^ st1_in[2];
	st1_out[3] = st1_out[2] ~^ st1_in[3];
	st1_out[4] = st1_out[3] ~^ st1_in[4];
	st1_out[5] = st1_out[4] ~^ st1_in[5];
	st1_out[6] = st1_out[5] ~^ st1_in[6];	
	st1_out[7] = st1_out[6] ~^ st1_in[7];
	st1_out[8] = 0;
end else begin
	st1_out[0] = st1_in[0];
	st1_out[1] = st1_out[0] ^ st1_in[1];
	st1_out[2] = st1_out[1] ^ st1_in[2];
	st1_out[3] = st1_out[2] ^ st1_in[3];
	st1_out[4] = st1_out[3] ^ st1_in[4];
	st1_out[5] = st1_out[4] ^ st1_in[5];
	st1_out[6] = st1_out[5] ^ st1_in[6];	
	st1_out[7] = st1_out[6] ^ st1_in[7];
	st1_out[8] = 1;
end
end
*/


endmodule
