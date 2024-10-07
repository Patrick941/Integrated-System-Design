module stim_gen (
    output reg clk,
    output reg reset,
    output reg a,
    output reg b,
    output reg inc_exp,
    output reg dec_exp
);
    wire [3:0] count;
    wire [2:0] debug_state;
    reg [2:0] state_tracker;

    reg [2:0] faildepth;
    reg failed;

    initial begin
        clk = 0;
        a = 0;
        b = 0;
        inc_exp = 0;
        dec_exp = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 1;
        #100;
        reset = 0;
    end

    initial begin
        generate_entered(6);
        generate_fail_entered(3);
        generate_entered(15);
        generate_exited(6);
        generate_fail_exited(3);
        generate_exited(15);
        $finish;
    end

    task automatic generate_entered(input int loop_count);
        int i;
        begin
            for (i = 0; i < loop_count; i++) begin
                state_tracker = 0;
                a = 0;
                b = 0;
                #100;
                while (inc_exp == 0) begin
                    if ( state_tracker == 0 ) begin
                        b = 0;
                        a = $urandom_range(0, 1);
                        if ( a == 1) begin
                            state_tracker = 1;
                        end
                        #100;
                    end
                    else if ( state_tracker == 1 ) begin
                        a = 1;
                        b = $urandom_range(0, 1);
                        if ( b == 1) begin
                            state_tracker = 2;
                        end
                        #100;
                    end
                    else if ( state_tracker == 2 ) begin
                        b = 1;
                        a = $urandom_range(0, 1);
                        if ( a == 0) begin
                            state_tracker = 3;
                        end
                        #100;
                    end
                    else if ( state_tracker == 3 ) begin
                        a = 0;
                        b = $urandom_range(0, 1);
                        if ( b == 0) begin
                            #20;
                            inc_exp = 1;
                        end
                        #100;
                    end
                end 
                inc_exp = 0;
            end
        end
    endtask

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

    task automatic generate_exited(input int loop_count);
        int i;
        begin
            for (i = 0; i < loop_count; i++) begin
                state_tracker = 0;
                a = 0;
                b = 0;
                #100;
                while (dec_exp == 0) begin
                    if ( state_tracker == 0 ) begin
                        a = 0;
                        b = $urandom_range(0, 1);
                        if ( b == 1) begin
                            state_tracker = 4;
                        end
                        #100;
                    end
                    else if ( state_tracker == 4 ) begin
                        b = 1;
                        a = $urandom_range(0, 1);
                        if ( a == 1) begin
                            state_tracker = 5;
                        end
                        #100;
                    end
                    else if ( state_tracker == 5 ) begin
                        a = 1;
                        b = $urandom_range(0, 1);
                        if ( b == 0) begin
                            state_tracker = 6;
                        end
                        #100;
                    end
                    else if ( state_tracker == 6 ) begin
                        b = 0;
                        a = $urandom_range(0, 1);
                        if ( a == 0) begin
                            #20;
                            dec_exp = 1;
                        end
                        #100;
                    end
                end 
                dec_exp = 0;
            end
        end
    endtask

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