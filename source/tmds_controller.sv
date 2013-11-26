module tmds_controller
    
  (
    input wire clk,
    input wire n_rst,
    input wire addRollover, //640x480 address timer
    input wire [9:0] rowcount, //row count from row timer
    input wire [9:0] colcount, //col count from col timer
    input wire finished, //finished signal from sram wrapper
    input wire n_datavalid, //datavalid signal from wrapper (looking for a zero)
    input wire pixelclk, //Rollover for the pixel clock
    output reg addtimerenable, //Enable for the 640x480 address timer
    output reg d1load, //Load enable for the data buffer 1
    output reg d2load, //Load enable for the data buffer 2
    output reg s1load, //Load enable for the stage 1 register
    output reg s2load, //Load enable for the stage 2 register
    output reg frameswap, //Pulse to swap the frame address bit
    output reg readrequest, //Pulse to request a read from the sram wrapper
    output reg storecnt, //Load count register in stage 2 logic block
    output reg cntreset  //Synchronous reset for count register in stage 2 logic block
  );
    

  //enumerate FSM states
  typedef enum bit [2:0]
  {
    REQUEST,
    WAIT_DATA,
    LOAD,
    WAIT_CYCLE,
    SWITCH_FRAME,
    PUSH
  } state_type;
    
  state_type state, nxt_state;
  
    //stage reg behaviour
  always @ (posedge clk, negedge n_rst) begin: state_reg
  
    //if reset is low goto idle
    if(!n_rst) begin
      state <= WAIT_CYCLE;
      
    end
    
    //otherwise goto next state
    else begin
      state <= nxt_state;
    end
  
  end
  
  
  //Combinational next state logic
  always @ (*) begin: nxt_state_logic
    
    nxt_state = state;
    
    case(state)
      
      REQUEST: begin
        
        nxt_state = WAIT_DATA;
      end
      
      WAIT_DATA: begin
        
        //check for valid data from the read request to move to the next state
        if (n_datavalid == 0) begin
          nxt_state = LOAD;
        end
          
      end
      
      LOAD: begin
        
        //load the data from the sram wrapper into data buffer, check if frame is done
        if ((addRollover == 1) && (finished == 1)) begin
          nxt_state = SWITCH_FRAME;
        end 
        
        
      else begin
        nxt_state = WAIT_CYCLE;
        end
        
      end
      
      SWITCH_FRAME: begin
        
        //Swap the frame and move on
        nxt_state = WAIT_CYCLE;
        
      end
      
      WAIT_CYCLE: begin
        
        //Check when to switch to next pixel
        if (pixelclk == 1) begin
          
          //Check if we are in the last 4 pixels, if so then push those through and don't request any more reads
          if((rowcount == 524) && (colcount > 795)) begin
            nxt_state = PUSH;
          end
          
          //Check if we are within 4 pixels of the start of a video frame, or if we are in an actual video frame.  Then request a read from the SRAM
          else if (((rowcount > 44) && (colcount > 159)) || ((rowcount == 45) && (colcount > 155))) begin
            nxt_state = REQUEST;
          end

        end
        
      end
      
      
      
      PUSH: begin
        
        nxt_state = WAIT_CYCLE;
        
      end
      
    endcase
  end
        
    
    
  always@(state) begin: output_logic  //Describe the Output Logic
    
    d1load = 0;
    d2load = 0;
    s1load = 0;
    s2load = 0;
    frameswap = 0;
    readrequest = 0;
    storecnt = 0;
    addtimerenable = 0;
    cntreset = 0;
    
    case(state)
    
      REQUEST: begin
        
        d2load = 1; //Enable data buffer 2 to load
        s1load = 1; //Enable stage 1 reg to load
        s2load = 1; //Enable stage 2 reg to load
        readrequest = 1; // Request a read from the sram wrapper
        storecnt = 1;  //Tell logic 2 to store a new count
        
      end
      
      WAIT_DATA: begin
      
        
      end

      
      LOAD: begin

        d1load = 1;
        addtimerenable = 1;
        
      end
      
      SWITCH_FRAME: begin
        
        frameswap = 1;
        
      end
      
      WAIT_CYCLE: begin
        if (rowcount == 45 && colcount == 158) begin
          cntreset = 1;
        end
      else if (rowcount >= 45 && colcount == 798) begin
          cntreset = 1;
        end

      
      end
      
      PUSH: begin
        
        d1load = 1;
        d2load = 1;
        s1load = 1;
        s2load = 1;
        storecnt = 1;
      end
      
    endcase   
  end
           
      
    
    
 endmodule
