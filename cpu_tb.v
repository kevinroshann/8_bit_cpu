// cpu_tb.v
// Testbench for the 8-bit CPU

module cpu_tb;

    // Clock and Reset signals
    reg clk;
    reg rst;

    // Instantiate the CPU Top module
    cpu_top cpu (
        .clk(clk),
        .rst(rst)
    );

    // Clock generation
    initial begin
        clk = 0; // Initialize clock to 0
        forever #5 clk = ~clk; // Toggle clock every 5 time units (10ns period)
    end

    // Reset sequence and simulation control
    initial begin
        rst = 1; // Assert reset
        #10 rst = 0; // De-assert reset after 10ns

        // Keep the simulation running for a sufficiently long time.
        // The CPU's HLT instruction should ideally trigger $finish.
        // If the HLT instruction is not reached due to a CPU bug,
        // this $finish will prevent infinite simulation.
        // This value (200 * 10 = 2000ns = 200000 ps) should be more than enough for this program.
        // The previous program finished at 75000 (1ps), this program is longer.
        #2000 $finish; // Max simulation time: 200 clock cycles (200 * 10ns = 2000ns = 2000000 ps)
                       // You had 110000 (1ps), which is 110ns. My previous calc: 22 cycles * 10ns = 220ns.
                       // So 2000 should be ample.

    end

    // Optional: Monitor signals for debugging (can be uncommented if needed)
    // initial begin
    //     $monitor("Time: %0t | PC: 0x%h | Instr: 0x%h | R0: 0x%h | R1: 0x%h | R2: 0x%h | R3: 0x%h",
    //              $time, cpu.pc, cpu.instr, cpu.rf.reg_file[0], cpu.rf.reg_file[1], cpu.rf.reg_file[2], cpu.rf.reg_file[3]);
    // end

endmodule