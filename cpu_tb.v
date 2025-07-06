`timescale 1ns/1ps

module cpu_tb;
    reg clk;
    reg rst;

    // Instantiate the CPU
    cpu_top cpu(
        .clk(clk),
        .rst(rst)
    );

    // Clock: toggle every 5ns
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        $display("Starting CPU simulation...");
        rst = 1;
        #10;       // Wait for reset
        rst = 0;

        // Run for 100ns = 10 clock cycles
        #100;

        $display("Ending CPU simulation.");
        $finish;
    end
endmodule
