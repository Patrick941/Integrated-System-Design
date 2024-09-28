module FSM_tb;

    // Inputs
    reg clk;
    reg reset;
    reg [3:0] btn;

    // Outputs
    wire [2:0] current_state; // Assuming current_state is 3 bits wide
    wire next_state;
    wire entered;
    wire exited;

    // Instantiate the FSM module
    FSM uut (
        .clk(clk),
        .reset(reset),
        .current_state(current_state),
        .btn(btn),
        .next_state(next_state),
        .entered(entered),
        .exited(exited)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period clock
    end

    // Test sequence
    initial begin
        // Initialize inputs
        reset = 1;
        btn = 4'b0000;
        #10;
        
        // Release reset
        reset = 0;
        #10;

        // Test case 1: Transition from S0 to S1
        btn[0] = 1;
        #10;
        btn[0] = 0;
        #10;
        if (current_state != 3'b001) $display("Error: Expected state S1, got %b", current_state);

        // Test case 2: Transition from S1 to S2
        btn[1] = 1;
        #10;
        btn[1] = 0;
        #10;
        if (current_state != 3'b010) $display("Error: Expected state S2, got %b", current_state);

        // Test case 3: Transition from S2 to S0 with entered signal
        #10;
        if (current_state != 3'b000) $display("Error: Expected state S0, got %b", current_state);

        // Test case 4: Transition from S0 to S3
        btn[1] = 1;
        #10;
        btn[1] = 0;
        #10;
        if (current_state != 3'b011) $display("Error: Expected state S3, got %b", current_state);

        // Test case 5: Transition from S3 to S4
        btn[0] = 1;
        #10;
        btn[0] = 0;
        #10;
        if (current_state != 3'b100) $display("Error: Expected state S4, got %b", current_state);

        // Test case 6: Transition from S4 to S0 with exited signal
        #10;
        if (current_state != 3'b000) $display("Error: Expected state S0, got %b", current_state);

        // Finish simulation
        $finish;
    end

endmodule