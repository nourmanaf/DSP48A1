module MUX #(
    parameter WIDTH = 1, // Width of the Mux,
    parameter NUM_INPUTS = 2  // Default Number of Inputs
    )(
    input  [WIDTH-1:0] IN0,
    input  [WIDTH-1:0] IN1,
    input  [WIDTH-1:0] IN2,
    input  [WIDTH-1:0] IN3,
    input  [$clog2(NUM_INPUTS)-1:0] sel,
    output reg [WIDTH-1:0] data_out
);
    always @(*) begin
        case (sel)
            2'b00: data_out = IN0;
            2'b01: data_out = IN1;
            2'b10: data_out = IN2;
            2'b11: data_out = IN3;
            default: data_out = {WIDTH{1'b0}}; // Default case
        endcase
    end

endmodule