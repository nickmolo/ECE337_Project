`timescale 1ns / 1ns

module tb_stageOne ();

reg [7:0] tb_in;
reg [8:0] test_out;
reg [8:0] exp_out;
int err_flag = 0;


stageOne STAGE(.st1_in(tb_in), .st1_out(test_out));

initial
begin

$display("Testing Correct output for Stage 1");

tb_in = 8'b01110101; exp_out = 9'b001111001; #10;
assert(exp_out == test_out)else begin
	err_flag = 1;
	$error("Output Fail");
end

tb_in = 8'b00000000; exp_out = 9'b100000000; #10;
assert(exp_out == test_out)else begin
	err_flag = 1;
	$error("Output Fail");
end

tb_in = 8'b00010001; exp_out = 9'b100001111; #10;
assert(exp_out == test_out)else begin
	err_flag = 1;
	$error("Output Fail");
end

assert(err_flag == 0) begin
	$display("   Passed");
end else begin
	err_flag = 0;
	$display("   Failed");
end

end


endmodule
