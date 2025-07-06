`timescale 1ns / 1ps // Define time units for simulation

module control_unit_tb;

  // Testbench signals for inputs to the DUT
  reg [7:0] tb_instr;

  // Testbench wires for outputs from the DUT
  wire [1:0] tb_reg_dst;
  wire [1:0] tb_reg_src;
  wire       tb_alu_op;
  wire       tb_reg_write;
  wire       tb_mem_write;
  wire       tb_mem_read;
  wire       tb_use_imm;
  wire       tb_is_two_byte;

  // Instantiate the Unit Under Test (UUT)
  control_unit uut (
    .instr(tb_instr),
    .reg_dst(tb_reg_dst),
    .reg_src(tb_reg_src),
    .alu_op(tb_alu_op),
    .reg_write(tb_reg_write),
    .mem_write(tb_mem_write),
    .mem_read(tb_mem_read),
    .use_imm(tb_use_imm),
    .is_two_byte(tb_is_two_byte)
  );

  // Initial block for stimulus generation and simulation control
  initial begin
    // Setup VCD file for waveform viewing
    $dumpfile("control_unit.vcd");
    $dumpvars(0, control_unit_tb); // Dump all signals in this testbench

    $display("--- Starting Control Unit Testbench ---");

    // Initialize instruction to a known default
    tb_instr = 8'h00;
    #10; // Let initial values settle

    // --- Test R-type instructions (opcode 2'b00) ---
    // Instruction format: 00_DD_SS_OA (Opcode_DestReg_SrcReg_ALUOp)

    $display("\n--- Test R-type: ADD R1, R2 (instr = 00_01_10_00 = 8'h18) ---");
    tb_instr = 8'b00_01_10_00; // ADD R1, R2 (R_DST=R1, R_SRC=R2, ALU_OP=ADD)
    #10;

    $display("\n--- Test R-type: SUB R3, R0 (instr = 00_11_00_01 = 8'h31) ---");
    tb_instr = 8'b00_11_00_01; // SUB R3, R0 (R_DST=R3, R_SRC=R0, ALU_OP=SUB)
    #10;

    $display("\n--- Test R-type: ADD R0, R3 (instr = 00_00_11_00 = 8'h0C) ---");
    tb_instr = 8'b00_00_11_00; // ADD R0, R3 (R_DST=R0, R_SRC=R3, ALU_OP=ADD)
    #10;

    // --- Test I-type instructions (opcode 2'b10) ---
    // Format: 10_SS_DD_XX (Opcode_Subcode_Reg_Imm_Placeholder)
    // For LOAD/MOVI: 10_00_DD_XX (LOAD R_d, Imm) or 10_01_DD_XX (MOVI R_d, Imm)
    // For JMP: 10_10_XX_XX (JMP Imm)
    // R_d = instr[3:2], Imm is next byte
    // subcode = instr[5:4]

    $display("\n--- Test I-type: LOAD R1, Immediate_Address (instr = 10_00_01_xx = 8'h84) ---");
    tb_instr = 8'b10_00_01_00; // LOAD R1, ... (R_DST=R1, MEM_READ=1, REG_WRITE=1, USE_IMM=1, IS_TWO_BYTE=1)
    #10;

    $display("\n--- Test I-type: MOVI R2, Immediate_Value (instr = 10_01_10_xx = 8'h98) ---");
    tb_instr = 8'b10_01_10_00; // MOVI R2, ... (R_DST=R2, REG_WRITE=1, USE_IMM=1, IS_TWO_BYTE=1)
    #10;

    $display("\n--- Test I-type: JMP Immediate_Address (instr = 10_10_xx_xx = 8'hA0) ---");
    tb_instr = 8'b10_10_00_00; // JMP ... (IS_TWO_BYTE=1)
    #10;

    // --- Test STORE instruction (opcode 2'b11) ---
    // Format: 11_XX_SS_XX (Opcode_Placeholder_SrcReg_Imm_Placeholder)
    // STORE R_s, Immediate_Address
    // R_s = instr[3:2], Imm is next byte

    $display("\n--- Test STORE: STORE R3, Immediate_Address (instr = 11_xx_11_xx = 8'hC3) ---");
    tb_instr = 8'b11_00_11_00; // STORE R3, ... (R_SRC=R3, MEM_WRITE=1, USE_IMM=1, IS_TWO_BYTE=1)
    #10;

    // --- Test an unknown/default instruction ---
    $display("\n--- Test Unknown Opcode (e.g., 2'b01 which is undefined) (instr = 01_xx_xx_xx = 8'h40) ---");
    tb_instr = 8'b01_00_00_00; // Should result in all default (0) outputs
    #10;

    $display("\n--- Simulation finished ---");
    $finish; // End simulation
  end

  // Monitor block to display activity in the console
  initial begin
    $monitor("Time=%0t | INSTR=0x%h (OP=%b SUB=%b) | RDST=%b RSRC=%b ALU_OP=%b | REG_W=%b MEM_W=%b MEM_R=%b | USE_IMM=%b TWO_BYTE=%b",
             $time, tb_instr, tb_instr[7:6], tb_instr[5:4],
             tb_reg_dst, tb_reg_src, tb_alu_op,
             tb_reg_write, tb_mem_write, tb_mem_read,
             tb_use_imm, tb_is_two_byte);
  end

endmodule