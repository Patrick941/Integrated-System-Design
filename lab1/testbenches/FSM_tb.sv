module FSM_tb;
    reg clk;
    reg reset;
    reg [3:0] btn;
    reg [2:0] current_state; 
    reg [2:0] next_state;
    reg entered;
    reg exited;

    FSM fsm (
        .clk(clk),
        .reset(reset),
        .current_state(current_state),
        .btn(btn),
        .next_state(next_state),
        .entered(entered),
        .exited(exited)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    always @(next_state) begin
        current_state = next_state;
    end

    initial begin
        $monitor("Time: %0t | clk: %b | reset: %b | btn: %b | current_state: %b | next_state: %b | entered: %b | exited: %b", 
                $time, clk, reset, btn, current_state, next_state, entered, exited);
    end

    initial begin
        reset = 1;
        btn = 4'b0000;
        next_state = 3'b000;
        entered = 1'b0;
        exited = 1'b0;
        #10;
        
        reset = 0;
        #10;

        btn[0] = 1;
        #10;
        btn[0] = 0;
        if (current_state != 3'b001) $display("Error: Expected state S1, got %b", current_state);
        #10;

        btn[1] = 1;
        #10;
        btn[1] = 0;
        if (current_state != 3'b011) $display("Error: Expected state S3, got %b", current_state);
        #10;

        if (current_state != 3'b000) $display("Error: Expected state S0, got %b", current_state);
        #10;

        btn[1] = 1;
        #10;
        btn[0] = 1;
        #10;
        btn[0] = 0;
        btn[1] = 0;
        #10;
        if (exited != 1'b1) $display("Error: Expected exited to be 1, got %b", exited);
        if (current_state != 3'b000) $display("Error: Expected state S0, got %b", current_state);
        #10;

        if (current_state != 3'b000) $display("Error: Expected state S0, got %b", current_state);
        #10;

        $finish;
    end

endmodule