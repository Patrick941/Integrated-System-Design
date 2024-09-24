`timescale 1ns / 1ps

module lab0_top(
      input [3:0] btn,
      output [3:0] led
  );

  // Connect two right-most switches to the two right-most LEDs
  assign led = btn;
  
endmodule
