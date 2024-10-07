module FSM (
    // Declare module inputs and outputs
    input clk,
    input reset,
    input [2:0] current_state,
    input [3:0] btn,
    output reg [2:0] next_state,
    output reg entered,
    output reg exited
);

    // Create wires for a and b that are the debounced button signals
    wire a, b;

    debouncer #(.threshold(1)) u_debouncer_a (
        .clk(clk),
        .reset(reset),
        .button(btn[0]),
        .button_db(a)
    );
    debouncer #(.threshold(1)) u_debouncer_b (
        .clk(clk),
        .reset(reset),
        .button(btn[1]),
        .button_db(b)
    );

    // FSM logic
    always @(posedge clk or posedge reset) begin
        // If reset is high, reset the FSM
        if (reset) begin
            next_state = 3'b000;
            entered = 0;
            exited = 0;
        end else begin
            // Default state transitions
            next_state = current_state;
            entered = 0;
            exited = 0;
            // Case statement for FSM logic
            case (current_state)
                3'b000: begin
                    if (a && !b) begin
                        next_state = 3'b001; // Advance to state 1
                    end
                    else if (a && b) begin
                        next_state = 3'b000; // Should never occur return to default state
                    end
                    else if (!a && b) begin
                        next_state = 3'b100; // Advance to state 4
                    end
                end
                3'b001: begin
                    if (!a && !b) begin
                        next_state = 3'b000; // Return to state 0
                    end
                    else if (a && b) begin
                        next_state = 3'b010; // Advance to state 2
                    end
                    else if (!a && b) begin
                        next_state = 3'b000; // Should never occur return to default state
                    end
                end
                3'b010: begin
                    if (!a && !b) begin
                        next_state = 3'b000; // Should never occur return to default state
                    end
                    else if (a && !b) begin
                        next_state = 3'b001; // Return to state 1
                    end
                    else if (!a && b) begin
                        next_state = 3'b011; // Advance to state 3
                    end
                end
                3'b011: begin
                    if (a && !b) begin
                        next_state = 3'b000; // Should never occur return to default state
                    end
                    else if (a && b) begin
                        next_state = 3'b010; // Return to state 2
                    end
                    else if (!a && !b) begin
                        next_state = 3'b000; // Detected car entering, return to state 0
                        entered = 1;
                    end
                end
                3'b100: begin
                    if (a && !b) begin
                        next_state = 3'b000; // Should never occur return to default state
                    end
                    else if (!a && !b) begin
                        next_state = 3'b000; // Return to state 0
                    end
                    else if (a && b) begin
                        next_state = 3'b101; // Advance to state 5
                    end
                end
                3'b101: begin
                    if (!a && !b) begin
                        next_state = 3'b000; // Should never occur return to default state
                    end
                    else if (a && !b) begin
                        next_state = 3'b110; // Advance to state 6
                    end
                    else if (!a && b) begin
                        next_state = 3'b100; // Return to state 4
                    end
                end
                3'b110: begin
                    if (!a && b) begin
                        next_state = 3'b000; // Should never occur return to default state
                    end
                    else if (a && b) begin
                        next_state = 3'b101; // Return to state 5
                    end
                    else if (!a && !b) begin
                        next_state = 3'b000; // Detected car exiting, return to state 0
                        exited = 1;
                    end
                end
            endcase
        end
    end
endmodule