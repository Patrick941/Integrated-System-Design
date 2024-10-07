module counter (
    // Declare module inputs and outputs
    input clk,
    input reset,
    input [3:0] btn,
    output [3:0] count,
    output [2:0] debug_state,
    output inc_act,
    output dec_act
);

    // Declare internal signals
    reg [2:0] current_state;
    wire [2:0] next_state;
    wire entered;
    wire exited;
    reg [3:0] count_reg;

    // Assign output signals of increment and decrement from entered and exited
    assign inc_act = entered;
    assign dec_act = exited;

    // Instantiate the FSM module
    FSM u_fsm (
        .clk(clk),
        .reset(reset),
        .current_state(current_state),
        .btn(btn),
        .next_state(next_state),
        .entered(entered),
        .exited(exited)
    );

    // Implement the counter logic using entered and exited signals
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count_reg <= 4'b0;
            current_state <= 3'b000;
        end else begin
            current_state <= next_state;
            if (entered && current_state == 3'b011 && count_reg != 4'b1111) begin
                count_reg <= count_reg + 1;
            end
            if (exited && current_state == 3'b110 && count_reg != 4'b0000) begin
                count_reg <= count_reg - 1;
            end
        end
    end

    // Assign the count and debug_state signals
    assign count = count_reg;
    assign debug_state = current_state;

endmodule