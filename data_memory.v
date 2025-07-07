// data_memory.v
module data_memory(
    input clk,
    input [7:0] address,
    input [7:0] write_data,
    input mem_write,
    input mem_read,
    output reg [7:0] read_data
);

    reg [7:0] memory [0:255]; // 256 x 8-bit memory locations

    // Corrected: Declare loop variable 'i' outside the for loop
    integer i; // Declare 'i' as an integer for loop iteration

    // Preload memory for test cases
    initial begin
        // Initialize all memory to 0x00 first (good practice)
        for (i = 0; i < 256; i = i + 1) begin // 'i' is now already declared
            memory[i] = 8'h00;
        end

        // Data for initial LOADs in instruction_memory.v
        memory[8'h10] = 8'hAA;
        memory[8'h11] = 8'hBB;
        memory[8'h12] = 8'hCC;
        memory[8'h13] = 8'hDD;

        // Data for final LOADs to set specific values
        memory[8'h01] = 8'h01; // For LOAD R0, 0x01
        memory[8'h03] = 8'h03; // For LOAD R1, 0x03
        memory[8'h07] = 8'h07; // For LOAD R2, 0x07
        memory[8'h0F] = 8'h0F; // For LOAD R3, 0x0F

        // Addresses 0x30, 0x31, 0x32 will be written to by STORE instructions
        // and then read back by LOAD instructions to verify memory integrity.
    end

    // Combinational read: read_data is available immediately based on address
    always @(*) begin
        if (mem_read)
            read_data = memory[address];
        else
            read_data = 8'b0; // Output 0 when not reading
    end

    // Synchronous write: memory is written on the positive edge of the clock
    always @(posedge clk) begin
        if (mem_write)
            memory[address] <= write_data;
    end
endmodule