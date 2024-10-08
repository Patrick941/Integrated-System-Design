module scoreboard (
    // Declare module inputs and outputs
    input clk,
    input reset,
    input inc_exp,
    input dec_exp,
    input [3:0] count,
    input a,
    input b,
    input inc_act,
    input dec_act,
    output reg [3:0] local_count
);
    // Declare local signals for tracking counter
    reg [3:0] local_count;
    reg prev_inc_exp;
    reg prev_dec_exp;
    integer file;

    // Open file for writing
    initial begin
        file = $fopen("HVM.log", "w");
        if (file == 0) begin
            $display("Error: Could not open file.");
            $finish;
        end else begin
            $display("File opened successfully");
        end
    end

    // Create the counter logic for the expected count from the expected increment and expected decrement
    always @(posedge clk) begin
        if (reset) begin
            local_count <= 0;
        end else begin
            if (inc_exp && !prev_inc_exp && local_count != 4'b1111) begin
                local_count <= local_count + 1;
            end else if (dec_exp && !prev_dec_exp && local_count != 4'b0000) begin
                local_count <= local_count - 1;
            end
        end
        prev_inc_exp <= inc_exp;
        prev_dec_exp <= dec_exp;
    end

    // Compare the expected and actual values of the counter and write to the file
    // always @(count) begin // Reduced verbosity sensitivity list
    always @(inc_act or dec_act or count) begin
        if (local_count != count || inc_act != inc_exp || dec_act != dec_exp) begin
            $fwrite(file, "FAIL: Count: %0d, Local Count: %0d, a: %0d, b: %0d, inc_act: %0d, dec_act: %0d, Expected inc: %0d, Expected dec: %0d\n", count, local_count, a, b, inc_act, dec_act, inc_exp, dec_exp);
            $fflush(file);
        end
        else begin
            $fwrite(file, "PASS: Count: %0d, Local Count: %0d, a: %0d, b: %0d, inc_act: %0d, dec_act: %0d, Expected inc: %0d, Expected dec: %0d\n", count, local_count, a, b, inc_act, dec_act, inc_exp, dec_exp);
            $fflush(file);
        end
    end

    // Close file when simulation is done
    final begin
        $fclose(file);
        $display("File closed successfully");
    end

    // Reset the local count when reset is high
    always @(posedge reset) begin
        local_count <= 0;
    end

endmodule