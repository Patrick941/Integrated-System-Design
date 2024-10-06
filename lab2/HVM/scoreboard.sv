module scoreboard (
    input clk,
    input reset,
    input inc_exp,
    input dec_exp,
    input [3:0] count
);
    reg [3:0] local_count;

    reg prev_inc_exp;
    reg prev_dec_exp;
    integer file;

    initial begin
        file = $fopen("HVM.log", "w");
        if (file == 0) begin
            $display("Error: Could not open file.");
            $finish;
        end else begin
            $display("File opened successfully");
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            local_count <= 0;
        end else begin
            if (inc_exp && !prev_inc_exp) begin
                local_count <= local_count + 1;
            end else if (dec_exp && !prev_dec_exp) begin
                local_count <= local_count - 1;
            end
        end
        prev_inc_exp <= inc_exp;
        prev_dec_exp <= dec_exp;
    end

    always @(posedge inc_exp or posedge dec_exp) begin
        $fwrite(file, "Count: %0d, Local Count: %0d\n", count, local_count);
        $fflush(file);
    end

    final begin
        $fclose(file);
        $display("File closed successfully");
    end

    always @(posedge reset) begin
        local_count <= 0;
    end

endmodule