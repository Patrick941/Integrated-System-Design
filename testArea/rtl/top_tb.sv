module top_tb ();

reg [3:0] a;
reg signed [2:0] b;
reg signed [1:0] c;
reg signed [3:0] d1;
reg signed [3:0] d2;
reg signed [3:0] d3;

assign a = 4'd13;
assign b = 3'd2;
assign c = -2'd1;

assign d1 = a;
assign d2 = $signed(a) + c[0];
assign d3 = $signed(a) + b;

initial begin
    $display("a = %d, b = %d, c = %d", a, b, c);
    $display("d1 = %d, d2 = %d, d3 = %d", d1, d2, d3);
    $finish;
end

endmodule