`timescale 1ns / 1ps // Define time units for simulation

module data_memory_tb;

  // Testbench signals for inputs to the DUT
  reg         tb_clk;
  reg [7:0]   tb_address;
  reg [7:0]   tb_write_data;
  reg         tb_mem_write;
  reg         tb_mem_read;

  // Testbench wire for output from the DUT
  wire [7:0]  tb_read_data;

  // Instantiate the Unit Under Test (UUT)
  data_memory uut (
    .clk(tb_clk),
    .address(tb_address),
    .write_data(tb_write_data),
    .mem_write(tb_mem_write),
    .mem_read(tb_mem_read),
    .read_data(tb_read_data)
  );

  // Clock generation
  initial begin
    tb_clk = 0;
    forever #5 tb_clk = ~tb_clk; // Clock period of 10ns (5ns high, 5ns low)
  end

  // Initial block for stimulus generation and simulation control
  initial begin
    // Setup VCD file for waveform viewing
    $dumpfile("data_memory.vcd");
    $dumpvars(0, data_memory_tb); // Dump all signals in this testbench

    $display("--- Starting Data Memory Testbench ---");

    // Initialize all inputs to known states
    tb_address    = 8'h00;
    tb_write_data = 8'h00;
    tb_mem_write  = 0;
    tb_mem_read   = 0;

    #10; // Let initial values settle

    // 1. Read from an uninitialized address (should be 0 or X/Z)
    $display("\n--- Test 1: Read from uninitialized address (0x00) ---");
    tb_address    = 8'h00;
    tb_mem_read   = 1;
    tb_mem_write  = 0;
    #10; // Observe read_data (should be 0x00 as per your 'else' in read logic)

    // 2. Write to address 0x00
    $display("\n--- Test 2: Write 0xAA to address 0x00 ---");
    tb_address    = 8'h00;
    tb_write_data = 8'hAA;
    tb_mem_write  = 1;
    tb_mem_read   = 0; // Ensure read is off during write
    #10; // Wait for write to occur on positive edge of clk

    // 3. Read from address 0x00 to verify write
    $display("\n--- Test 3: Read from address 0x00 to verify 0xAA ---");
    tb_address    = 8'h00;
    tb_mem_write  = 0;
    tb_mem_read   = 1;
    #10; // Observe read_data (should be 0xAA)

    // 4. Write to address 0x10
    $display("\n--- Test 4: Write 0xBB to address 0x10 ---");
    tb_address    = 8'h10;
    tb_write_data = 8'hBB;
    tb_mem_write  = 1;
    tb_mem_read   = 0;
    #10;

    // 5. Read from address 0x10 to verify write
    $display("\n--- Test 5: Read from address 0x10 to verify 0xBB ---");
    tb_address    = 8'h10;
    tb_mem_write  = 0;
    tb_mem_read   = 1;
    #10;

    // 6. Write to address 0xFF (last address)
    $display("\n--- Test 6: Write 0xCC to address 0xFF ---");
    tb_address    = 8'hFF;
    tb_write_data = 8'hCC;
    tb_mem_write  = 1;
    tb_mem_read   = 0;
    #10;

    // 7. Read from address 0xFF
    $display("\n--- Test 7: Read from address 0xFF to verify 0xCC ---");
    tb_address    = 8'hFF;
    tb_mem_write  = 0;
    tb_mem_read   = 1;
    #10;

    // 8. Read from an address that was not written to (e.g., 0x01)
    $display("\n--- Test 8: Read from unwritten address 0x01 ---");
    tb_address    = 8'h01;
    tb_mem_write  = 0;
    tb_mem_read   = 1;
    #10; // Should be 0x00

    // 9. Simultaneous Read and Write (Write to 0x00, Read from 0x00)
    // The read_data will show the OLD value of memory[0x00] until the write completes on posedge clk.
    // After the posedge clk, read_data will immediately show the NEW value.
    $display("\n--- Test 9: Simultaneous Write to 0x00 (0xDD) and Read from 0x00 ---");
    tb_address    = 8'h00;
    tb_write_data = 8'hDD;
    tb_mem_write  = 1;
    tb_mem_read   = 1;
    #10; // Observe read_data (should change from 0xAA to 0xDD on posedge clk)

    // 10. No operation (mem_write=0, mem_read=0)
    $display("\n--- Test 10: No operation ---");
    tb_address    = 8'h05; // Change address just to show it
    tb_write_data = 8'hEE;
    tb_mem_write  = 0;
    tb_mem_read   = 0; // read_data should become 0x00
    #10;

    $display("\n--- Simulation finished ---");
    $finish; // End simulation
  end

  // Monitor block to display activity in the console
  initial begin
    $monitor("Time=%0t | CLK=%b | ADDR=0x%h | W_DATA=0x%h | MEM_W=%b | MEM_R=%b | R_DATA=0x%h",
             $time, tb_clk, tb_address, tb_write_data, tb_mem_write, tb_mem_read, tb_read_data);
  end

endmodule