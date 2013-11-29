module addr_bit_flip
    (
    input wire clk,
    input wire n_rst,
    input wire frameswap,
    output reg addr_bit
    );
    
    always @ (posedge clk, negedge n_rst) begin
       if (n_rst == 0) begin
         addr_bit <= 0;
       end
       else if (frameswap == 1) begin
         addr_bit <= !addr_bit;
       end
       else begin
         addr_bit <= addr_bit;
       end
       
    end
    
 endmodule