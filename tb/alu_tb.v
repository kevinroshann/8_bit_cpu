`timescale 1ns / 1ps // Define time units for simulation

module alu_tb;

  // Testbench signals for inputs to the DUT
  reg [7:0] tb_a;
  reg [7:0] tb_b;
  reg       tb_alu_op; // 0 = ADD, 1 = SUB

  // Testbench wire for output from the DUT
  wire [7:0] tb_result;

  // NEW: Intermediate wire for the operation name (to satisfy $monitor's requirement)
  wire [3:0] op_name; // Enough bits to represent "ADD" or "SUB" (e.g., 4 characters)

  // Continuous assignment to set the op_name based on tb_alu_op
  assign op_name = (tb_alu_op == 1'b0) ? "ADD" : "SUB"; // Use string literals for clarity

  // Instantiate the Unit Under Test (UUT)
  alu uut (
    .a(tb_a),
    .b(tb_b),
    .alu_op(tb_alu_op),
    .result(tb_result)
  );

  // Initial block for stimulus generation and simulation control
  initial begin
    // Setup VCD file for waveform viewing
    $dumpfile("alu.vcd");
    $dumpvars(0, alu_tb); // Dump all signals in this testbench

    $display("--- Starting ALU Testbench ---");

    // Test Case 1: Addition (0 + 0)
    tb_a = 8'h00;
    tb_b = 8'h00;
    tb_alu_op = 1'b0; // ADD
    #10; // Wait for result to propagate

    // Test Case 2: Addition (5 + 3)
    tb_a = 8'd5;
    tb_b = 8'd3;
    tb_alu_op = 1'b0; // ADD
    #10;

    // Test Case 3: Addition (10 + 20)
    tb_a = 8'd10;
    tb_b = 8'd20;
    tb_alu_op = 1'b0; // ADD
    #10;

    // Test Case 4: Addition (Max value + 1 - demonstrates overflow)
    // 255 + 1 = 256. For 8-bit, this will wrap around to 0.
    tb_a = 8'hFF; // 255
    tb_b = 8'h01; // 1
    tb_alu_op = 1'b0; // ADD
    #10;

    // Test Case 5: Subtraction (5 - 3)
    tb_a = 8'd5;
    tb_b = 8'd3;
    tb_alu_op = 1'b1; // SUB
    #10;

    // Test Case 6: Subtraction (10 - 20 - demonstrates underflow/wrap-around)
    // 10 - 20 = -10. For 8-bit unsigned, this is 256 - 10 = 246 (0xF6).
    tb_a = 8'd10;
    tb_b = 8'd20;
    tb_alu_op = 1'b1; // SUB
    #10;

    // Test Case 7: Subtraction (0 - 1 - demonstrates underflow)
    // 0 - 1 = -1. For 8-bit unsigned, this is 256 - 1 = 255 (0xFF).
    tb_a = 8'h00;
    tb_b = 8'h01;
    tb_alu_op = 1'b1; // SUB
    #10;

    // Test Case 8: Another addition with larger numbers
    tb_a = 8'd100;
    tb_b = 8'd120;
    tb_alu_op = 1'b0; // ADD
    #10;

    // Test Case 9: Another subtraction with larger numbers
    tb_a = 8'd200;
    tb_b = 8'd50;
    tb_alu_op = 1'b1; // SUB
    #10;

    // Test Case 10: Subtraction resulting in zero
    tb_a = 8'd75;
    tb_b = 8'd75;
    tb_alu_op = 1'b1; // SUB
    #10;

    $display("\n--- Simulation finished ---");
    $finish; // End simulation
  end

  // Monitor block to display activity in the console
  initial begin
    $monitor("Time=%0t | A=0x%h (%0d) | B=0x%h (%0d) | OP=%b (%s) | RESULT=0x%h (%0d)",
             $time,
             tb_a, tb_a,
             tb_b, tb_b,
             tb_alu_op, op_name, // Now passing the simple wire 'op_name'
             tb_result, tb_result);
  end

endmodule