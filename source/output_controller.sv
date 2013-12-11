//Filename: output_controller.sv
//Description: This controller controls wether we are in blanking, guard, or video data mode

module output_controller

  (
    input wire clk,
    input wire n_rst,
    input wire [9:0] rowcount,    //row count from row timer
    input wire [9:0] colcount,    //col count from col timer
    input wire pixelclk,    //Rollover for the pixel clock
    output reg rowtimerenable,    //Enable for the row counter timer
    output reg coltimerenable,    //Enable for the col counter timer
    output reg shift1load,    //Load enable for the shift register 1
    output reg shift2load,    //Load enable for the shift register 2
    output reg shiftmuxsel,     //Select line for the output shift registers, 0=listen to shiftreg 1, 1=listen to shiftreg2
    output reg [1:0] outputmuxsel,  //Select line for input to shift registers
    output reg n_vsync,     //Vsync value active low
    output reg n_hsync      //Hsync value active low
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
    HSYNC2,
    VSYNC2,
    BOTH2,
    PREAMBLE2,
    GUARD2,
    VIDEO2
  } state_type;

  state_type state, nxt_state;

    //stage reg behaviour
  always @ (posedge clk, negedge n_rst) begin: state_reg

    //if reset is low goto idle
    if(!n_rst) begin
      state <= PREAMBLE1;
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

      BOTH1: begin
  if(pixelclk) begin
        //Check where you are in the blanking to determine whether hsync,vsync are necesary
        if (colcount > 15 && colcount < 112) begin    //Check if we are now in hsync territory
          if (rowcount < 2) begin                     //Check if we are also in vsync territory
            nxt_state = BOTH2;                      //If yes then go to both
          end
          else begin
            nxt_state = HSYNC2;             //If no then go to hsync state
          end
        end

        else if (rowcount < 2) begin            //Check if we are just in vsync
          nxt_state = VSYNC2;                   //If yes then go to vsync state
        end

        else if (rowcount > 44 && ((colcount == 159) || (colcount == 158))) begin     //Check if we are in the guard band
          nxt_state = GUARD2;                                 //If Yes then go to Guard state
        end

        else if ((rowcount > 44) && (colcount > 159)) begin
          nxt_state = VIDEO2;
        end

        else begin
          nxt_state = PREAMBLE2;                                //Else go to None state
        end

  end
      end

      HSYNC1: begin
if(pixelclk) begin
        //Check where you are in the blanking to determine whether hsync,vsync are necesary
        if (colcount > 15 && colcount < 112) begin    //Check if we are now in hsync territory
          if (rowcount < 2) begin                     //Check if we are also in vsync territory
            nxt_state = BOTH2;                      //If yes then go to both
          end
          else begin
            nxt_state = HSYNC2;             //If no then go to hsync state
          end
        end

        else if (rowcount < 2) begin            //Check if we are just in vsync
          nxt_state = VSYNC2;                   //If yes then go to vsync state
        end

        else if (rowcount > 44 && ((colcount == 159) || (colcount == 158))) begin     //Check if we are in the guard band
          nxt_state = GUARD2;                                 //If Yes then go to Guard state
        end

        else if ((rowcount > 44) && (colcount > 159)) begin
          nxt_state = VIDEO2;
        end

        else begin
          nxt_state = PREAMBLE2;                                //Else go to None state
        end

  end
      end

      VSYNC1: begin
  if(pixelclk) begin
        //Check where you are in the blanking to determine whether hsync,vsync are necesary
        if (colcount > 15 && colcount < 112) begin    //Check if we are now in hsync territory
          if (rowcount < 2) begin                     //Check if we are also in vsync territory
            nxt_state = BOTH2;                      //If yes then go to both
          end
          else begin
            nxt_state = HSYNC2;             //If no then go to hsync state
          end
        end

        else if (rowcount < 2) begin            //Check if we are just in vsync
          nxt_state = VSYNC2;                   //If yes then go to vsync state
        end

        else if (rowcount > 44 && ((colcount == 159) || (colcount == 158))) begin     //Check if we are in the guard band
          nxt_state = GUARD2;                                 //If Yes then go to Guard state
        end

        else if ((rowcount > 44) && (colcount > 159)) begin
          nxt_state = VIDEO2;
        end

        else begin
          nxt_state = PREAMBLE2;                                //Else go to None state
        end

  end
      end

      GUARD1: begin
  if(pixelclk) begin
        //Check where you are in the blanking to determine whether hsync,vsync are necesary
        if (colcount > 15 && colcount < 112) begin    //Check if we are now in hsync territory
          if (rowcount < 2) begin                     //Check if we are also in vsync territory
            nxt_state = BOTH2;                      //If yes then go to both
          end
          else begin
            nxt_state = HSYNC2;             //If no then go to hsync state
          end
        end

        else if (rowcount < 2) begin            //Check if we are just in vsync
          nxt_state = VSYNC2;                   //If yes then go to vsync state
        end

        else if (rowcount > 44 && ((colcount == 159) || (colcount == 158))) begin     //Check if we are in the guard band
          nxt_state = GUARD2;                                 //If Yes then go to Guard state
        end

        else if ((rowcount > 44) && (colcount > 159)) begin
          nxt_state = VIDEO2;
        end

        else begin
          nxt_state = PREAMBLE2;                                //Else go to None state
        end

  end
      end

      PREAMBLE1: begin
  if(pixelclk) begin
        //Check where you are in the blanking to determine whether hsync,vsync are necesary
        if (colcount > 15 && colcount < 112) begin    //Check if we are now in hsync territory
          if (rowcount < 2) begin                     //Check if we are also in vsync territory
            nxt_state = BOTH2;                      //If yes then go to both
          end
          else begin
            nxt_state = HSYNC2;             //If no then go to hsync state
          end
        end

        else if (rowcount < 2) begin            //Check if we are just in vsync
          nxt_state = VSYNC2;                   //If yes then go to vsync state
        end

        else if (rowcount > 44 && ((colcount == 159) || (colcount == 158))) begin     //Check if we are in the guard band
          nxt_state = GUARD2;                                 //If Yes then go to Guard state
        end

        else if ((rowcount > 44) && (colcount > 159)) begin
          nxt_state = VIDEO2;
        end

        else begin
          nxt_state = PREAMBLE2;                                //Else go to None state
        end

  end
      end

      VIDEO1: begin
  if(pixelclk) begin
        //Check where you are in the blanking to determine whether hsync,vsync are necesary
        if (colcount > 15 && colcount < 112) begin    //Check if we are now in hsync territory
          if (rowcount < 2) begin                     //Check if we are also in vsync territory
            nxt_state = BOTH2;                      //If yes then go to both
          end
          else begin
            nxt_state = HSYNC2;             //If no then go to hsync state
          end
        end

        else if (rowcount < 2) begin            //Check if we are just in vsync
          nxt_state = VSYNC2;                   //If yes then go to vsync state
        end

        else if (rowcount > 44 && ((colcount == 159) || (colcount == 158))) begin     //Check if we are in the guard band
          nxt_state = GUARD2;                                 //If Yes then go to Guard state
        end

        else if ((rowcount > 44) && (colcount > 159)) begin
          nxt_state = VIDEO2;
        end

        else begin
          nxt_state = PREAMBLE2;                                //Else go to None state
        end

  end
      end

      BOTH2: begin
  if(pixelclk) begin
        if (colcount > 15 && colcount < 112) begin  //Check if we are now in hsync territory
          if (rowcount < 2) begin                   //Check if we are also in vsync territory
            nxt_state = BOTH1;                    //If yes then go to both
          end
          else begin
            nxt_state = HSYNC1;               //If no then go to hsync state
          end
        end

        else if (rowcount < 2) begin              //Check if we are just in vsync
          nxt_state = VSYNC1;                     //If yes then go to vsync state
        end

        else if (rowcount > 44 && ((colcount == 159) || (colcount == 158))) begin   //Check if we are in the guard band
          nxt_state = GUARD1;                               //If Yes then go to Guard state
        end

        else if ((rowcount > 44) && (colcount > 159)) begin
          nxt_state = VIDEO1;
        end

        else begin
          nxt_state = PREAMBLE1;                      //Else go to None state
        end

  end
      end

      HSYNC2: begin
  if(pixelclk) begin
        if (colcount > 15 && colcount < 112) begin  //Check if we are now in hsync territory
          if (rowcount < 2) begin                   //Check if we are also in vsync territory
            nxt_state = BOTH1;                    //If yes then go to both
          end
          else begin
            nxt_state = HSYNC1;               //If no then go to hsync state
          end
        end

        else if (rowcount < 2) begin              //Check if we are just in vsync
          nxt_state = VSYNC1;                     //If yes then go to vsync state
        end

        else if (rowcount > 44 && ((colcount == 159) || (colcount == 158))) begin   //Check if we are in the guard band
          nxt_state = GUARD1;                               //If Yes then go to Guard state
        end

        else if ((rowcount > 44) && (colcount > 159)) begin
          nxt_state = VIDEO1;
        end

        else begin
          nxt_state = PREAMBLE1;                      //Else go to None state
        end

  end
      end

      VSYNC2: begin
  if(pixelclk) begin
        if (colcount > 15 && colcount < 112) begin  //Check if we are now in hsync territory
          if (rowcount < 2) begin                   //Check if we are also in vsync territory
            nxt_state = BOTH1;                    //If yes then go to both
          end
          else begin
            nxt_state = HSYNC1;               //If no then go to hsync state
          end
        end

        else if (rowcount < 2) begin              //Check if we are just in vsync
          nxt_state = VSYNC1;                     //If yes then go to vsync state
        end

        else if (rowcount > 44 && ((colcount == 159) || (colcount == 158))) begin   //Check if we are in the guard band
          nxt_state = GUARD1;                               //If Yes then go to Guard state
        end

        else if ((rowcount > 44) && (colcount > 159)) begin
          nxt_state = VIDEO1;
        end

        else begin
          nxt_state = PREAMBLE1;                      //Else go to None state
        end

  end
      end

      GUARD2: begin
  if(pixelclk) begin
        if (colcount > 15 && colcount < 112) begin  //Check if we are now in hsync territory
          if (rowcount < 2) begin                   //Check if we are also in vsync territory
            nxt_state = BOTH1;                    //If yes then go to both
          end
          else begin
            nxt_state = HSYNC1;               //If no then go to hsync state
          end
        end

        else if (rowcount < 2) begin              //Check if we are just in vsync
          nxt_state = VSYNC1;                     //If yes then go to vsync state
        end

        else if (rowcount > 44 && ((colcount == 159) || (colcount == 158))) begin   //Check if we are in the guard band
          nxt_state = GUARD1;                               //If Yes then go to Guard state
        end

        else if ((rowcount > 44) && (colcount > 159)) begin
          nxt_state = VIDEO1;
        end

        else begin
          nxt_state = PREAMBLE1;                      //Else go to None state
        end

  end
      end

      PREAMBLE2: begin
  if(pixelclk) begin
        if (colcount > 15 && colcount < 112) begin  //Check if we are now in hsync territory
          if (rowcount < 2) begin                   //Check if we are also in vsync territory
            nxt_state = BOTH1;                    //If yes then go to both
          end
          else begin
            nxt_state = HSYNC1;               //If no then go to hsync state
          end
        end

        else if (rowcount < 2) begin              //Check if we are just in vsync
          nxt_state = VSYNC1;                     //If yes then go to vsync state
        end

        else if (rowcount > 44 && ((colcount == 159) || (colcount == 158))) begin   //Check if we are in the guard band
          nxt_state = GUARD1;                               //If Yes then go to Guard state
        end

        else if ((rowcount > 44) && (colcount > 159)) begin
          nxt_state = VIDEO1;
        end

        else begin
          nxt_state = PREAMBLE1;                      //Else go to None state
        end

  end
      end

      VIDEO2: begin
  if(pixelclk) begin
        if (colcount > 15 && colcount < 112) begin  //Check if we are now in hsync territory
          if (rowcount < 2) begin                   //Check if we are also in vsync territory
            nxt_state = BOTH1;                    //If yes then go to both
          end
          else begin
            nxt_state = HSYNC1;               //If no then go to hsync state
          end
        end

        else if (rowcount < 2) begin              //Check if we are just in vsync
          nxt_state = VSYNC1;                     //If yes then go to vsync state
        end

        else if (rowcount > 44 && ((colcount == 159) || (colcount == 158))) begin   //Check if we are in the guard band
          nxt_state = GUARD1;                               //If Yes then go to Guard state
        end

        else if ((rowcount > 44) && (colcount > 159)) begin
          nxt_state = VIDEO1;
        end

        else begin
          nxt_state = PREAMBLE1;                      //Else go to None state
        end

  end
      end

    endcase
  end


  always@(state) begin: output_logic        //Describe the Output Logic

  rowtimerenable = 1;
  coltimerenable = 1;
  shift1load = 1;
  shift2load = 0;
  shiftmuxsel = 1;
        n_vsync = 0;
        n_hsync = 0;
  outputmuxsel = 2'b00;

    case(state)

      BOTH1: begin

        shift1load = 1;
  shift2load = 0;
  shiftmuxsel = 1;
        n_vsync = 0;
        n_hsync = 0;
  outputmuxsel = 2'b00;

      end

      HSYNC1: begin

        shift1load = 1;
  shift2load = 0;
  shiftmuxsel = 1;
        n_vsync = 1;
        n_hsync = 0;
  outputmuxsel = 2'b00;

      end

      VSYNC1: begin

        shift1load = 1;
  shift2load = 0;
  shiftmuxsel = 1;
        n_vsync = 0;
        n_hsync = 1;
  outputmuxsel = 2'b00;

      end

      GUARD1: begin

        shift1load = 1;
  shift2load = 0;
  shiftmuxsel = 1;
        n_vsync = 1;
        n_hsync = 1;
        outputmuxsel = 2'b01;

      end

      PREAMBLE1: begin

        shift1load = 1;
  shift2load = 0;
  shiftmuxsel = 1;
        n_vsync = 1;
        n_hsync = 1;
  outputmuxsel = 2'b00;

      end

      VIDEO1: begin

        shift1load = 1;
  shift2load = 0;
  shiftmuxsel = 1;
        n_vsync = 1;
        n_hsync = 1;
        outputmuxsel = 2'b10;

      end

      BOTH2: begin

        shift1load = 0;
        shift2load = 1;
  shiftmuxsel = 0;
        n_vsync = 0;
        n_hsync = 0;
  outputmuxsel = 2'b00;

      end

      HSYNC2: begin

        shift1load = 0;
        shift2load = 1;
  shiftmuxsel = 0;
        n_vsync = 1;
        n_hsync = 0;
  outputmuxsel = 2'b00;

      end

      VSYNC2: begin

        shift1load = 0;
        shift2load = 1;
  shiftmuxsel = 0;
        n_vsync = 0;
        n_hsync = 1;
  outputmuxsel = 2'b00;

      end

      GUARD2: begin

        shift1load = 0;
        shift2load = 1;
  shiftmuxsel = 0;
        n_vsync = 1;
        n_hsync = 1;
  outputmuxsel = 2'b01;

      end

      PREAMBLE2: begin

        shift1load = 0;
        shift2load = 1;
  shiftmuxsel = 0;
        n_vsync = 1;
        n_hsync = 1;
  outputmuxsel = 2'b00;

      end

      VIDEO2: begin

        shift1load = 0;
        shift2load = 1;
  shiftmuxsel = 0;
        n_vsync = 1;
        n_hsync = 1;
        outputmuxsel = 2'b10;

      end

    endcase

  end




 endmodule
