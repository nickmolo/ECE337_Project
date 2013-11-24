module output_controller
    
  (
    input wire clk,
    input wire n_rst,
    input wire [9:0] rowcount, 		//row count from row timer
    input wire [9:0] colcount, 		//col count from col timer
    input wire pixelclk, 		//Rollover for the pixel clock
    output reg rowtimerenable, 		//Enable for the row counter timer
    output reg coltimerenable, 		//Enable for the col counter timer
    output reg shift1load, 		//Load enable for the shift register 1
    output reg shift2load, 		//Load enable for the shift register 2
    output reg shiftmux_delay, 		//Select line for the output shift registers, 0=listen to shiftreg 1, 1=listen to shiftreg2
    output reg [1:0] outputmuxsel, 	//Select line for input to shift registers
    output reg n_vsync_delay, 		//Vsync value active low
    output reg n_hsync_delay 			//Hsync value active low
    );
    
  
  //enumerate FSM states
  typedef enum bit [4:0]
  {
    HSYNC1,
    VSYNC1,
    BOTH1,
    PREAMBLE1,
    GUARD1,
    VIDEO1,
    WAIT1,
    HSYNC2,
    VSYNC2,
    BOTH2,
    PREAMBLE2,
    GUARD2,
    VIDEO2,
    WAIT2
  } state_type;
    
  state_type state, nxt_state;
  
	reg shiftmuxsel;
	reg n_vsync;
	reg n_hsync;
	reg sync_valid;

    //stage reg behaviour
  always @ (posedge clk, negedge n_rst) begin: state_reg
  
    //if reset is low goto idle
    if(!n_rst) begin
      state <= WAIT1;
    end
    
    //otherwise goto next state
    else begin
      state <= nxt_state;
    end
  
  end

//stage reg behaviour
  always @ (posedge clk, negedge n_rst) begin: state_reg_2
  
    //if reset is low goto idle
    if(!n_rst) begin
      shiftmux_delay <= 0;
      n_hsync_delay  <= 1;
      n_vsync_delay  <= 1;
    end
    
    //otherwise goto next state
    else begin
      shiftmux_delay <= shiftmuxsel;
	if(sync_valid == 1) begin
	      n_hsync_delay  <= n_hsync;
	      n_vsync_delay  <= n_vsync;
	end
    end
  
  end
  
  
  //Combinational next state logic
  always @ (*) begin: nxt_state_logic
    nxt_state = state;
    case(state)
      
      WAIT1: begin
        
	if(pixelclk) begin
        //Check where you are in the blanking to determine whether hsync,vsync are necesary
        if (colcount > 15 && colcount < 112) begin 		//Check if we are now in hsync territory
          if (rowcount < 2) begin                 		//Check if we are also in vsync territory
            nxt_state = BOTH2;                			//If yes then go to both
          end
          else begin
            nxt_state = HSYNC2;           	//If no then go to hsync state
          end
        end
        
        else if (rowcount < 2) begin          	//Check if we are just in vsync
          nxt_state = VSYNC2;                   //If yes then go to vsync state
        end
        
        else if (rowcount > 44 && ((colcount == 159) || (colcount == 158))) begin 		//Check if we are in the guard band
          nxt_state = GUARD2;                     						//If Yes then go to Guard state
        end
        
        else if ((rowcount > 44) && (colcount > 159)) begin
          nxt_state = VIDEO2;
        end
          
        else begin
          nxt_state = PREAMBLE2;                    						//Else go to None state
        end

	end


      end
      
      BOTH1: begin
        nxt_state = WAIT1;  
      end
      
      HSYNC1: begin
        nxt_state = WAIT1; 
      end
      
      VSYNC1: begin
        nxt_state = WAIT1; 
      end
      
      GUARD1: begin
        nxt_state = WAIT1; 
      end
      
      PREAMBLE1: begin
        nxt_state = WAIT1; 
      end
      
      VIDEO1: begin
        nxt_state = WAIT1; 
      end
      
      WAIT2: begin
        
        //Check where you are in the blanking to determine whether hsync,vsync are necesary
	if(pixelclk) begin
        if (colcount > 15 && colcount < 112) begin 	//Check if we are now in hsync territory
          if (rowcount < 2) begin                 	//Check if we are also in vsync territory
            nxt_state = BOTH1;                		//If yes then go to both
          end
          else begin
            nxt_state = HSYNC1;           		//If no then go to hsync state
          end
        end
        
        else if (rowcount < 2) begin          		//Check if we are just in vsync
          nxt_state = VSYNC1;                   	//If yes then go to vsync state
        end
        
        else if (rowcount > 44 && ((colcount == 159) || (colcount == 158))) begin 	//Check if we are in the guard band
          nxt_state = GUARD1;                      					//If Yes then go to Guard state
        end
        
        else if ((rowcount > 44) && (colcount > 159)) begin
          nxt_state = VIDEO1;
        end
          
        else begin
          nxt_state = PREAMBLE1;                    	//Else go to None state
        end

	end
      end
      
      BOTH2: begin
        nxt_state = WAIT2;  
      end
      
      HSYNC2: begin
        nxt_state = WAIT2; 
      end
      
      VSYNC2: begin
        nxt_state = WAIT2; 
      end
      
      GUARD2: begin
        nxt_state = WAIT2; 
      end
      
      PREAMBLE2: begin
        nxt_state = WAIT2; 
      end
      
      VIDEO2: begin
        nxt_state = WAIT2; 
      end  
      
    endcase    
  end
    
    
  always@(state) begin: output_logic  			//Describe the Output Logic
    
    rowtimerenable = 1;
    coltimerenable = 1;
    shift1load = 0;
    shift2load = 0;
    shiftmuxsel = 1;
    outputmuxsel = 2'b00;
    
    case(state)
    
      
      WAIT1: begin
        
        shift1load = 1;
	shiftmuxsel = 1;
        sync_valid = 0;
      end
      
      BOTH1: begin
        
        shift1load = 1;
	shiftmuxsel = 1;
        n_vsync = 0;
        n_hsync = 0;
	sync_valid = 1;
        
      end
      
      HSYNC1: begin
        
        shift1load = 1;
	shiftmuxsel = 1;
        n_vsync = 1;
        n_hsync = 0;
	sync_valid = 1;
        
      end
      
      VSYNC1: begin
        
        shift1load = 1;
	shiftmuxsel = 1;
        n_vsync = 0;
        n_hsync = 1;
	sync_valid = 1;
        
      end
      
      GUARD1: begin
        
        shift1load = 1;
	shiftmuxsel = 1;
        outputmuxsel = 2'b01;
        n_vsync = 1;
        n_hsync = 1;
	sync_valid = 1;
        
      end
      
      PREAMBLE1: begin
        
        shift1load = 1;
	shiftmuxsel = 1;
        n_vsync = 1;
        n_hsync = 1;
	sync_valid = 1;
        
      end
      
      VIDEO1: begin
        
        shift1load = 1;
	shiftmuxsel = 1;
        outputmuxsel = 2'b10;
        n_vsync = 1;
        n_hsync = 1;
	sync_valid = 1;
        
      end
      
      WAIT2: begin
        
        shift2load = 1;
	shiftmuxsel = 0;
	sync_valid = 0;

        
      end
      
      BOTH2: begin
        
        shift2load = 1;
	shiftmuxsel = 0;
        n_vsync = 0;
        n_hsync = 0;
	sync_valid = 1;
        
      end
      
      HSYNC2: begin
        
        shift2load = 1;
	shiftmuxsel = 0;
        n_vsync = 1;
        n_hsync = 0;
	sync_valid = 1;
        
      end
      
      VSYNC2: begin
        
        shift2load = 1;
	shiftmuxsel = 0;
        n_vsync = 0;
        n_hsync = 1;
	sync_valid = 1;
        
      end
      
      GUARD2: begin
        
        shift2load = 1;
	shiftmuxsel = 0;
        outputmuxsel = 2'b01;
        n_vsync = 1;
        n_hsync = 1;
	sync_valid = 1;
        
      end
      
      PREAMBLE2: begin
        
        shift2load = 1;
	shiftmuxsel = 0;
        n_vsync = 1;
        n_hsync = 1;
	sync_valid = 1;
        
      end
      
      VIDEO2: begin
        
        shift2load = 1;
	shiftmuxsel = 0;
        outputmuxsel = 2'b10;
        n_vsync = 1;
        n_hsync = 1;
	sync_valid = 1;
        
      end
          
    endcase
      
  end
           
      
    
    
 endmodule
