// data_memory.v
module data_memory(
    input clk,
    input [7:0] address,
    input [7:0] write_data,
    input mem_write,
    input mem_read,
    output reg [7:0] read_data
);
    reg [7:0] memory [0:255];
    integer i;

    initial begin
        // Clear all memory initially
        for (i = 0; i < 256; i = i + 1) memory[i] = 8'h00;

        // Initialize data for the new test program
        // These are the values that the LOAD instructions will fetch
        memory[8'h20] = 8'h0A; // Initial value for R0
        memory[8'h21] = 8'h05; // Initial value for R1
        memory[8'h22] = 8'h02; // Initial value for R2
        memory[8'h23] = 8'h03; // Initial value for R3

        // Initialize memory locations that will be used for STORE operations.
        // They are set to 0x00 initially, but will be overwritten by STOREs.
        memory[8'h40] = 8'h00;
        memory[8'h41] = 8'h00;
        memory[8'h42] = 8'h00;
    end

    always @(*) begin
        if (mem_read)
            read_data = memory[address];
        else
            read_data = 8'h00; // Default to 0 if not reading
    end

    always @(posedge clk) begin
        if (mem_write)
            memory[address] <= write_data;
    end
endmodule
