//Filename: pixel_gen.sv
//Description: designed to generate a 25 MHz pixel clock to be used by the externam hdmi device

module pixel_gen
  (
    input wire clk,
    input wire n_rst,
    input wire enable,
    output reg flag_pixel
  );
  
  reg [3:0] cnt;
  
  always @ (posedge clk, negedge n_rst) begin
    if( n_rst == 1'b0) begin
      //reset everything
      cnt <= 0;
      flag_pixel <= 0;
    end else begin
      
      if(enable == 1) begin
        
        if (cnt == 5) begin
          cnt <= 1;
          flag_pixel <= ~flag_pixel;
        end else begin
          cnt <= cnt +1;
        end
        
      end
      
    end
  end
  
endmodule
