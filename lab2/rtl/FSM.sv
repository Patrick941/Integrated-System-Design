module FSM (
    input clk,
    input reset,
    input [2:0] current_state,
    input [3:0] btn,
    output reg [2:0] next_state,
    output reg entered,
    output reg exited
);

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

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            next_state = 3'b000;
            entered = 0;
            exited = 0;
        end else begin
            next_state = current_state;
            entered = 0;
            exited = 0;
            case (current_state)
                3'b000: begin
                    if (a && !b) begin
                        next_state = 3'b001;
                    end
                    else if (a && b) begin
                        next_state = 3'b000; // Should never occur return to default state
                    end
                    else if (!a && b) begin
                        next_state = 3'b100;
                    end
                end
                3'b001: begin
                    if (!a && !b) begin
                        next_state = 3'b000;
                    end
                    else if (a && b) begin
                        next_state = 3'b010;
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
                        next_state = 3'b001;
                    end
                    else if (!a && b) begin
                        next_state = 3'b011;
                    end
                end
                3'b011: begin
                    if (a && !b) begin
                        next_state = 3'b000; // Should never occur return to default state
                    end
                    else if (a && b) begin
                        next_state = 3'b010;
                    end
                    else if (!a && !b) begin
                        next_state = 3'b000;
                        entered = 1;
                    end
                end
                3'b100: begin
                    if (a && !b) begin
                        next_state = 3'b000; // Should never occur return to default state
                    end
                    else if (!a && !b) begin
                        next_state = 3'b000;
                    end
                    else if (a && b) begin
                        next_state = 3'b101;
                    end
                end
                3'b101: begin
                    if (!a && !b) begin
                        next_state = 3'b000; // Should never occur return to default state
                    end
                    else if (a && !b) begin
                        next_state = 3'b110;
                    end
                    else if (!a && b) begin
                        next_state = 3'b100;
                    end
                end
                3'b110: begin
                    if (!a && b) begin
                        next_state = 3'b000; // Should never occur return to default state
                    end
                    else if (a && b) begin
                        next_state = 3'b101;
                    end
                    else if (!a && !b) begin
                        next_state = 3'b000;
                        exited = 1;
                    end
                end
            endcase
        end
    end
endmodule