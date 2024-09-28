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
    assign a = btn[0];
    assign b = btn[1];

    // debouncer #(.threshold(100000)) u_debouncer_a (
    //     .clk(clk),
    //     .reset(reset),
    //     .button(btn[0]),
    //     .button_db(a)
    // );
    // debouncer #(.threshold(100000)) u_debouncer_b (
    //     .clk(clk),
    //     .reset(reset),
    //     .button(btn[1]),
    //     .button_db(b)
    // );

    always @(posedge clk) begin
        next_state = current_state;
        entered = 0;
        exited = 0;
        case (current_state)
            3'b000: begin
                if (a && !b)
                    next_state = 3'b001;
                else if (!a && b)
                    next_state = 3'b011;
            end
            3'b001: begin
                if (!a && !b)
                    next_state = 3'b000;
                else if (!a && b)
                    next_state = 3'b010;
            end
            3'b010: begin
                if (!a && !b) begin
                    next_state = 3'b000;
                    entered = 1;
                end else if (a && !b)
                    next_state = 3'b001;
            end
            3'b011: begin
                if (!a && !b)
                    next_state = 3'b000;
                else if (a && b)
                    next_state = 3'b100;
                else if (a && !b)
                    next_state = 3'b100;
            end
            3'b100: begin
                if (!a && !b) begin
                    next_state = 3'b000;
                    exited = 1;
                end else if (!a && b)
                    next_state = 3'b011;
                else if (a && b)
                    next_state = 3'b011;
            end
        endcase
    end
endmodule