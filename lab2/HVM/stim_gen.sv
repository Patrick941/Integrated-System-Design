module stim_gen (
    output reg clk,
    output reg reset,
    output reg a,
    output reg b,
    output reg inc_exp,
    output reg dec_exp
);
    reg count;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $monitor("clk=%b reset=%b a=%b b=%b inc_exp=%b dec_exp=%b count=%b", clk, reset, a, b, inc_exp, dec_exp, count);
    end

    initial begin
        generate_entered;
        generate_entered;
        generate_exited;
    end

    counter u_counter (
        .clk(clk),
        .reset(reset),
        .btn({a, b}),
        .count(count),
        .debug_state()
    );

    task automatic generate_entered;
        begin
            reset = 1;
            #10;
            a = 0;
            b = 0;
            #10;
            a = 1;
            b = 0;
            #10;
            a = 1;
            b = 1;
            #10;
            a = 0;
            b = 1;
            #10;
            a = 0;
            b = 0;
            inc_exp = 1;
            #10;
        end
    endtask

    task automatic generate_exited;
        begin
            reset = 1;
            #10;
            a = 0;
            b = 0;
            #10;
            a = 0;
            b = 1;
            #10;
            a = 1;
            b = 1;
            #10;
            a = 1;
            b = 0;
            #10;
            a = 0;
            b = 0;
            dec_exp = 1;
            #10;
            
        end
    endtask
endmodule