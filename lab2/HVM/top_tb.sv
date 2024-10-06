module top_tb ();

wire clk, reset, a, b, inc_exp, dec_exp;
wire [3:0] count;
   
    stim_gen u_stim_gen (
        .clk(clk),
        .reset(reset),
        .a(a),
        .b(b),
        .inc_exp(inc_exp),
        .dec_exp(dec_exp)
    );

    counter u_counter (
        .clk(clk),
        .reset(reset),
        .btn({b, a}),
        .count(count),
        .debug_state()
    );

    scoreboard u_scoreboard (
        .clk(clk),
        .reset(reset),
        .inc_exp(inc_exp),
        .dec_exp(dec_exp),
        .count(count)
    );

endmodule