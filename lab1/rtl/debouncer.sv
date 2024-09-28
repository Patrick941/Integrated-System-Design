`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/17/2016 05:01:56 PM
// Design Name: 
// Module Name: debouncer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module debouncer #(parameter threshold = 100000 )// set parameter thresehold to guage how long button pressed
  (input      clk, //clock signal
   input      reset,
   input      button, //input button
   output reg button_db //debounced signal to logic analyzer
);
    
  reg button_ff1   = 0; //button flip-flop for synchronization. Initialize it to 0
  reg button_ff2   = 0; //button flip-flop for synchronization. Initialize it to 0
  reg [20:0] count = 0; //20 bits count for increment & decrement when button is pressed or released. Initialize it to 0 
  
  // First use two flip-flops to synchronize the button signal the "clk" clock domain
  
  always @(posedge clk or posedge reset) begin 
    if (reset) begin 
      button_ff1 <= 1'b0;
      button_ff2 <= 1'b0; 
    end else begin 
      button_ff1 <= button;
      button_ff2 <= button_ff1; 
    end
  end
  
  // When the push-button is pushed or released, we increment or decrement the counter
  // The counter has to reach threshold before we decide that the push-button state has changed
  always @(posedge clk) begin 
    if (button_ff2) begin //if button_ff2 is 1 
      if (~&count) begin//if it isn't at the count limit. Make sure won't count up at the limit. First AND all count and then not the AND 
        count <= count+1;
      end 
    end else begin 
      if (|count) begin//if count has at least 1 in it. Make sure no subtraction when count is 0 
        count <= count-1; //when btn relesed, count down 
      end 
    end 
    if (count > threshold) begin//if the count is greater the threshold 
      button_db <= 1; //debounced signal is 1 
    end else begin 
      button_db <= 0; //debounced signal is 0 
    end
  end


endmodule
