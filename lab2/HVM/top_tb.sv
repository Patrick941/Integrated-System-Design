module top_tb ();

wire clk, reset, a, b, inc_exp, dec_exp;
wire [3:0] count;
   
    stim_gen u_stim_gen (
        .clk(clk),
        .reset(reset),
        .a(a),
        .b(b),
        .inc_exp(inc_exp),
        .dec_exp(dec_exp),
        .count(count)
    );

    scoreboard u_scoreboard (
        .clk(clk),
        .reset(reset),
        .inc_exp(inc_exp),
        .dec_exp(dec_exp),
        .count(count)
    );

    // initial begin
    //     $monitor("reset=%b a=%b b=%b inc_exp=%b dec_exp=%b", reset, a, b, inc_exp, dec_exp);
    // end


endmodule