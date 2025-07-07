// control_unit.v
module control_unit(
    input [7:0] instr,
    output reg [1:0] reg_dst,        // Destination register address for write-back
    output reg [1:0] reg_read1_addr, // Address for read_data1 from register file
    output reg [1:0] reg_read2_addr, // Address for read_data2 from register file
    output reg [3:0] alu_op,         // ALU operation code

    output reg reg_write,           // Enable register file write
    output reg mem_write,           // Enable data memory write
    output reg mem_read,            // Enable data memory read
    output reg use_imm,             // Selects immediate as ALU operand B (or for address)
    output reg is_two_byte          // Indicates if the instruction is 2 bytes long
);
    // Extract opcode from the instruction (bits 7:4)
    wire [3:0] opcode = instr[7:4];

    // Combinational logic for control signals based on current instruction
    always @(*) begin
        // Default values for all control signals (important for non-matching opcodes)
        reg_write      = 0;
        mem_write      = 0;
        mem_read       = 0;
        use_imm        = 0;
        is_two_byte    = 0;
        alu_op         = 4'b0000; // Default ALU op to ADD (safe for address calculations if R0 is 0)

        // Default register addresses:
        // These defaults assume:
        //   - reg_dst for writes comes from instr[3:2]
        //   - First ALU operand (read_data1) comes from reg_dst (for Rd = Rd OP Rs type ops)
        //   - Second ALU operand (read_data2) comes from instr[1:0] (for Rd = Rd OP Rs type ops)
        reg_dst        = instr[3:2];   // Default write destination register
        reg_read1_addr = instr[3:2];   // Default for ALU input 'a'
        reg_read2_addr = instr[1:0];   // Default for ALU input 'b' when not using immediate

        // Decode instruction based on opcode
        case (opcode)
            4'b0001: begin // ADD Rd, Rs (Instruction Format: Opcode Rd Rs - Rd = Rd + Rs)
                reg_write = 1;
                alu_op = 4'b0000; // ADD operation
                // reg_dst = instr[3:2]; // Rd
                // reg_read1_addr = instr[3:2]; // Read value of Rd for ALU input 'a'
                // reg_read2_addr = instr[1:0]; // Read value of Rs for ALU input 'b'
            end
            4'b0010: begin // SUB Rd, Rs (Instruction Format: Opcode Rd Rs - Rd = Rd - Rs)
                reg_write = 1;
                alu_op = 4'b0001; // SUB operation
                // reg_dst = instr[3:2]; // Rd
                // reg_read1_addr = instr[3:2]; // Read value of Rd for ALU input 'a'
                // reg_read2_addr = instr[1:0]; // Read value of Rs for ALU input 'b'
            end
            4'b1001: begin // LOAD Rd, Imm (Instruction Format: Opcode Rd (next_byte Imm) - Rd = Mem[Imm])
                reg_write = 1;      // We will write to a register
                mem_read = 1;       // Perform a memory read
                use_imm = 1;        // The second byte is an immediate (address)
                is_two_byte = 1;    // This is a two-byte instruction
                alu_op = 4'b0000;   // Use ALU for address calculation (0 + Imm)
                reg_dst = instr[3:2];  // Destination register (Rd)
                reg_read1_addr = 2'b00; // ALU input 'a' for address calculation (e.g., R0, assumed 0)
                                        // This makes ALU calculate 0 + Immediate.
                // reg_read2_addr is not relevant for ALU B, as use_imm is 1.
            end
            4'b1101: begin // STORE Rs, Imm (Instruction Format: Opcode Rs (next_byte Imm) - Mem[Imm] = Rs)
                mem_write = 1;      // Perform a memory write
                use_imm = 1;        // The second byte is an immediate (address)
                is_two_byte = 1;    // This is a two-byte instruction
                alu_op = 4'b0000;   // Use ALU for address calculation (0 + Imm)
                // reg_dst is not used for writing here.
                reg_read1_addr = 2'b00; // ALU input 'a' for address calculation (e.g., R0, assumed 0)
                                        // This makes ALU calculate 0 + Immediate.
                reg_read2_addr = instr[3:2]; // The register (Rs) whose value is to be stored to memory
            end
            4'b1111: begin // HLT (Halt CPU)
                // No control signals asserted, handled in cpu_top
            end
            default: begin
                // No actions for undefined opcodes. All defaults are 0.
            end
        endcase
    end
endmodule