`timescale 1ns / 1ps

module program_counter_tb;

    // Inputs
    reg clk;
    reg rst;
    reg [7:0] next_pc;

    // Output
    wire [7:0] pc;

    // Instantiate the Unit Under Test (UUT)
    program_counter uut (
        .clk(clk),
        .rst(rst),
        .next_pc(next_pc),
        .pc(pc)
    );

    // Clock generation (10 ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin

        // Initialize inputs
        rst = 1; next_pc = 8'h00;
        #10; // Apply reset
        rst = 0;

        // Apply a sequence of values
        next_pc = 8'h05; #10;
        next_pc = 8'h0A; #10;
        next_pc = 8'hFF; #10;

        // Apply reset again
        rst = 1; #10;
        rst = 0; next_pc = 8'h11; #10;

        // Finish simulation
        $stop;
    end
initial begin
    $dumpfile("pc.vcd");
    $dumpvars(0, program_counter_tb);
end

endmodule
