module clockdivider
  (
    input wire clk,
    input wire n_rst,
    input wire enable,
    output reg flag_pulse
  );
  
  reg [2:0] cnt;
  
  always @ (posedge clk, negedge n_rst) begin
    if( n_rst == 1'b0) begin
      //reset everything
      cnt <= 0;
      flag_pulse <=0;
    end else begin
    
      if(enable == 1) begin
        if (cnt > 6) begin
          cnt <= 0;
          flag_pulse <= 1;
        end else begin
          flag_pulse <= 0;
          cnt <= cnt +1;
        end
      end
      
    end
  end

endmodule
