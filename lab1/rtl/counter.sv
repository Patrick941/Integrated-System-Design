module counter (
    input clk,
    input reset,
    input [3:0] btn,
    output [7:0] count,
    output [2:0] debug_state
);

    
    reg [2:0] current_state;
    wire [2:0] next_state;
    wire entered;
    wire exited;
    reg [7:0] count_reg;

    
    FSM u_fsm (
        .clk(clk),
        .reset(reset),
        .current_state(current_state),
        .btn(btn),
        .next_state(next_state),
        .entered(entered),
        .exited(exited)
    );

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count_reg <= 8'b0;
            current_state <= 3'b000;
        end else begin
            current_state <= next_state;
            if (entered && current_state == 3'b010) begin
                count_reg <= count_reg + 1;
            end
            if (exited && current_state == 3'b100) begin
                count_reg <= count_reg - 1;
            end
        end
    end

    
    assign count = count_reg;
    assign debug_state = current_state;

endmodule