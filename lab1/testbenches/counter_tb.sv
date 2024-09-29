module counter_tb;

  // Testbench signals
  reg clk;
  reg reset;
  reg [3:0] btn;
  reg [7:0] count;
  wire [2:0] debug_state;

  // Instantiate the counter module
  counter u_counter (
    .clk(clk),
    .reset(reset),
    .btn(btn),
    .count(count),
    .debug_state(debug_state)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 100 MHz clock
  end

  // Test sequence
  initial begin
    reset = 0;
    #20;
    reset = 1;
    #20;
    reset = 0;
    btn = 4'b0000;
    count = 0;

    btn[0] = 1;
    #1000;
    btn[1] = 1;
    #1000;
    btn[0] = 0;
    #1000;
    btn[1] = 0;
    #1000;
    if (count != 1) $display("Error: Expected count to be incremented to 1, got %b", count);
    else $display("Count Incremented to 1 correctly");

    btn[0] = 1;
    #1000;
    btn[1] = 1;
    #1000;
    btn[0] = 0;
    #1000;
    btn[1] = 0;
    #1000;
    if (count != 2) $display("Error: Expected count to be incremented to 2, got %b", count);
    else $display("Count Incremented to 2 correctly");


    btn[0] = 0;
    #1000;
    btn[1] = 1;
    #1000;
    btn[0] = 0;
    btn[1] = 0;
    #1000;
    btn[1] = 1;
    #1000;
    btn[0] = 1;
    #1000;
    btn[1] = 0;
    #1000;
    btn[0] = 0;
    #1000;
    if (count != 1) $display("Error: Expected count to be decremented to 1, got %b", count);
    else $display("Count decremented to 1 correctly");
    $finish;
  end

  // Monitor the count output
  initial begin
    $monitor("Time: %0t | clk: %b | reset: %b | btn: %b | count: %d | debug_state: %b", 
             $time, clk, reset, btn, count, debug_state);
  end

endmodule