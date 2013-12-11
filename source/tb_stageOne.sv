//Filename: tb_stageOne.sv
//Description: Used to test the stage one encoding

`timescale 1ns / 1ns

module tb_stageOne ();

reg [7:0] tb_in;
reg [8:0] test_out;
reg [8:0] exp_out;
stageOne STAGE(.st1_in(tb_in), .st1_out(test_out));

initial
begin

tb_in = 8'b01110101; exp_out = 9'b001111001; #10;
assert(exp_out == test_out)else
	$error("Output Fail");

tb_in = 8'b00000000; exp_out = 9'b100000000; #10;
assert(exp_out == test_out)else
	$error("Output Fail");

tb_in = 8'b00010001; exp_out = 9'b100001111; #10;
assert(exp_out == test_out)else
	$error("Output Fail");
end

endmodule
