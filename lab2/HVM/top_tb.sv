module top_tb ();
// Declare internal signals for connecting modules
wire clk, reset, a, b, inc_exp, dec_exp, inc_act, dec_act;
wire [3:0] count, local_count;
   
    // Instantiate the clock generator
    stim_gen u_stim_gen (
        .clk(clk),
        .reset(reset),
        .a(a),
        .b(b),
        .inc_exp(inc_exp),
        .dec_exp(dec_exp)
    );

    // Instantiate the counter module
    counter u_counter (
        .clk(clk),
        .reset(reset),
        .btn({b, a}),
        .count(count),
        .debug_state(),
        .inc_act(inc_act),
        .dec_act(dec_act)
    );

    // Instantiate the scoreboard module
    scoreboard u_scoreboard (
        .clk(clk),
        .reset(reset),
        .inc_exp(inc_exp),
        .dec_exp(dec_exp),
        .count(count),
        .a(a),
        .b(b),
        .inc_act(inc_act),
        .dec_act(dec_act),
        .local_count(local_count)
    );

endmodule