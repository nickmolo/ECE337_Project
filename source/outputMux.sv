//Filename: outputMux.sv
//Description: used by the output controller to output either video data, blanking data, or guard data. 

module outputMux
    
  (
    input wire [9:0]videoData,
    input wire [9:0]blankData,
    input wire [9:0]guardData,
    input wire [1:0]sel,
    output reg [9:0]out
  );
    
    //Output mux logic
    
    always @ (*) begin
    
        //If select line is 0, output blanking values
        
        if(sel == 2'b00) begin
                
                out = blankData;
                
        end
        
        //If select line is 1, output guard values
        
        else if(sel == 2'b01) begin
                
                out = guardData;
                   
        end
        
        //If select line is 2, output blanking values
        
        else if(sel == 2'b10) begin
                
                out = videoData;
                
        end
        
        else begin
                
             out = blankData; 
                
        end
        
    end
endmodule

