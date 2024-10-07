module top (
    // Declare module inputs and outputs for physical connections
    input sysclk,
    input [3:0] btn,
    output [3:0] led
);
    // Declare internal signal for assignment to physical input and outputs
    wire [3:0] count;
    wire [2:0] debug_state;
    wire clk;

    counter u_counter (
        .clk(clk),
        .reset(reset),
        .btn(btn),
        .count(count),
        .debug_state(debug_state)
    );

    // Assign the physical inputs and outputs
    assign reset = btn[3];
    assign led = count;
    assign clk = sysclk;

endmodule