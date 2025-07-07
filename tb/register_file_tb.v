`timescale 1ns / 1ps // Define time units for simulation

module register_file_tb;

  // Testbench signals for inputs to the DUT
  reg tb_clk;
  reg tb_rst;
  reg [1:0] tb_read_reg1;
  reg [1:0] tb_read_reg2;
  reg [1:0] tb_write_reg;
  reg [7:0] tb_write_data;
  reg tb_reg_write;

  // Testbench wires for outputs from the DUT
  wire [7:0] tb_read_data1;
  wire [7:0] tb_read_data2;

  // Instantiate the Unit Under Test (UUT)
  register_file uut (
    .clk(tb_clk),
    .rst(tb_rst),
    .read_reg1(tb_read_reg1),
    .read_reg2(tb_read_reg2),
    .write_reg(tb_write_reg),
    .write_data(tb_write_data),
    .reg_write(tb_reg_write),
    .read_data1(tb_read_data1),
    .read_data2(tb_read_data2)
  );

  // Clock generation
  initial begin
    tb_clk = 0;
    forever #5 tb_clk = ~tb_clk; // Clock period of 10ns (5ns high, 5ns low)
  end

  // Initial block for stimulus generation and simulation control
  initial begin
    // Setup VCD file for waveform viewing
    $dumpfile("register_file.vcd");
    $dumpvars(0, register_file_tb); // Dump all signals in this testbench

    // Initialize all inputs to known states
    tb_rst         = 1; // Assert reset
    tb_read_reg1   = 2'b00;
    tb_read_reg2   = 2'b00;
    tb_write_reg   = 2'b00;
    tb_write_data  = 8'h00;
    tb_reg_write   = 0;

    $display("--- Starting Register File Testbench ---");

    // 1. Apply Reset
    #10; // Wait one clock cycle (or more) while reset is active
    tb_rst = 0; // De-assert reset
    #10; // Wait for the register file to come out of reset

    // At this point, all registers should be 0.
    // Let's try reading from them.
    $display("\n--- Reading after Reset ---");
    tb_read_reg1 = 2'b00; // Read R0
    tb_read_reg2 = 2'b01; // Read R1
    #10; // Wait to observe outputs

    // 2. Write to R0
    $display("\n--- Writing to R0 (0xAA) ---");
    tb_write_reg  = 2'b00;
    tb_write_data = 8'hAA;
    tb_reg_write  = 1;
    #10; // Wait for write to complete on positive edge of clk

    // 3. Write to R1
    $display("\n--- Writing to R1 (0xBB) ---");
    tb_write_reg  = 2'b01;
    tb_write_data = 8'hBB;
    tb_reg_write  = 1;
    #10;

    // 4. Write to R2
    $display("\n--- Writing to R2 (0xCC) ---");
    tb_write_reg  = 2'b10;
    tb_write_data = 8'hCC;
    tb_reg_write  = 1;
    #10;

    // 5. Read from R0 and R1 simultaneously
    $display("\n--- Reading R0 and R1 ---");
    tb_read_reg1 = 2'b00; // Read R0
    tb_read_reg2 = 2'b01; // Read R1
    tb_reg_write = 0; // Ensure no write is happening during read observation
    #10;

    // 6. Read from R2 and R3 (R3 is uninitialized/0)
    $display("\n--- Reading R2 and R3 ---");
    tb_read_reg1 = 2'b10; // Read R2
    tb_read_reg2 = 2'b11; // Read R3
    #10;

    // 7. Simultaneous Write to R0 and Read from R0 and R1
    $display("\n--- Simultaneous Write to R0 (0xDD) and Read R0, R1 ---");
    tb_write_reg  = 2'b00;
    tb_write_data = 8'hDD;
    tb_reg_write  = 1;
    tb_read_reg1  = 2'b00; // Read R0 (will see old value until next clock edge)
    tb_read_reg2  = 2'b01; // Read R1
    #10; // Wait for write to complete and observe outputs

    // 8. Verify the new value in R0
    $display("\n--- Verifying R0 after simultaneous write ---");
    tb_reg_write = 0; // Stop writing
    tb_read_reg1 = 2'b00; // Read R0 again
    tb_read_reg2 = 2'b01; // Read R1 again
    #10;

    // 9. No write, just reads
    $display("\n--- No write, just reading R2 and R0 ---");
    tb_reg_write = 0;
    tb_read_reg1 = 2'b10; // Read R2
    tb_read_reg2 = 2'b00; // Read R0
    #10;

    $display("\n--- Simulation finished ---");
    $finish; // End simulation
  end

  // Monitor block to display activity in the console
  initial begin
    $monitor("Time=%0t | CLK=%b RST=%b | R_REG1=%b R_DATA1=0x%h | R_REG2=%b R_DATA2=0x%h | W_REG=%b W_DATA=0x%h W_EN=%b",
             $time, tb_clk, tb_rst,
             tb_read_reg1, tb_read_data1,
             tb_read_reg2, tb_read_data2,
             tb_write_reg, tb_write_data, tb_reg_write);
  end

endmodule