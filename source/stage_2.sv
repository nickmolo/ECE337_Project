module stage_2
    
  (
  
    input wire clk,
    input wire n_rst,
    input wire load,
    input wire s_rst,
    input wire [8:0]data_in,
    output reg [9:0]data_out

  );
    
  reg signed [15:0]disparity_cnt;
  reg signed [15:0]nxt_disparity_cnt;
  reg signed [15:0]current_cnt;
  reg [3:0]num_1;
  reg [3:0]num_0;
  
  //disparity counter reg behaviour
  always @ (posedge clk, negedge n_rst) begin: state_reg
  
    //if reset is low goto 0
    if(!n_rst) begin
      disparity_cnt <= 0;
    end
    
    //otherwise goto next state
    else begin
      disparity_cnt <= nxt_disparity_cnt;
    end
  
  end
  
  
  //Combinational next state logic
  always @ (s_rst, disparity_cnt, current_cnt, load) begin: nxt_state_logic 
    
    if(s_rst == 1) begin
      nxt_disparity_cnt = 0;
    end

    else if(load == 1) begin
      nxt_disparity_cnt = current_cnt; 
    end
      
    else begin
      nxt_disparity_cnt = disparity_cnt;
    end
  end
   
  
  //stage 2 combo logic
  always @ (disparity_cnt, num_0, num_1, data_in) begin: stage_2_logic
    
    if((disparity_cnt == 0) || (num_1 == num_0)) begin
      
      data_out[9] = !data_in[8];
      data_out[8] = data_in[8];
      
      if(data_in[8] == 0) begin
        
        data_out[7:0] = ~data_in[7:0];  
        
        current_cnt = disparity_cnt + num_0 - num_1;
        
      end
      
      else begin
        
        data_out[7:0] = data_in[7:0];  
        
        current_cnt = disparity_cnt + num_1 - num_0;
        
      end
      
    end
      
    else if(((disparity_cnt > 0) && (num_1 > num_0)) || ((disparity_cnt < 0) && (num_0 > num_1))) begin
      
      data_out[9] = 1;
      data_out[8] = data_in[8];
      data_out[7:0] = ~data_in[7:0];
      
      current_cnt = disparity_cnt + (2 * data_in[8]) + num_0 - num_1;
      
    end
      
    else begin
      
      data_out[9] = 0;
      data_out[8] = data_in[8];
      data_out[7:0] = data_in[7:0];
      
      current_cnt = disparity_cnt + (2 * ~data_in[8]) + num_1 - num_0;
      
    end  
  
  end
        
  assign num_1 = data_in[0] + data_in[1] + data_in[2] + data_in[3] + data_in[4] + data_in[5] + data_in[6] + data_in[7];
  assign num_0 = 4'h8 - num_1;      
  
endmodule
