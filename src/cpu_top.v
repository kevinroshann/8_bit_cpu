// cpu_top.v
module cpu_top(
    input clk, // Clock input
    input rst  // Reset input (asynchronous active high)
);

    reg [7:0] pc; // Program Counter, manually managed within cpu_top
    wire [7:0] instr; // Current instruction byte fetched from memory
    wire [7:0] next_byte; // Next byte (immediate, address) fetched for two-byte instructions
    wire [7:0] pc_plus_1; // PC + 1, used to fetch the second byte

    assign pc_plus_1 = pc + 1; // Calculate PC + 1

    integer cycle = 0; // Simulation cycle counter for debugging displays

    // Control signals received from the Control Unit
    wire [1:0] reg_dst;        // Destination register address for write-back
    wire [1:0] reg_read1_addr; // Address for read_data1 from register file
    wire [1:0] reg_read2_addr; // Address for read_data2 from register file
    wire [3:0] alu_op;         // ALU operation code
    wire reg_write;            // Enable register file write
    wire mem_write;            // Enable data memory write
    wire mem_read;             // Enable data memory read
    wire use_imm;              // Selects immediate as ALU operand B (or for address)
    wire is_two_byte;          // Indicates if the instruction is 2 bytes long

    // Data paths: internal wires connecting different components
    wire [7:0] read_data1;     // Data read from register file port 1
    wire [7:0] read_data2;     // Data read from register file port 2
    wire [7:0] alu_input_a;    // Input A to ALU (muxed between register data or zero)
    wire [7:0] alu_input_b;    // Input B to ALU (muxed between register data or immediate)
    wire [7:0] alu_result;     // Output from ALU
    wire [7:0] mem_read_data;  // Data read from data memory
    wire [7:0] write_back_data; // Data to be written back to register file (muxed)

    // --- Component Instantiations ---

    // Instruction Memory: Fetches current instruction
    instruction_memory imem1 (
        .addr(pc),      // Current PC value as address
        .data(instr)    // Output current instruction
    );

    // Instruction Memory: Fetches the potential second byte (immediate/address)
    // This is always fetched, but only used if 'is_two_byte' is high.
    instruction_memory imem2 (
        .addr(pc_plus_1), // PC + 1 as address
        .data(next_byte)  // Output the next byte
    );

    // Control Unit: Decodes instruction and generates control signals
    control_unit cu (
        .instr(instr),            // Current instruction as input
        .reg_dst(reg_dst),
        .reg_read1_addr(reg_read1_addr), // Explicit read address 1 from CU
        .reg_read2_addr(reg_read2_addr), // Explicit read address 2 from CU
        .alu_op(alu_op),
        .reg_write(reg_write),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .use_imm(use_imm),
        .is_two_byte(is_two_byte)
    );

    // Register File: Stores and provides register values
    register_file rf (
        .clk(clk),
        .rst(rst),
        .read_reg1(reg_read1_addr),     // Connect to explicit read address 1 from CU
        .read_reg2(reg_read2_addr),     // Connect to explicit read address 2 from CU
        .write_reg(reg_dst),            // Destination for write (from CU)
        .write_data(write_back_data),   // Data to write (from write-back mux)
        .reg_write(reg_write),          // Write enable (from CU)
        .read_data1(read_data1),        // Output: data from read_reg1
        .read_data2(read_data2)         // Output: data from read_reg2
    );

    // ALU Input A Multiplexer:
    // For LOAD/STORE (mem_read or mem_write active), ALU 'a' input is 0 (for absolute addressing).
    // For other ops (like ADD/SUB), ALU 'a' input comes from read_data1 (value of Rd).
    assign alu_input_a = (mem_read || mem_write) ? 8'b0 : read_data1;

    // ALU Input B Multiplexer:
    // Selects between immediate (next_byte) or register data (read_data2) for ALU's 'b' input.
    assign alu_input_b = use_imm ? next_byte : read_data2;

    // ALU: Performs arithmetic/logic operations
    alu alu_unit (
        .a(alu_input_a),         // Input A to ALU (from new mux)
        .b(alu_input_b),         // Input B to ALU (from mux)
        .alu_op(alu_op),         // ALU operation (from CU)
        .result(alu_result)      // Output: ALU result
    );

    // Data Memory: Handles memory read/write operations
    data_memory dmem (
        .clk(clk),
        .address(alu_result),    // Memory address (usually from ALU result)
        .write_data(read_data2), // Data to write to memory (e.g., value of Rs for STORE)
        .mem_write(mem_write),   // Memory write enable (from CU)
        .mem_read(mem_read),     // Memory read enable (from CU)
        .read_data(mem_read_data) // Output: data read from memory
    );

    // Write-back Multiplexer:
    // Selects the data source to write back to the register file.
    // Either data from memory (for LOAD) or the ALU result (for ADD/SUB).
    assign write_back_data = mem_read ? mem_read_data : alu_result;

    // --- PC Update and Simulation Control ---

    // Sequential logic for PC update and simulation cycle tracking
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc <= 8'b0;      // Reset PC to 0 upon reset
            cycle <= 0;      // Reset cycle counter
        end else begin
            // Debugging displays for current cycle information
            $display("----- Cycle %0d (PC: 0x%h) -----", cycle, pc);
            $display("Instruction: 0x%h (%b)", instr, instr);
            if (is_two_byte) begin
                $display("  Immediate/Next Byte: 0x%h", next_byte);
            end
            $display("  Reg Read1 (R%0d): 0x%h, Reg Read2 (R%0d): 0x%h", reg_read1_addr, read_data1, reg_read2_addr, read_data2);
            $display("  ALU Input A: 0x%h, ALU Input B: 0x%h", alu_input_a, alu_input_b); // Added for more detailed debug
            $display("  ALU Result: 0x%h", alu_result);

            if (mem_read) begin
                $display("  LOAD: Data from Mem[0x%h] = 0x%h", alu_result, mem_read_data);
            end
            if (mem_write) begin
                $display("  STORE: Writing 0x%h to Mem[0x%h]", read_data2, alu_result);
            end
            if (reg_write) begin
                $display("  WRITE BACK: 0x%h to Reg[R%0d]", write_back_data, reg_dst);
            end
            $display(" "); // Blank line for readability

            // Check for HLT instruction to terminate simulation
            if (instr == 8'b11110000) begin
                $display("-------------------------------");
                $display("HLT instruction encountered. Simulation finished.");
                $display("Final Register State:");
                $display("Reg[0] = 0x%h", rf.reg_file[0]); // Accessing internal reg_file array directly for display
                $display("Reg[1] = 0x%h", rf.reg_file[1]);
                $display("Reg[2] = 0x%h", rf.reg_file[2]);
                $display("Reg[3] = 0x%h", rf.reg_file[3]);
                $finish; // End the simulation
            end

            // Increment Program Counter for the next instruction fetch
            pc <= pc + (is_two_byte ? 2 : 1);
            cycle <= cycle + 1; // Increment cycle counter
        end
    end
endmodule