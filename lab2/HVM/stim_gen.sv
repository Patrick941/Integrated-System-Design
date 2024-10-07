module stim_gen (
    // Declare module outputs
    output reg clk,
    output reg reset,
    output reg a,
    output reg b,
    output reg inc_exp,
    output reg dec_exp
);
    // Declare internal signals
    wire [3:0] count;
    wire [2:0] debug_state;
    reg [2:0] state_tracker;

    // Declare fail signals for the failed test cases
    reg [2:0] faildepth;
    reg failed;

    // Declare initial signal states and create clock
    initial begin
        clk = 1;
        a = 0;
        b = 0;
        inc_exp = 0;
        dec_exp = 0;
        forever #5 clk = ~clk;
    end

    // Release reset
    initial begin
        reset = 1;
        #100;
        reset = 0;
    end

    // Generate test cases for entered and exited signals to create full car park and empty car park scenarios
    initial begin
        generate_entered(6);
        generate_fail_entered(3);
        generate_entered(15);
        generate_exited(6);
        generate_fail_exited(3);
        generate_exited(15);
        $finish;
    end

    // Task to generate entered signal test case for a given number of loops
    task automatic generate_entered(input int loop_count);
        int i;
        begin
            for (i = 0; i < loop_count; i++) begin
                // Intiaite the state tracker and signals
                state_tracker = 0;
                a = 0;
                b = 0;
                #100;
                while (inc_exp == 0) begin
                    // State has a 1/2 chance of staying or advancing to state 1
                    if ( state_tracker == 0 ) begin
                        b = 0;
                        a = $urandom_range(0, 1);
                        if ( a == 1) begin
                            state_tracker = 1;
                        end
                        #100;
                    end
                    // State has a 1/2 chance of staying or advancing to state 2
                    else if ( state_tracker == 1 ) begin
                        a = 1;
                        b = $urandom_range(0, 1);
                        if ( b == 1) begin
                            state_tracker = 2;
                        end
                        #100;
                    end
                    // State has a 1/2 chance of staying or advancing to state 3
                    else if ( state_tracker == 2 ) begin
                        b = 1;
                        a = $urandom_range(0, 1);
                        if ( a == 0) begin
                            state_tracker = 3;
                        end
                        #100;
                    end
                    // State has a 1/2 chance of staying or outputting increment and returning to state 0
                    else if ( state_tracker == 3 ) begin
                        a = 0;
                        b = $urandom_range(0, 1);
                        if ( b == 0) begin
                            #10;
                            inc_exp = 1;
                            #20;
                        end else begin
                            #100;
                        end
                    end
                end 
                inc_exp = 0;
            end
        end
    endtask

    // Task to generate failed entered signal test case for a given number of loops
    task automatic generate_fail_entered(input int loop_count);
        int i;
        begin
            for (i = 0; i < loop_count; i++) begin
                faildepth = $urandom_range(0, 2);
                failed = 0;
                state_tracker = 0;
                a = 0;
                b = 0;
                #100;
                while (failed == 0) begin
                    // If the fail depth is not 0 there is a 1/2 chance of staying or advancing to state 1, if the fail depth is 0 the state will receive an invalid input and exit
                    if ( state_tracker == 0 ) begin
                        if (faildepth == 0) begin
                            a = 1;
                            b = 1;
                            failed = 1;
                            #100;
                        end
                        else begin
                            b = 0;
                            a = $urandom_range(0, 1);
                            if ( a == 1) begin
                                state_tracker = 1;
                            end
                            #100;
                        end
                    end
                    // If the fail depth is not 1 there is a 1/2 chance of staying or advancing to state 2, if the fail depth is 1 the state will receive an invalid input and exit
                    else if ( state_tracker == 1 ) begin
                        if (faildepth == 1) begin
                            a = 0;
                            b = 1;
                            failed = 1;
                            #100;
                        end
                        else begin
                            a = 1;
                            b = $urandom_range(0, 1);
                            if ( b == 1) begin
                                state_tracker = 2;
                            end
                            #100;
                        end
                    end
                    // If the fail depth is not 2 there is a 1/2 chance of staying or advancing to state 3, if the fail depth is 2 the state will receive an invalid input and exit
                    else if ( state_tracker == 2 ) begin
                        if (faildepth == 2) begin
                            b = 0;
                            a = 0;
                            failed = 1;
                            #100;
                        end
                        else begin
                            b = 1;
                            a = $urandom_range(0, 1);
                            if ( a == 0) begin
                                state_tracker = 3;
                            end
                            #100;
                        end
                    end
                    // State will fail and return to state 0
                    else if ( state_tracker == 3 ) begin
                        a = 1;
                        b = 0;
                        failed = 1;
                        #100;
                    end
                end 
                inc_exp = 0;
            end
        end
    endtask

    // Task to generate exited signal test case for a given number of loops
    task automatic generate_exited(input int loop_count);
        int i;
        begin
            for (i = 0; i < loop_count; i++) begin
                state_tracker = 0;
                a = 0;
                b = 0;
                #100;
                while (dec_exp == 0) begin
                    // State has a 1/2 chance of staying or advancing to state 4
                    if ( state_tracker == 0 ) begin
                        a = 0;
                        b = $urandom_range(0, 1);
                        if ( b == 1) begin
                            state_tracker = 4;
                        end
                        #100;
                    end
                    // State has a 1/2 chance of staying or advancing to state 5
                    else if ( state_tracker == 4 ) begin
                        b = 1;
                        a = $urandom_range(0, 1);
                        if ( a == 1) begin
                            state_tracker = 5;
                        end
                        #100;
                    end
                    // State has a 1/2 chance of staying or advancing to state 6
                    else if ( state_tracker == 5 ) begin
                        a = 1;
                        b = $urandom_range(0, 1);
                        if ( b == 0) begin
                            state_tracker = 6;
                        end
                        #100;
                    end
                    // State has a 1/2 chance of staying or outputting decrement and returning to state 0
                    else if ( state_tracker == 6 ) begin
                        b = 0;
                        a = $urandom_range(0, 1);
                        if ( a == 0) begin
                            #10;
                            dec_exp = 1;
                            #20;
                        end else begin
                            #100;
                        end
                    end
                end 
                dec_exp = 0;
            end
        end
    endtask

    // Task to generate failed exited signal test case for a given number of loops
    task automatic generate_fail_exited(input int loop_count);
        int i;
        begin
            for (i = 0; i < loop_count; i++) begin
                faildepth = $urandom_range(0, 2);
                failed = 0;
                state_tracker = 0;
                a = 0;
                b = 0;
                #100;
                while (failed == 0) begin
                    // If the fail depth is not 0 there is a 1/2 chance of staying or advancing to state 4, if the fail depth is 0 the state will receive an invalid input and exit
                    if ( state_tracker == 0 ) begin
                        if (faildepth == 0) begin
                            a = 1;
                            b = 1;
                            failed = 1;
                            #100;
                        end
                        else begin
                            a = 0;
                            b = $urandom_range(0, 1);
                            if ( b == 0) begin
                                state_tracker = 4;
                            end
                            #100;
                        end
                    end
                    // If the fail depth is not 1 there is a 1/2 chance of staying or advancing to state 5, if the fail depth is 1 the state will receive an invalid input and exit
                    else if ( state_tracker == 4 ) begin
                        if (faildepth == 1) begin
                            b = 0;
                            a = 1;
                            failed = 1;
                            #100;
                        end
                        else begin
                            b = 1;
                            a = $urandom_range(0, 1);
                            if ( a == 1) begin
                                state_tracker = 5;
                            end
                            #100;
                        end
                    end
                    // If the fail depth is not 2 there is a 1/2 chance of staying or advancing to state 6, if the fail depth is 2 the state will receive an invalid input and exit
                    else if ( state_tracker == 5 ) begin
                        if (faildepth == 2) begin
                            a = 0;
                            b = 0;
                            failed = 1;
                            #100;
                        end
                        else begin
                            a = 1;
                            b = $urandom_range(0, 1);
                            if ( b == 0) begin
                                state_tracker = 6;
                            end
                            #100;
                        end
                    end
                    // State will fail and return to state 0
                    else if ( state_tracker == 6 ) begin
                            b = 1;
                            a = 0;
                            failed = 1;
                            #100;
                    end
                end 
                dec_exp = 0;
            end
        end
    endtask
endmodule