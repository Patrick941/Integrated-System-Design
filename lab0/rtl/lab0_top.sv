`timescale 1ns / 1ps

module lab0_top(
    input     [1:0] sw,
    output    [1:0] led
    );

  // Connect two right-most switches to the two right-most LEDs
  assign led = sw;
  
endmodule
