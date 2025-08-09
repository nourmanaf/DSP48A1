module REG #(
    parameter WIDTH = 1, // Width of the register,
    parameter RSSTYPE = "SYNC"  // Default TYPE of reset
    )(
    input wire clk,CE,
    input wire rst,
    input wire [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out
);
    generate
    if (RSSTYPE == "ASYNC") begin 
            always @(posedge clk or posedge rst) begin 
                if (rst)  
                    data_out <= {WIDTH{1'b0}}; 
                else if (CE) 
                    data_out <= data_in; 
            end 
        end 
        else begin // If -> RSTTYPE = "SYNC" 
            always @(posedge clk) begin 
                if (rst)  
                    data_out <= {WIDTH{1'b0}}; 
                else if (CE) 
                    data_out <= data_in;
        end
    end
    endgenerate

endmodule