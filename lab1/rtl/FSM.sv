module FSM (
    input clk,
    input reset,
    input current_state,
    input [3:0] btn,
    output reg next_state,
    output reg entered,
    output reg exited
);

    wire a, b;

    debouncer #(.threshold(100000)) u_debouncer_a (
        .clk(clk),
        .reset(reset),
        .button(btn[0]),
        .button_db(a)
    );

    debouncer #(.threshold(100000)) u_debouncer_b (
        .clk(clk),
        .reset(reset),
        .button(btn[1]),
        .button_db(b)
    );

    typedef enum logic [2:0] {
        S0 = 3'b000,
        S1 = 3'b001,
        S2 = 3'b010,
        S3 = 3'b011,
        S4 = 3'b100
    } state_t;

    state_t state, next_state_internal;

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            state <= S0;
        else
            state <= next_state_internal;
    end

    always_comb begin
        next_state_internal = state;
        entered = 0;
        exited = 0;
        case (state)
            S0: begin
                if (a && !b)
                    next_state_internal = S1;
                else if (!a && b)
                    next_state_internal = S3;
            end
            S1: begin
                if (!a && !b)
                    next_state_internal = S0;
                else if (!a && b)
                    next_state_internal = S2;
            end
            S2: begin
                if (!a && !b) begin
                    next_state = S0;
                    entered = 1;
                end else if (a && !b)
                    next_state = S1;
            end
            S3: begin
                if (!a && !b)
                    next_state = S0;
                else if (a && !b)
                    next_state_internal = S4;
            end
            S4: begin
                if (!a && !b) begin
                    next_state = S0;
                    exited = 1;
                end else if (!a && b)
                    next_state = S3;
            end
        endcase
    end
endmodule