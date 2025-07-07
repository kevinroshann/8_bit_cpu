`timescale 1ns / 1ps // Define time units for simulation

module instruction_memory_tb;

  // Testbench signals
  reg [7:0] tb_addr;   // Signal to drive the 'addr' input of the DUT
  wire [7:0] tb_data;  // Signal to capture the 'data' output from the DUT

  // Instantiate the Unit Under Test (UUT)
  instruction_memory uut (
    .addr(tb_addr),
    .data(tb_data)
  );

  // Initial block for stimulus generation and simulation control
  initial begin
    // Setup VCD file for waveform viewing
    $dumpfile("instruction_memory.vcd");
    $dumpvars(0, instruction_memory_tb); // Dump all signals in this testbench

    // Initialize address
    tb_addr = 8'h00;
    #10; // Wait for a short while for initial values to propagate

    // Test Case 1: Read instruction at address 0
    tb_addr = 8'h00;
    #10; // Wait 10ns for the read to complete

    // Test Case 2: Read instruction at address 1
    tb_addr = 8'h01;
    #10;

    // Test Case 3: Read instruction at address 2
    tb_addr = 8'h02;
    #10;

    // Test Case 4: Read instruction at an address that's not explicitly initialized
    // This will read whatever is the default value (usually X/Z or 0 depending on simulator)
    tb_addr = 8'h03;
    #10;

    // Test Case 5: Read from a higher address to demonstrate range
    tb_addr = 8'hFF; // Last address in the ROM
    #10;

    // You can add more test cases here to cover different addresses
    // For example, reading from an address within your initialized range that's not 0, 1, or 2
    // tb_addr = 8'h0A; // If you add an instruction at 0x0A
    // #10;

    // Finish simulation
    $display("Simulation finished.");
    $finish;
  end

  // Monitor block to display activity in the console
  initial begin
    $monitor("Time=%0t | Addr=0x%h | Data=0x%h", $time, tb_addr, tb_data);
  end

endmodule