// instruction_memory.v
module instruction_memory(
    input  [7:0] addr,
    output reg [7:0] data
);
    reg [7:0] memory [0:255];

    always @(*) begin
        data = memory[addr];
    end

    initial begin
        // New Test Program:
        // This program will:
        // 1. Load some initial values into R0, R1, R2.
        // 2. Perform a mix of ADD and SUB operations.
        // 3. Store results to different memory locations.
        // 4. Reload some values to verify memory writes.
        // 5. Perform more operations.
        // 6. Halt.

        // Initialize registers with specific values from memory
        memory[8'h00] = 8'b10010000; memory[8'h01] = 8'h20; // LOAD R0, 0x20 (R0 = 0x0A)
        memory[8'h02] = 8'b10010100; memory[8'h03] = 8'h21; // LOAD R1, 0x21 (R1 = 0x05)
        memory[8'h04] = 8'b10011000; memory[8'h05] = 8'h22; // LOAD R2, 0x22 (R2 = 0x02)

        // Perform arithmetic operations
        memory[8'h06] = 8'b00010001;                       // ADD R0, R1 (R0 = R0 + R1 = 0x0A + 0x05 = 0x0F)
        memory[8'h07] = 8'b00100010;                       // SUB R0, R2 (R0 = R0 - R2 = 0x0F - 0x02 = 0x0D)
        memory[8'h08] = 8'b00010100;                       // ADD R1, R0 (R1 = R1 + R0 = 0x05 + 0x0D = 0x12)
        memory[8'h09] = 8'b00101001;                       // SUB R2, R1 (R2 = R2 - R1 = 0x02 - 0x12 = 0xF0 (2's complement of 16))

        // Store results to new memory locations
        memory[8'h0A] = 8'b11010000; memory[8'h0B] = 8'h40; // STORE R0, 0x40 (Mem[0x40] = 0x0D)
        memory[8'h0C] = 8'b11010100; memory[8'h0D] = 8'h41; // STORE R1, 0x41 (Mem[0x41] = 0x12)
        memory[8'h0E] = 8'b11011000; memory[8'h0F] = 8'h42; // STORE R2, 0x42 (Mem[0x42] = 0xF0)

        // Reload values from memory to verify stores
        memory[8'h10] = 8'b10010000; memory[8'h11] = 8'h40; // LOAD R0, 0x40 (R0 = 0x0D)
        memory[8'h12] = 8'b10010100; memory[8'h13] = 8'h41; // LOAD R1, 0x41 (R1 = 0x12)
        memory[8'h14] = 8'b10011000; memory[8'h15] = 8'h42; // LOAD R2, 0x42 (R2 = 0xF0)

        // More arithmetic operations with reloaded values
        memory[8'h16] = 8'b00010001;                       // ADD R0, R1 (R0 = 0x0D + 0x12 = 0x1F)
        memory[8'h17] = 8'b00100110;                       // SUB R1, R2 (R1 = 0x12 - 0xF0 = 0x12 - (-0x10) = 0x12 + 0x10 = 0x22)

        // Load R3 with a value and perform one last operation
        memory[8'h18] = 8'b10011100; memory[8'h19] = 8'h23; // LOAD R3, 0x23 (R3 = 0x03)
        memory[8'h1A] = 8'b00010011;                       // ADD R0, R3 (R0 = 0x1F + 0x03 = 0x22)

        // Halt instruction
        memory[8'h1B] = 8'b11110000;                       // HLT

        // Data for LOAD instructions (initial values)
        memory[8'h20] = 8'h0A; // Initial value for R0
        memory[8'h21] = 8'h05; // Initial value for R1
        memory[8'h22] = 8'h02; // Initial value for R2
        memory[8'h23] = 8'h03; // Initial value for R3

        // Memory locations for STORE operations (will be overwritten)
        memory[8'h40] = 8'h00;
        memory[8'h41] = 8'h00;
        memory[8'h42] = 8'h00;
    end
endmodule
