//Filename: flex_stp_sr.sv
//Description: flexible design for serial to parallel shift register

module tb_stp_sr
 
#( 

parameter NUM_BITS = 4,
parameter SHIFT_MSB = 1
  
)
  
(
  
  input wire clk,
  input wire n_rst,
  input wire shift_enable,
  input wire serial_in,
  output reg [NUM_BITS-1:0] parallel_out
  
);

int i;
reg [NUM_BITS-1:0] nxt_parallel_out;

always @ (posedge clk, negedge n_rst) begin: state
  
  if (n_rst == 0) begin
    
    //generate
      
      for(i = 0; i <= NUM_BITS; i = i + 1)
      begin
    
        parallel_out[i] <= 1;
      
      end
    
    //endgenerate

  end
  
  else begin
  
	for(i = 0; i <= NUM_BITS; i = i + 1)
      begin
    
        parallel_out[i] <= nxt_parallel_out[i];
      
      end
	
  end
  
end

always@(*) begin: nxt_state
 
  if ((shift_enable == 1) && (!SHIFT_MSB)) begin

    nxt_parallel_out[NUM_BITS-1] = serial_in;

   // generate
      
      for(i = NUM_BITS-1; i > 0; i = i - 1)
      begin
    
        nxt_parallel_out[i-1] = parallel_out[i];
      
      end
      
   // endgenerate
  
  end
  
  else if ((shift_enable == 1) && (SHIFT_MSB)) begin

    nxt_parallel_out[0] = serial_in;

   // generate
      
      for(i = 0; i < NUM_BITS-1; i = i + 1)
      begin
    
        nxt_parallel_out[i+1] = parallel_out[i];
      
      end
      
   // endgenerate
  
  end
  
  else begin
      
      //generate
        
        for(i = 0; i < NUM_BITS; i = i + 1)
        begin
          
          nxt_parallel_out[i] = parallel_out[i];
          
        end
        
      //endgenerate
      
  end
end  


endmodule
